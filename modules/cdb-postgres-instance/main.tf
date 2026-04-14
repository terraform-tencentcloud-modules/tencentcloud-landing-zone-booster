locals {
  create_kms_key = try(var.create_kms_key) != null ? var.create_kms_key : false
}

resource "random_password" "this" {
  count = try(length(var.password), 0) > 0 ? 0 : 1

  length  = var.random_password_length
  special = var.random_password_special

  min_upper        = var.random_password_min_upper
  min_lower        = var.random_password_min_lower
  min_numeric      = var.random_password_min_numeric
  min_special      = var.random_password_min_special
  override_special = "!@#%^*()_"
}

resource "random_password" "users" {
  for_each = { for idx, name in try(keys(var.users), []) :
    name => {
      password = try(var.users[name].password, "")
    }
  }

  length  = var.random_password_length
  special = var.random_password_special

  min_upper        = var.random_password_min_upper
  min_lower        = var.random_password_min_lower
  min_numeric      = var.random_password_min_numeric
  min_special      = var.random_password_min_special
  override_special = "!@#%^*()_"
}

resource "tencentcloud_kms_key" "this" {
  count                = local.create_kms_key ? 1 : 0
  alias                = "${var.name}-kms-key"
  description          = "KMS key for ${var.name}"
  key_rotation_enabled = false
  is_enabled           = true

  tags = var.tags
}

resource "tencentcloud_security_group" "this" {
  name        = "${var.name}-sg"
  description = "This is security group for PostgreSQL instances"
  tags        = var.tags
}

resource "tencentcloud_security_group_rule_set" "this" {
  security_group_id = tencentcloud_security_group.this.id

  dynamic "ingress" {
    for_each = var.allow_cidr_list
    content {
      action     = "ACCEPT"
      cidr_block = ingress.value
      protocol   = "TCP"
      port       = var.port
    }
  }
}

resource "tencentcloud_postgresql_instance" "this" {
  name              = var.name
  availability_zone = coalesce(var.availability_zones).0
  charge_type       = "POSTPAID_BY_HOUR"
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id

  db_major_version = var.db_major_version
  root_password    = try(length(var.password), 0) > 0 ? var.password : random_password.this.0.result
  charset          = "UTF8"
  cpu              = var.cpu
  memory           = var.memory
  storage          = var.storage

  security_groups = [tencentcloud_security_group.this.id]

  backup_plan {
    backup_period = var.backup_period
    #    base_backup_retention_period = var.backup_retention_period  FIXME : bug
    min_backup_start_time = var.backup_min_start_time
    max_backup_start_time = var.backup_max_start_time
  }

  dynamic "db_node_set" {
    for_each = var.availability_zones

    content {
      role = coalesce(var.availability_zones).0 == db_node_set.value ? "Primary" : "Standby"
      zone = db_node_set.value
    }
  }

  kms_key_id       = local.create_kms_key ? tencentcloud_kms_key.this.0.id : null
  kms_region       = local.create_kms_key ? "ap-singapore" : null
  need_support_tde = local.create_kms_key ? 1 : 0

  tags = var.tags
}

resource "tencentcloud_postgresql_readonly_group" "this" {
  count = var.readonly_instances > 0 ? 1 : 0

  master_db_instance_id       = tencentcloud_postgresql_instance.this.id
  name                        = "${var.name}-ro-group"
  project_id                  = 0
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  replay_lag_eliminate        = 1
  replay_latency_eliminate    = 1
  max_replay_lag              = 100
  max_replay_latency          = 512
  min_delay_eliminate_reserve = 1
}

resource "tencentcloud_postgresql_readonly_instance" "this" {
  count = var.readonly_instances

  read_only_group_id    = tencentcloud_postgresql_readonly_group.this.0.id
  master_db_instance_id = tencentcloud_postgresql_instance.this.id
  zone                  = coalesce(var.availability_zones).0
  name                  = "${var.name}-ro-${count.index}"
  auto_renew_flag       = 0
  db_version            = tencentcloud_postgresql_instance.this.engine_version
  instance_charge_type  = "POSTPAID_BY_HOUR"
  memory                = try(var.ro_memory) != null ? var.ro_memory : var.memory
  cpu                   = try(var.ro_cpu) != null ? var.ro_cpu : var.cpu
  storage               = try(var.ro_storage) != null ? var.ro_storage : var.storage
  vpc_id                = var.vpc_id
  subnet_id             = var.subnet_id
  need_support_ipv6     = 0
  project_id            = 0
  security_groups_ids = [
    tencentcloud_security_group.this.id,
  ]
}

resource "tencentcloud_postgresql_parameters" "postgresql_parameters" {
  db_instance_id = tencentcloud_postgresql_instance.this.id

  param_list {
    expected_value = "UTC"
    name           = "timezone"
  }
}

resource "tencentcloud_postgresql_account" "users" {
  for_each = { for idx, name in try(keys(var.users), []) :
    name => {
      password = try(var.users[name].password, "")
      type     = try(var.users[name].type, "normal")
    }
  }

  db_instance_id = tencentcloud_postgresql_instance.this.id
  user_name      = each.key
  password       = try(length(each.value.password), 0) > 0 ? each.value.password : random_password.users[each.key].result
  type           = try(length(each.value.type), 0) > 0 ? each.value.type : "normal"
}
