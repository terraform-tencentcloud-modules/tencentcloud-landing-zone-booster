locals {
  share_unit_id = concat(tencentcloud_organization_org_share_unit.org_share_unit.*.unit_id, [""])[0]
}

resource "tencentcloud_organization_org_share_unit" "org_share_unit" {
  count = var.create ? 1 : 0
  name        = var.name
  area        = var.area
  description = var.description
}

resource "tencentcloud_organization_org_share_unit_member" "org_share_unit_member" {
  count = var.create && length(var.unit_member_uins) > 0 ? 1 : 0
  unit_id = local.share_unit_id
  area    = var.area
  dynamic "members" {
    for_each = var.unit_member_uins
    content {
      share_member_uin = members.value
    }
  }
}

resource "tencentcloud_organization_org_share_unit_resource" "organization_org_share_unit_resource" {
  for_each = { for k, v in var.unit_resources: k => v if  var.create}
  unit_id             = local.share_unit_id
  area                = var.area
  type                = each.value.type
  product_resource_id = each.value.product_resource_id
}