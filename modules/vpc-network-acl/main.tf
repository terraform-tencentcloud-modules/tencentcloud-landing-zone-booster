data "tencentcloud_vpc_instances" "this" {
  name = var.vpc_name
}

locals {
  vpc_id = var.vpc_id != null ? var.vpc_id : var.vpc_name != null ? data.tencentcloud_vpc_instances.this.instance_list[0].vpc_id : null
}

resource "tencentcloud_vpc_acl" "acl" {
  vpc_id  = local.vpc_id
  name    = var.network_acl_name
  ingress = var.network_acl_ingress
  egress  = var.network_acl_egress
  tags    = var.network_acl_tags
}