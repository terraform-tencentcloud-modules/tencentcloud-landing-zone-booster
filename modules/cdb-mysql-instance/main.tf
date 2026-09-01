locals {
  instance_id = var.instance_id == null ? tencentcloud_mysql_instance.this.0.id : var.instance_id
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
  count = var.instance_id == null ? 1 : 0

  # ---------------- Required ----------------
  instance_name = var.instance_name
  cpu           = var.cpu_cores
  mem_size      = var.mem_size
  volume_size   = var.volume_size

  # ---------------- Billing ----------------
  charge_type     = var.charge_type      # ForceNew
  prepaid_period  = var.prepaid_period
  auto_renew_flag = var.auto_renew_flag

  # ---------------- Engine ----------------
  engine_version     = var.engine_version
  engine_type        = var.engine_type
  parameters         = var.parameters
  upgrade_subversion = var.upgrade_subversion
  max_deay_time      = var.max_deay_time

  # ---------------- Network ----------------
  intranet_port    = var.intranet_port
  internet_service = var.internet_service
  vpc_id           = var.vpc_id
  subnet_id        = var.subnet_id
  security_groups  = var.security_groups

  # ---------------- Spec ----------------
  param_template_id = var.param_template_id
  fast_upgrade     = var.fast_upgrade
  device_type      = var.device_type
  disk_type        = var.disk_type # ForceNew

  # ---------------- HA / Zone ----------------
  availability_zone = var.availability_zone
  slave_deploy_mode = var.slave_deploy_mode
  first_slave_zone  = var.first_slave_zone
  second_slave_zone = var.second_slave_zone
  slave_sync_mode   = var.slave_sync_mode

  # ---------------- Credentials ----------------
  # sensitive: Read-only/disaster recovery instances must not be set
  root_password = local.root_password       

  # ---------------- Behavior ----------------
  tags            = var.tags
  force_delete    = var.force_delete
  wait_switch     = var.wait_switch
  destroy_protect = var.destroy_protect
  project_id      = var.project_id

  # ---------------- Cluster Edition topology ----------------
  dynamic "cluster_topology" {
    for_each = var.cluster_topology
    content {
      dynamic "read_write_node" {
        for_each = cluster_topology.value.read_write_node != null ? [cluster_topology.value.read_write_node] : []
        content {
          zone    = read_write_node.value.zone
          node_id = read_write_node.value.node_id
        }
      }
      dynamic "read_only_nodes" {
        for_each = cluster_topology.value.read_only_nodes != null ? cluster_topology.value.read_only_nodes : []
        content {
          is_random_zone = read_only_nodes.value.is_random_zone
          zone           = read_only_nodes.value.zone
          node_id        = read_only_nodes.value.node_id
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      root_password
    ]
  }
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
