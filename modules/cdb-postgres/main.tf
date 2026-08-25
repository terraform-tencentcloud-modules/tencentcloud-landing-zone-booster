################################################################################
### PostgreSQL database resources
################################################################################
resource "tencentcloud_postgresql_instance" "master" {
  name                        = var.postgres_instance.name
  availability_zone           = var.postgres_instance.availability_zone
  charge_type                 = var.postgres_instance.charge_type
  period                      = var.postgres_instance.period
  auto_renew_flag             = var.postgres_instance.auto_renew_flag
  auto_voucher                = var.postgres_instance.auto_voucher
  vpc_id                      = var.postgres_instance.vpc_id
  subnet_id                   = var.postgres_instance.subnet_id
  engine_version              = var.postgres_instance.engine_version
  root_user                   = var.root_user
  root_password               = var.root_password == "" ? random_password.secure_password[0].result : var.root_password
  charset                     = var.postgres_instance.charset
  project_id                  = var.postgres_instance.project_id
  security_groups             = var.postgres_instance.security_groups
  cpu                         = var.postgres_instance.cpu
  memory                      = var.postgres_instance.memory
  storage                     = var.postgres_instance.storage
  db_kernel_version           = var.postgres_instance.db_kernel_version
  need_support_tde            = var.postgres_instance.need_support_tde
  kms_key_id                  = var.postgres_instance.kms_key_id
  kms_region                  = var.postgres_instance.kms_region
  delete_protection           = var.postgres_instance.delete_protection
  max_standby_streaming_delay = var.postgres_instance.max_standby_streaming_delay
  max_standby_archive_delay   = var.postgres_instance.max_standby_archive_delay

  db_node_set {
    role = "Primary"
    zone = var.postgres_instance.availability_zone
  }

  db_node_set {
    zone = var.postgres_instance.standby_availability_zone
  }

  tags = var.tags
}

# Generate a random password for the root user if not provided
resource "random_password" "secure_password" {
  count = var.root_password == null || var.root_password == "" ? 1 : 0

  length  = var.postgres_instance.password_length
  special = true
  upper   = true
  lower   = true
  numeric = true

  keepers = var.root_password_rotation_months > 0 ? {
    rotation_trigger = time_rotating.rotation[0].id
  } : {}
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

resource "time_rotating" "rotation" {
  count = (var.root_password == null || var.root_password == "") && var.root_password_rotation_months > 0 ? 1 : 0

  rotation_months = var.root_password_rotation_months
}

resource "tencentcloud_postgresql_instance_ssl_config" "ssl_config" {
  count = var.postgres_instance.ssl_enable ? 1 : 0

  db_instance_id  = tencentcloud_postgresql_instance.master.id
  ssl_enabled     = var.postgres_instance.ssl_enable
  connect_address = tencentcloud_postgresql_instance.master.private_access_ip

  depends_on = [tencentcloud_postgresql_instance.master]
}

# Create secret storing PostgreSQL credentials
resource "tencentcloud_ssm_secret" "postgres_creds" {
  count = var.store_credentials_in_ssm ? 1 : 0

  secret_name = "${var.postgres_instance.name}-root-secret"
  description = "PostgreSQL credentials for ${var.postgres_instance.name}"
  tags        = var.tags

  depends_on = [tencentcloud_postgresql_instance.master]
}

resource "tencentcloud_ssm_secret_version" "v1" {
  count       = var.store_credentials_in_ssm ? 1 : 0
  secret_name = tencentcloud_ssm_secret.postgres_creds[0].secret_name
  version_id  = "v1"
  secret_string = jsonencode({
    username = var.root_user
    password = var.root_password == "" ? random_password.secure_password[0].result : var.root_password
    port     = 5432
    host     = tencentcloud_postgresql_instance.master.private_access_ip
  })
}

resource "tencentcloud_postgresql_parameters" "postgresql_parameters" {
  count = var.postgresql_parameters != null ? 1 : 0

  db_instance_id = tencentcloud_postgresql_instance.master.id
  dynamic "param_list" {
    for_each = var.postgresql_parameters
    content {
      name           = param_list.value.name
      expected_value = param_list.value.value
    }
  }
}

resource "tencentcloud_postgresql_account" "users" {
  for_each = { for idx, name in try(keys(var.users), []) :
    name => {
      password = try(var.users[name].password, "")
      type     = try(var.users[name].type, "normal")
    }
  }

  db_instance_id = tencentcloud_postgresql_instance.master.id
  user_name      = each.key
  password       = try(length(each.value.password), 0) > 0 ? each.value.password : random_password.users[each.key].result
  type           = try(length(each.value.type), 0) > 0 ? each.value.type : "normal"
}

# resource "tencentcloud_postgresql_backup_plan" "plan" {
#   for_each = var.postgres_instance.backup_plan != null ? var.postgres_instance.backup_plan : {}

#   db_instance_id               = tencentcloud_postgresql_instance.master.id
#   plan_name                    = each.value.plan_name
#   backup_period_type           = each.value.period_type
#   backup_period                = each.value.period
#   min_backup_start_time        = each.value.min_backup_start_time
#   max_backup_start_time        = each.value.max_backup_start_time
#   base_backup_retention_period = each.value.base_backup_retention_period
#   log_backup_retention_period  = each.value.log_backup_retention_period
#   backup_method                = each.value.backup_method
# }

resource "tencentcloud_postgresql_backup_plan_config" "plan_config" {
  count = var.postgres_instance.backup_plan != null ? 1 : 0

  db_instance_id               = tencentcloud_postgresql_instance.master.id
  backup_period                = var.postgres_instance.backup_plan.backup_period
  backup_method                = var.postgres_instance.backup_plan.backup_method
  min_backup_start_time        = var.postgres_instance.backup_plan.min_backup_start_time
  max_backup_start_time        = var.postgres_instance.backup_plan.max_backup_start_time
  base_backup_retention_period = var.postgres_instance.backup_plan.base_backup_retention_period
  log_backup_retention_period  = var.postgres_instance.backup_plan.log_backup_retention_period
}