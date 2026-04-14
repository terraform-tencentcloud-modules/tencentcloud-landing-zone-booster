locals {
  create_instance        = true
  create_placement_group = var.placement_group_name != "" && var.placement_group_id == ""
}

resource "tencentcloud_instance" "instance" {
  count = local.create_instance ? 1 : 0

  instance_name     = var.instance_name
  availability_zone = var.availability_zone
  image_id          = var.image_id
  instance_type     = var.instance_type

  system_disk_type = var.system_disk_type
  system_disk_size = var.system_disk_size

  project_id                 = var.project_id
  allocate_public_ip         = var.allocate_public_ip
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  vpc_id                     = var.vpc_id
  subnet_id                  = var.subnet_id
  private_ip                 = var.private_ip

  key_ids                 = var.key_ids
  password                = var.password
  orderly_security_groups = var.security_group_ids
  disable_monitor_service = !var.monitoring
  user_data_raw           = var.user_data_raw
  user_data               = var.user_data_base64
  cam_role_name           = var.cam_role_name

  instance_charge_type = var.instance_charge_type
  cdh_instance_type    = var.cdh_instance_type
  cdh_host_id          = var.cdh_host_id

  placement_group_id = local.create_placement_group ? tencentcloud_placement_group.this[0].id : var.placement_group_id

  tags = var.tags
}


resource "tencentcloud_cbs_storage_attachment" "exist_cbs" {
  count       = local.create_instance ? length(var.cbs_block_device_ids) : 0
  instance_id = tencentcloud_instance.instance[0].id
  storage_id  = var.cbs_block_device_ids[count.index]
}

resource "tencentcloud_cbs_storage" "cbs" {
  count             = local.create_instance ? length(var.cbs_block_devices) : 0
  availability_zone = var.availability_zone
  storage_name      = lookup(var.cbs_block_devices[count.index], "storage_name", "cvm_cbs_${count.index}")
  storage_size      = lookup(var.cbs_block_devices[count.index], "storage_size", 10)
  storage_type      = lookup(var.cbs_block_devices[count.index], "storage_type", "CLOUD_PREMIUM")
  force_delete      = lookup(var.cbs_block_devices[count.index], "force_delete", false)
  #  # encrypt not ready now
  #  encrypt      = lookup(var.cbs_block_device[count.index], "encrypt", false)

  tags = merge(
    var.tags,
    var.cbs_tags,
  )
}

resource "tencentcloud_cbs_storage_attachment" "new_cbs" {
  count       = local.create_instance ? length(var.cbs_block_devices) : 0
  instance_id = tencentcloud_instance.instance[0].id
  storage_id  = tencentcloud_cbs_storage.cbs[count.index].id
}

resource "tencentcloud_eni_attachment" "eni" {
  count       = local.create_instance ? length(var.eni_ids) : 0
  eni_id      = var.eni_ids[count.index]
  instance_id = tencentcloud_instance.instance[0].id
}

resource "tencentcloud_placement_group" "this" {
  count = local.create_placement_group ? 1 : 0
  name  = var.placement_group_name
  type  = var.placement_group_type
}