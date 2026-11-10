locals {
  log_set_id = var.log_set_id == "" && var.create_clb_log ? tencentcloud_clb_log_set.set[0].id : var.log_set_id
  log_topic_id = var.log_topic_id == "" && var.create_clb_log ? tencentcloud_clb_log_topic.topic[0].id : var.log_topic_id
}

resource "tencentcloud_clb_log_set" "set" {
  count = var.log_set_id == "" && var.create_clb_log ? 1 : 0

  period = var.clb_log_set_period
}

resource "tencentcloud_clb_log_topic" "topic" {
  count = var.log_topic_id == "" && var.create_clb_log ? 1 : 0

  log_set_id = local.log_set_id
  topic_name = var.clb_log_topic_name
}

resource "tencentcloud_clb_instance_sla_config" "sla_config" {
  count = var.sla_type == null || var.sla_type == "" ? 0 : 1

  sla_type         = var.sla_type
  load_balancer_id = tencentcloud_clb_instance.instance.id
}

resource "tencentcloud_clb_instance" "instance" {
  # base config
  project_id     = var.project_id
  clb_name       = var.clb_name
  network_type   = var.network_type
  vpc_id         = var.vpc_id
  subnet_id      = var.network_type == "INTERNAL" ? var.subnet_id : null
  zone_id        = var.network_type == "OPEN" ? var.availability_zone : null
  master_zone_id = var.network_type == "OPEN" ? var.master_availability_zone : null
  slave_zone_id  = var.network_type == "OPEN" ? var.slave_availability_zone : null
  delete_protect = var.delete_protect
  tags           = var.tags
  # vip
  dynamic_vip = var.network_type == "OPEN" ? var.dynamic_vip : false
  vip         = var.network_type == "OPEN" && try(var.dynamic_vip, false) ? null : var.vip
  # internet
  internet_charge_type       = var.network_type == "OPEN" ? var.internet_charge_type : null
  internet_bandwidth_max_out = var.network_type == "OPEN" ? var.internet_bandwidth_max_out : null
  bandwidth_package_id       = var.internet_charge_type == "BANDWIDTH_PACKAGE" ? var.bandwidth_package_id : null
  address_ip_version         = var.address_ip_version
  # log
  log_set_id   = local.log_set_id
  log_topic_id = local.log_topic_id

  # sla
  sla_type        = var.sla_type

  # security groups
  security_groups = var.security_groups

  # snat
  snat_pro = var.snat_pro
  dynamic "snat_ips" {
    for_each = var.snat_ips
    content {
      subnet_id = snat_ips.value.subnet_id
      ip        = snat_ips.value.ip
    }
  }
  
  # target config
  load_balancer_pass_to_target = var.enable_pass_to_target
  target_region_info_region    = var.target_region_info_region
  target_region_info_vpc_id    = var.target_region_info_vpc_id

  lifecycle {
    ignore_changes = [
      tags["tke-clusterId"], # tke-clusterId is a preserved tag used by TKE for service attaching CLBs  
      tags["ccs-clusterId"], # ccs-clusterId is a preserved tag used by CCS for service attaching CLBs
      tags["owner"],         # owner is a preserved tag used by Others system for service attaching CLBs
      tags["last-modified"], # last modified tag
    ]
  }
}