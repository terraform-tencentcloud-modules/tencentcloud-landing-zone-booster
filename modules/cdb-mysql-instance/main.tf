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

locals {

  random_root_password = var.root_password == null || var.root_password == "" ? true: false
  root_password  = local.random_root_password ? random_password.root.result : var.root_password
  accounts = {for k, account in var.accounts: k=> account if try(account.create, true)}
  account_passwords = { for k, account in local.accounts: k => try(account.password, null) == null? random_password.accounts[k].result: account.password}
  databases = { for k, database in var.databases: k => database if try(database.create, true)}
  privileges = { for k, account in var.accounts: k=> account if try(account.create_privileges, true)}

  readonly_instance_number = var.create_mysql_readonly_instance && var.instance_id != "" ? length(var.readonly_instances) : 0
  instance_id              = var.instance_id == "" ? tencentcloud_mysql_instance.this.0.id : var.instance_id
}

resource "tencentcloud_mysql_instance" "this" {
  count = var.create_mysql_instance && var.instance_id == "" ? 1 : 0

  instance_name     = var.instance_name
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

resource "tencentcloud_mysql_account" "this" {
  for_each = local.accounts

  mysql_id    = local.instance_id
  name        = each.value.name
  password    = local.account_passwords[each.key]
  description = try(each.value.description, "default description")
  host        = try(each.value.host, "%")
  lifecycle {
    ignore_changes = [
      password
    ]
  }
}

resource "tencentcloud_mysql_database" "databases" {
  for_each = local.databases
  instance_id        = local.instance_id
  db_name            = each.value.db_name
  character_set_name = try(each.value.character_set_name, "utf8")
}

resource "tencentcloud_mysql_privilege" "this" {
  depends_on = [tencentcloud_mysql_account.this, tencentcloud_mysql_database.databases]
  for_each = local.privileges

  account_name = each.value.name
  global       = try(each.value.privilege_global, [])
  mysql_id     = local.instance_id
  account_host = try(each.value.host, "%")

  dynamic "column" {
    for_each = try(each.value.privilege_columns, {})
    content {
      column_name   = column.value["column_name"]
      table_name    = column.value["table_name"]
      database_name = column.value["database_name"]
      privileges    = column.value["privileges"]
    }
  }

  dynamic "database" {
    for_each = try(each.value.privilege_databases, {})
    content {
      database_name = database.value["database_name"]
      privileges    = database.value["privileges"]
    }
  }

  dynamic "table" {
    for_each = try(each.value.privilege_table, {})
    content {
      database_name = table.value["database_name"]
      privileges    = table.value["privileges"]
      table_name    = table.value["table_name"]
    }
  }
}

resource "tencentcloud_mysql_backup_policy" "this" {
  count = var.create_backup_policy ? 1 : 0

  mysql_id         = local.instance_id
  backup_model     = var.backup_model
  backup_time      = var.backup_time
  retention_period = var.retention_period
}


resource "tencentcloud_mysql_readonly_instance" "this" {
  count = local.readonly_instance_number

  instance_name      = var.instance_id == "" ? format("%s-readonly%s", var.instance_name, count.index) : format("%s_readonly", var.readonly_instances[count.index].instance_name)
  master_instance_id = local.instance_id
  mem_size           = lookup(var.readonly_instances[count.index], "mem_size", var.mem_size)
  volume_size        = lookup(var.readonly_instances[count.index], "volume_size", var.volume_size)
  device_type        = lookup(var.readonly_instances[count.index], "device_type", var.device_type)
  auto_renew_flag    = lookup(var.readonly_instances[count.index], "auto_renew_flag", var.auto_renew_flag)
  charge_type        = lookup(var.readonly_instances[count.index], "charge_type", var.charge_type)
  force_delete       = lookup(var.readonly_instances[count.index], "force_delete", var.force_delete)
  intranet_port      = lookup(var.readonly_instances[count.index], "intranet_port", var.intranet_port)
  prepaid_period     = lookup(var.readonly_instances[count.index], "prepaid_period", var.prepaid_period)
  security_groups    = lookup(var.readonly_instances[count.index], "security_groups", var.security_groups)
  subnet_id          = lookup(var.readonly_instances[count.index], "subnet_id", var.subnet_id)
  vpc_id             = lookup(var.readonly_instances[count.index], "vpc_id", var.vpc_id)
  tags               = lookup(var.readonly_instances[count.index], "tags", var.tags)
  zone               = lookup(var.readonly_instances[count.index], "zone", var.readonly_instance_zone)
}
