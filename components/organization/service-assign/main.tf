# Get members information
data "tencentcloud_organization_members" "members" {}
# Get services information
data "tencentcloud_organization_services" "all" {}

locals {
  org_members = {
    for m in data.tencentcloud_organization_members.members.items : m.name => m.member_uin
  }

  org_service_assigns = [
    for item in var.service_assign_list : {
      member_uin   = item.member_uin != null ? item.member_uin : local.org_members[item.member_name],
      service_name = item.service_name
    }
  ]

  org_service_list = {
    for s in data.tencentcloud_organization_services.all.items : lower(s.product_name) => s
  }

  assign_list = [ for item in local.org_service_assigns: {
    service    = local.org_service_list[lower(item.service_name)]
    member_uin = item.member_uin
  }]

  filtered_assign_list = [ for item in local.assign_list: {
    service    = item.service
    member_uin = item.member_uin
  } if try(tonumber(item.service.member_num) < item.service.can_assign_count, false) ]
}

resource "tencentcloud_organization_service_assign" "assign" {
  count = length(local.filtered_assign_list)

  service_id       = local.filtered_assign_list[count.index].service.service_id
  member_uins      = [local.filtered_assign_list[count.index].member_uin]
  management_scope = var.management_scope
}