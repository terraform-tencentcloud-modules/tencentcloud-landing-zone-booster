resource "tencentcloud_bh_resource" "instance" {
  deploy_region    = var.deploy_region
  vpc_id           = var.vpc_id
  subnet_id        = var.subnet_id
  resource_edition = var.resource_edition
  resource_node    = var.resource_node
  time_unit        = var.time_unit
  time_span        = var.time_span
  pay_mode         = var.pay_mode
  auto_renew_flag  = var.auto_renew_flag
  deploy_zone      = var.deploy_zone
  cidr_block       = var.cidr_block
  vpc_cidr_block   = var.vpc_cidr_block
  intranet_access  = var.intranet_access
  external_access  = var.external_access
}