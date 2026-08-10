data "tencentcloud_instance_types" "this" {
  exclude_sold_out  = var.exclude_sold_out
  cpu_core_count    = var.cpu_core_count
  memory_size       = var.memory_size
  availability_zone = var.availability_zone
}

data "tencentcloud_images" "this" {
  instance_type = local.instance_type
  os_name       = var.image_os_name
}

resource "random_password" "pwd" {
  length           = 12
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  min_lower        = 1
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  # instance type
  instance_type = var.instance_type != null ? var.instance_type : data.tencentcloud_instance_types.this.instance_types[0].instance_type
  image_id      = var.image_id != null ? var.image_id : data.tencentcloud_images.this.images[0].image_id
  # password
  password = var.password != null && var.password != "" ? var.password : random_password.pwd.result
  # placement group
  create_placement_group = var.placement_group_name != null && var.placement_group_name != ""
  placement_group_id     = var.placement_group_id != null && var.placement_group_id != "" ? var.placement_group_id : local.create_placement_group ? tencentcloud_placement_group.this[0].id : null
}

resource "tencentcloud_instance" "instance" {
  # basic config
  project_id        = var.project_id
  instance_name     = var.instance_name
  hostname          = var.host_name
  availability_zone = var.availability_zone
  instance_type     = local.instance_type
  image_id          = local.image_id

  # storage
  system_disk_id            = var.system_disk_type == "LOCAL_BASIC" || var.system_disk_type == "LOCAL_SSD" ? null : var.system_disk_id
  system_disk_name          = var.system_disk_name
  system_disk_type          = var.system_disk_type
  system_disk_size          = var.system_disk_size
  system_disk_resize_online = var.system_disk_resize_online

  dynamic "data_disks" {
    for_each = var.data_disks
    content {
      data_disk_type               = data_disks.value.data_disk_type
      data_disk_size               = data_disks.value.data_disk_size
      data_disk_name               = data_disks.value.data_disk_name
      data_disk_snapshot_id        = data_disks.value.data_disk_snapshot_id
      data_disk_id                 = data_disks.value.data_disk_id
      delete_with_instance         = data_disks.value.delete_with_instance
      delete_with_instance_prepaid = data_disks.value.delete_with_instance_prepaid
      kms_key_id                   = data_disks.value.kms_key_id
      encrypt                      = data_disks.value.encrypt
      throughput_performance       = data_disks.value.throughput_performance
    }
  }

  # vpc config
  vpc_id     = var.vpc_id
  subnet_id  = var.subnet_id
  private_ip = var.private_ip

  # security groups
  orderly_security_groups = var.security_group_ids

  # network config
  allocate_public_ip         = var.allocate_public_ip
  bandwidth_package_id       = var.bandwidth_package_id
  internet_charge_type       = var.allocate_public_ip ? var.internet_charge_type : null
  internet_max_bandwidth_out = var.allocate_public_ip ? var.internet_max_bandwidth_out : null
  ipv4_address_type          = var.ipv4_address_type
  ipv6_address_type          = var.ipv6_address_type
  anti_ddos_package_id       = var.anti_ddos_package_id

  # enhance services
  disable_security_service   = !var.enable_security_service
  disable_monitor_service    = !var.enable_monitor_service
  disable_automation_service = !var.enable_automation_service

  # login config
  password         = var.keep_image_login == null ? local.password : null
  key_ids          = var.key_ids
  keep_image_login = var.keep_image_login

  # role config
  cam_role_name = var.cam_role_name

  # hpc cluster config
  hpc_cluster_id = var.hpc_cluster_id

  # user init script
  user_data_raw               = var.user_data_raw
  user_data                   = var.user_data
  user_data_replace_on_change = var.user_data_replace_on_change

  # payment config
  instance_charge_type                    = var.instance_charge_type
  instance_charge_type_prepaid_period     = var.instance_charge_type == "PREPAID" ? var.instance_charge_type_prepaid_period : null
  instance_charge_type_prepaid_renew_flag = var.instance_charge_type == "PREPAID" ? var.instance_charge_type_prepaid_renew_flag : null

  spot_instance_type = var.instance_charge_type == "SPOTPAID" ? var.spot_instance_type : null
  spot_max_price     = var.instance_charge_type == "SPOTPAID" ? var.spot_max_price : null

  cdh_instance_type = var.instance_charge_type == "CDHPAID" ? var.cdh_instance_type : null
  cdh_host_id       = var.instance_charge_type == "CDHPAID" ? var.cdh_host_id : null

  # disaster recover group
  disaster_recover_group_ids = local.placement_group_id != null ? null : var.disaster_recover_group_ids

  # placement group
  placement_group_id               = local.placement_group_id
  force_replace_placement_group_id = local.placement_group_id != null ? var.force_replace_placement_group_id : null

  # stop config
  stop_type    = var.stop_type
  stopped_mode = var.stopped_mode

  # delete config
  force_delete            = var.instance_charge_type == "PREPAID" ? var.force_delete : null
  disable_api_termination = var.disable_api_termination

  tags = var.tags
}

resource "tencentcloud_cbs_storage" "cbs" {
  count = length(var.cbs_block_devices)

  availability_zone = var.availability_zone
  storage_name      = lookup(var.cbs_block_devices[count.index], "storage_name", "cvm_cbs_${count.index}")
  storage_size      = lookup(var.cbs_block_devices[count.index], "storage_size", 10)
  storage_type      = lookup(var.cbs_block_devices[count.index], "storage_type", "CLOUD_PREMIUM")
  force_delete      = lookup(var.cbs_block_devices[count.index], "force_delete", false)
  encrypt           = lookup(var.cbs_block_devices[count.index], "encrypt", false)
  tags              = var.cbs_tags
}

resource "tencentcloud_cbs_storage_attachment" "new_cbs" {
  count = length(var.cbs_block_devices)

  instance_id = tencentcloud_instance.instance.id
  storage_id  = tencentcloud_cbs_storage.cbs[count.index].id

  depends_on = [ tencentcloud_cbs_storage.cbs ]
}

resource "tencentcloud_cbs_storage_attachment" "exist_cbs" {
  count = length(var.cbs_block_device_ids)

  instance_id = tencentcloud_instance.instance.id
  storage_id  = var.cbs_block_device_ids[count.index]

  depends_on = [ tencentcloud_instance.instance ]
}

resource "tencentcloud_eni_attachment" "eni" {
  count = length(var.eni_ids)

  eni_id      = var.eni_ids[count.index]
  instance_id = tencentcloud_instance.instance.id

  depends_on = [ tencentcloud_instance.instance ]
}

resource "tencentcloud_placement_group" "this" {
  count = local.create_placement_group ? 1 : 0

  name = var.placement_group_name
  type = var.placement_group_type
}