################################################################################
### PostgreSQL database readonly resources
################################################################################

# Create PostgreSQL readonly group
resource "tencentcloud_postgresql_readonly_group" "ro_group" {

  name                        = var.ro_group.name
  master_db_instance_id       = var.ro_group.master_db_instance_id
  project_id                  = var.ro_group.project_id
  vpc_id                      = var.ro_group.vpc_id
  subnet_id                   = var.ro_group.subnet_id
  security_groups_ids         = var.ro_group.security_groups_ids
  replay_lag_eliminate        = var.ro_group.replay_lag_eliminate
  replay_latency_eliminate    = var.ro_group.replay_latency_eliminate
  max_replay_lag              = var.ro_group.max_replay_lag
  max_replay_latency          = var.ro_group.max_replay_latency
  min_delay_eliminate_reserve = var.ro_group.min_delay_eliminate_reserve
}

# Create PostgreSQL readonly instance(s)
resource "tencentcloud_postgresql_readonly_instance" "ro" {
  for_each = var.ro_instances

  read_only_group_id    = tencentcloud_postgresql_readonly_group.ro_group.id
  master_db_instance_id = var.ro_group.master_db_instance_id
  zone                  = each.value.zone
  name                  = each.value.name
  db_version            = each.value.db_version
  instance_charge_type  = each.value.charge_type
  memory                = each.value.memory
  cpu                   = each.value.cpu
  storage               = each.value.storage
  vpc_id                = var.ro_group.vpc_id
  subnet_id             = var.ro_group.subnet_id
  need_support_ipv6     = each.value.need_support_ipv6
  project_id            = var.ro_group.project_id
  security_groups_ids   = var.ro_group.security_groups_ids
  auto_renew_flag       = each.value.auto_renew_flag

  tags = var.tags
}
