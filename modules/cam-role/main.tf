locals {
  create_role     = var.cam_role != null
  create_policies = var.cam_policies != null && length(var.cam_policies) > 0

  # Convert list to map using policy name as key
  policy_map = local.create_policies ? { for policy in var.cam_policies : policy.name => policy } : {}

  # Merge bind_policy_names with created policy names
  all_policy_names = local.create_role ? concat(
    var.bind_policy_names,
    local.create_policies ? [for policy in var.cam_policies : policy.name] : []
  ) : []
}

resource "tencentcloud_cam_role" "role" {
  count = local.create_role ? 1 : 0

  name             = var.cam_role.name
  document         = var.cam_role.document
  description      = var.cam_role.description
  session_duration = var.cam_role.session_duration
  console_login    = var.cam_role.console_login
  tags             = var.cam_role.tags
}

resource "tencentcloud_cam_policy" "policy" {
  for_each = local.policy_map

  name        = each.value.name
  description = each.value.description
  document    = each.value.document
}

resource "tencentcloud_cam_role_policy_attachment_by_name" "attachment" {
  for_each = local.create_role ? { for policy in local.all_policy_names : "${var.cam_role.name}-${policy}" => policy } : {}

  depends_on = [tencentcloud_cam_policy.policy]

  role_name   = tencentcloud_cam_role.role.0.name
  policy_name = each.value
}
