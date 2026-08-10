# Get all vpcs info
data "tencentcloud_vpc_instances" "this" {}

locals {
  vpc_name_map = { for vpc in data.tencentcloud_vpc_instances.this.instance_list : vpc.name => vpc.vpc_id }

  acl_ids = { for acl in var.network_acls : acl.acl_name => tencentcloud_vpc_acl.acls[acl.acl_name].id }

  acl_attachments =  flatten([
    for acl in var.network_acls : [
      for subnet_id in acl.subnet_ids : {
        acl_id    = local.acl_ids[acl.acl_name]
        subnet_id = subnet_id
      }
  ]])
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

resource "tencentcloud_vpc_acl_attachment" "attachments"{
  count = length(local.acl_attachments)

  acl_id    = local.acl_attachments[count.index].acl_id
  subnet_id = local.acl_attachments[count.index].subnet_id

  depends_on = [ tencentcloud_vpc_acl.acls ]
}