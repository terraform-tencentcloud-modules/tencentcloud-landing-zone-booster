data "tencentcloud_organization_services" "all" {}

locals {
  org_service_list = {
    for s in data.tencentcloud_organization_services.all.items : lower(s.product_name) => s
  }

  assign_list = [ for item in var.service_assign_list: {
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
  management_scope = try(var.management_scope, 1)
  member_uins      = [local.filtered_assign_list[count.index].member_uin]
}