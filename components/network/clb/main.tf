locals {
  create_log_set = var.clb_instance.create_clb_log && var.clb_instance.log_set_id == null
  create_log_topic = var.clb_instance.create_clb_log && var.clb_instance.log_topic_id == null

  log_set_id = local.create_log_set ? tencentcloud_clb_log_set.set[0].id : var.clb_instance.log_set_id
  log_topic_id = local.create_log_topic ? tencentcloud_clb_log_topic.topic[0].id : var.clb_instance.log_topic_id
}

resource "tencentcloud_clb_log_set" "set" {
  count = local.create_log_set ? 1 : 0

  period = var.clb_instance.clb_log_set_period
}

resource "tencentcloud_clb_log_topic" "topic" {
  count = local.create_log_topic ? 1 : 0

  log_set_id = local.log_set_id
  topic_name = var.clb_instance.clb_log_topic_name
}

resource "tencentcloud_clb_instance_sla_config" "sla_config" {
  count = var.clb_instance.sla_type == null ? 0 : 1

  sla_type         = var.clb_instance.sla_type
  load_balancer_id = tencentcloud_clb_instance.instance.id
}

################################################################################
### CLB Instance
################################################################################
resource "tencentcloud_clb_instance" "instance" {
  # base config
  project_id     = var.clb_instance.project_id
  clb_name       = var.clb_instance.clb_name
  network_type   = var.clb_instance.network_type
  vpc_id         = var.clb_instance.vpc_id
  subnet_id      = var.clb_instance.network_type == "INTERNAL" ? var.clb_instance.subnet_id : null
  zone_id        = var.clb_instance.network_type == "OPEN" ? var.clb_instance.availability_zone : null
  master_zone_id = var.clb_instance.network_type == "OPEN" ? var.clb_instance.master_availability_zone : null
  slave_zone_id  = var.clb_instance.network_type == "OPEN" ? var.clb_instance.slave_availability_zone : null
  delete_protect = var.clb_instance.delete_protect
  tags           = var.clb_instance.tags
  # vip
  dynamic_vip = var.clb_instance.network_type == "OPEN" ? var.clb_instance.dynamic_vip : false
  vip         = var.clb_instance.network_type == "OPEN" && try(var.clb_instance.dynamic_vip, false) ? null : var.clb_instance.vip
  # internet
  internet_charge_type       = var.clb_instance.network_type == "OPEN" ? var.clb_instance.internet_charge_type : null
  internet_bandwidth_max_out = var.clb_instance.network_type == "OPEN" ? var.clb_instance.internet_bandwidth_max_out : null
  bandwidth_package_id       = var.clb_instance.internet_charge_type == "BANDWIDTH_PACKAGE" ? var.clb_instance.bandwidth_package_id : null
  address_ip_version         = var.clb_instance.address_ip_version
  # log
  log_set_id   = local.log_set_id
  log_topic_id = local.log_topic_id

  # sla
  sla_type        = var.clb_instance.sla_type

  # security groups
  security_groups = var.clb_instance.security_groups

  # snat
  snat_pro = var.clb_instance.snat_pro
  dynamic "snat_ips" {
    for_each = var.clb_instance.snat_ips
    content {
      subnet_id = snat_ips.value.subnet_id
      ip        = snat_ips.value.ip
    }
  }
  
  # target config
  load_balancer_pass_to_target = var.clb_instance.enable_pass_to_target
  target_region_info_region    = var.clb_instance.target_region_info_region
  target_region_info_vpc_id    = var.clb_instance.target_region_info_vpc_id

  lifecycle {
    ignore_changes = [
      tags["owner"],         # owner is a preserved tag used by Others system for service attaching CLBs
      tags["tke-clusterId"], # tke-clusterId is a preserved tag used by TKE for service attaching CLBs  
      tags["ccs-clusterId"], # ccs-clusterId is a preserved tag used by CCS for service attaching CLBs
      tags["last-modified"], # last modified tag
    ]
  }
}

################################################################################
### CLB listeners - HTTP HTTPS TCP UDP is supported,TCP_SSL/QUIC is not supported
################################################################################
