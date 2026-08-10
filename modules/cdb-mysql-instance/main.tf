locals {
  instance_id = var.instance_id == "" ? tencentcloud_mysql_instance.this.0.id : var.instance_id
  root_password = var.root_password == null || var.root_password == "" ? random_password.root.result : var.root_password
  databases = { for db in var.databases: db.db_name => db }
  accounts = {for account in var.mysql_accounts: account.name => account }
  account_passwords = { for k, account in local.accounts: k => account.password == null ? random_password.accounts[k].result: account.password}
}

resource "random_password" "root" {
  length           = 32
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  min_lower        = 2
  override_special = "_+-&=!@#$%^*()"
}

resource "random_password" "accounts" {
  for_each = local.accounts

  length           = 32
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  min_lower        = 2
  override_special = "_+-&=!@#$%^*()"
}

resource "tencentcloud_mysql_instance" "this" {
  count = var.instance_id == "" ? 1 : 0

  # basic config
  instance_name     = var.instance_name
  cpu               = var.cpu_count
  mem_size          = var.mem_size
  volume_size       = var.volume_size
  tags              = var.tags
  availability_zone = var.availability_zone
  engine_version    = var.engine_version
  project_id        = var.project_id
  root_password     = local.root_password
  security_groups   = var.security_groups
  parameters        = var.parameters
  device_type       = var.device_type

  # payment configuration
  charge_type     = var.charge_type
  prepaid_period  = var.prepaid_period
  auto_renew_flag = var.auto_renew_flag
  force_delete    = var.force_delete

  # network configuration
  internet_service = var.internet_service
  intranet_port    = var.intranet_port
  subnet_id        = var.subnet_id
  vpc_id           = var.vpc_id

  # slave configuration
  first_slave_zone  = var.first_slave_zone
  second_slave_zone = var.second_slave_zone
  slave_deploy_mode = var.slave_deploy_mode
  slave_sync_mode   = var.slave_sync_mode

  lifecycle {
    ignore_changes = [
      root_password
    ]
  }
}

resource "tencentcloud_mysql_readonly_instance" "this" {
  count = length(var.readonly_instances)

  master_instance_id = local.instance_id
  master_region      = var.readonly_instances[count.index].master_region
  instance_name      = format("%s_readonly", var.readonly_instances[count.index].instance_name)
  cpu                = lookup(var.readonly_instances[count.index], "cpu_count", var.cpu_count)
  mem_size           = lookup(var.readonly_instances[count.index], "mem_size", var.mem_size)
  volume_size        = lookup(var.readonly_instances[count.index], "volume_size", var.volume_size)
  device_type        = lookup(var.readonly_instances[count.index], "device_type", var.device_type)
  charge_type        = lookup(var.readonly_instances[count.index], "charge_type", var.charge_type)
  intranet_port      = lookup(var.readonly_instances[count.index], "intranet_port", var.intranet_port)
  prepaid_period     = lookup(var.readonly_instances[count.index], "prepaid_period", var.prepaid_period)
  slave_deploy_mode  = lookup(var.readonly_instances[count.index], "slave_deploy_mode", var.slave_deploy_mode)
  security_groups    = lookup(var.readonly_instances[count.index], "security_groups", var.security_groups)
  zone               = lookup(var.readonly_instances[count.index], "zone", var.availability_zone)
  subnet_id          = lookup(var.readonly_instances[count.index], "subnet_id", var.subnet_id)
  vpc_id             = lookup(var.readonly_instances[count.index], "vpc_id", var.vpc_id)
  ro_group_id        = lookup(var.readonly_instances[count.index], "ro_group_id", null)
  auto_renew_flag    = lookup(var.readonly_instances[count.index], "auto_renew_flag", var.auto_renew_flag)
  force_delete       = lookup(var.readonly_instances[count.index], "force_delete", var.force_delete)
  tags               = lookup(var.readonly_instances[count.index], "tags", var.tags)
}

resource "tencentcloud_mysql_backup_policy" "this" {
  count = var.create_backup_policy ? 1 : 0

  mysql_id              = local.instance_id
  backup_model          = var.backup_model
  backup_time           = var.backup_time
  retention_period      = var.retention_period
  binlog_period         = var.binlog_period
  enable_binlog_standby = var.enable_binlog_standby
  binlog_standby_days   = var.binlog_standby_days
}

resource "tencentcloud_mysql_database" "databases" {
  for_each = local.databases

  instance_id        = local.instance_id
  db_name            = each.value.db_name
  character_set_name = each.value.character_set_name
}

resource "tencentcloud_mysql_account" "this" {
  for_each = local.accounts

  mysql_id             = local.instance_id
  name                 = each.value.name
  host                 = each.value.host
  password             = local.account_passwords[each.value.name]
  max_user_connections = each.value.max_user_connections
  description          = each.value.description
  lifecycle {
    ignore_changes = [
      password
    ]
  }
}

resource "tencentcloud_mysql_privilege" "this" {
  for_each = local.accounts

  mysql_id     = local.instance_id
  account_name = each.value.name
  account_host = each.value.host
  global       = each.value.global

  dynamic "database" {
    for_each = each.value.database
    content {
      database_name = database.value.database_name
      privileges    = database.value.privileges
    }
  }

  dynamic "table" {
    for_each = each.value.table
    content {
      database_name = table.value.database_name
      table_name    = table.value.table_name
      privileges    = table.value.privileges
    }
  }

  dynamic "column" {
    for_each = each.value.column
    content {
      database_name = column.value.database_name
      table_name    = column.value.table_name
      column_name   = column.value.column_name
      privileges    = column.value.privileges
    }
  }

  depends_on = [
    tencentcloud_mysql_account.this,
    tencentcloud_mysql_database.databases
  ]
}
