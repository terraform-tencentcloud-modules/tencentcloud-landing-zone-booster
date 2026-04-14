locals {
  assignments = { for k, v in var.assignments: k => v if var.create }
}

resource "tencentcloud_identity_center_role_assignment" "role_assignment" {
  for_each = local.assignments
  zone_id               = var.zone_id
  principal_id          = each.value.principal_id
  principal_type        = each.value.principal_type
  target_uin            = each.value.target_uin
  target_type           = each.value.target_type
  role_configuration_id = each.value.role_configuration_id
  deprovision_strategy  = try(each.value.deprovision_strategy, "None")
}