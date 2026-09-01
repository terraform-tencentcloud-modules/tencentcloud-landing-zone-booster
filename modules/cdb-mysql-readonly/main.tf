################################################################################
### MySQL database readonly resources
################################################################################
locals {
  # Sort instance keys to ensure consistent ordering
  sorted_keys = sort(keys(var.ro_instances))
  # Check if ro_group_id is provided in ro_basic
  use_existing_group = var.ro_basic.ro_group_id != null && var.ro_basic.ro_group_id != ""
  # First instance key (creates new RO group if no ro_group_id provided)
  first_key = length(local.sorted_keys) > 0 ? local.sorted_keys[0] : null
  # Remaining instance keys (join existing RO group)
  remaining_keys = length(local.sorted_keys) > 1 ? slice(local.sorted_keys, 1, length(local.sorted_keys)) : []
}

# Create first MySQL readonly instance (creates new RO group if no ro_group_id provided)
resource "tencentcloud_mysql_readonly_instance" "ro_first" {
  count = local.first_key != null ? 1 : 0

  instance_name      = var.ro_instances[local.first_key].instance_name
  master_instance_id = var.ro_basic.master_instance_id
  master_region      = var.ro_basic.master_region
  zone               = var.ro_basic.zone
  ro_group_id        = var.ro_basic.ro_group_id
  vpc_id             = var.ro_basic.vpc_id
  subnet_id          = var.ro_basic.subnet_id
  security_groups    = var.ro_basic.security_groups
  intranet_port      = var.ro_basic.intranet_port
  slave_deploy_mode  = var.ro_instances[local.first_key].slave_deploy_mode
  mem_size           = var.ro_instances[local.first_key].mem_size
  volume_size        = var.ro_instances[local.first_key].volume_size
  cpu                = var.ro_instances[local.first_key].cpu
  device_type        = var.ro_instances[local.first_key].device_type
  charge_type        = var.ro_instances[local.first_key].charge_type
  prepaid_period     = var.ro_instances[local.first_key].prepaid_period
  auto_renew_flag    = var.ro_instances[local.first_key].auto_renew_flag
  force_delete       = var.ro_instances[local.first_key].force_delete

  tags = var.tags
}

# Create remaining MySQL readonly instances (join existing RO group)
resource "tencentcloud_mysql_readonly_instance" "ro_remaining" {
  for_each = toset(local.remaining_keys)

  instance_name      = var.ro_instances[each.value].instance_name
  master_instance_id = var.ro_basic.master_instance_id
  master_region      = var.ro_basic.master_region
  zone               = var.ro_basic.zone
  vpc_id             = var.ro_basic.vpc_id
  subnet_id          = var.ro_basic.subnet_id
  security_groups    = var.ro_basic.security_groups
  intranet_port      = var.ro_basic.intranet_port
  # Use ro_group_id from ro_basic if provided, otherwise use first instance's ro_group_id
  ro_group_id       = local.use_existing_group ? var.ro_basic.ro_group_id : tencentcloud_mysql_readonly_instance.ro_first[0].ro_group_id
  slave_deploy_mode = var.ro_instances[each.value].slave_deploy_mode
  mem_size          = var.ro_instances[each.value].mem_size
  volume_size       = var.ro_instances[each.value].volume_size
  cpu               = var.ro_instances[each.value].cpu
  device_type       = var.ro_instances[each.value].device_type
  charge_type       = var.ro_instances[each.value].charge_type
  prepaid_period    = var.ro_instances[each.value].prepaid_period
  auto_renew_flag   = var.ro_instances[each.value].auto_renew_flag
  force_delete      = var.ro_instances[each.value].force_delete

  tags = var.tags

  depends_on = [tencentcloud_mysql_readonly_instance.ro_first]
}
