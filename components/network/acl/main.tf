# Get all vpcs info
data "tencentcloud_vpc_instances" "this" {}

locals {
  vpc_name_map = { for vpc in data.tencentcloud_vpc_instances.this.instance_list : vpc.name => vpc.vpc_id }

  acl_ids = { for acl in var.network_acls : acl.acl_name => tencentcloud_vpc_acl.acls[acl.acl_name].id }
}

resource "tencentcloud_vpc_acl" "acls" {
  for_each = {
    for acl in var.network_acls : acl.acl_name => acl
  }

  vpc_id  = each.value.vpc_id != null ? each.value.vpc_id : local.vpc_name_map[each.value.vpc_name]
  name    = each.value.acl_name
  ingress = [
    for rule in each.value.ingress_rules : 
      "${rule.action}#${rule.cidr}#${rule.port}#${rule.protocol}#${rule.desc}"
  ]
  egress  = [
    for rule in each.value.egress_rules : 
      "${rule.action}#${rule.cidr}#${rule.port}#${rule.protocol}#${rule.desc}"
  ]
  tags = each.value.tags
}