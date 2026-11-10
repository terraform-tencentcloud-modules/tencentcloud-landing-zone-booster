# Get all vpcs info
data "tencentcloud_vpc_instances" "this" {}

locals {
  vpc_name_map = { for vpc in data.tencentcloud_vpc_instances.this.instance_list : vpc.name => vpc }
  vpc_id_map = { for vpc in data.tencentcloud_vpc_instances.this.instance_list : vpc.vpc_id => vpc }
  vpc_info = var.vpc_id != null ? try(local.vpc_id_map[var.vpc_id], null) : var.vpc_name != null ? try(local.vpc_name_map[var.vpc_name], null) : null
}

resource "tencentcloud_bh_resource" "instance" {
  # vpc config
  vpc_id           = var.vpc_id != null ? var.vpc_id : (local.vpc_info != null ? local.vpc_info.vpc_id : "")
  subnet_id        = var.subnet_id != null ? var.subnet_id : (local.vpc_info != null ? local.vpc_info.subnet_ids[0] : "")
  vpc_cidr_block   = var.vpc_cidr_block != null ? var.vpc_cidr_block : (local.vpc_info != null ? local.vpc_info.cidr_block : "")
  # bastion config
  deploy_region    = var.deploy_region
  deploy_zone      = var.deploy_zone
  cidr_block       = var.cidr_block
  resource_edition = var.resource_edition
  resource_node    = var.resource_node
  time_unit        = var.time_unit
  time_span        = var.time_span
  pay_mode         = var.pay_mode
  auto_renew_flag  = var.auto_renew_flag
  intranet_access  = var.intranet_access
  external_access  = var.external_access
}