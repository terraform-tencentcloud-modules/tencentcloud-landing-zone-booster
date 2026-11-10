locals {
  # Split authz_permissions into user and role groups based on target_type
  user_permissions = {
    for k, v in var.authz_permissions : k => v if v.target_uin == null && v.target_type == "user" && v.target_name != null
  }
  role_permissions = {
    for k, v in var.authz_permissions : k => v if v.target_uin == null && v.target_type == "role" && v.target_name != null
  }
}

################################################################################
### Query CAM users by name (target_type == "user")
################################################################################
data "tencentcloud_cam_users" "users" {
  for_each = local.user_permissions

  name = each.value.target_name
}

################################################################################
### Query CAM roles by name (target_type == "role")
################################################################################
data "tencentcloud_cam_role_detail" "roles" {
  for_each = local.role_permissions

  role_name = each.value.target_name
}

locals {
  # Resolve the target_uin for each permission entry:
  # - use target_uin directly if provided
  # - otherwise use the UIN/ID resolved from the queried user or role
  resolved_target_uin = {
    for k, v in var.authz_permissions : k => (
      v.target_uin != null && v.target_uin != ""
        ? v.target_uin
        : (v.target_type == "user"
          ? data.tencentcloud_cam_users.users[k].user_list[0].uin
          : data.tencentcloud_cam_role_detail.roles[k].role_info[0].role_id)
    )
  }
}

################################################################################
### TKE cluster user permissions module
################################################################################
resource "tencentcloud_kubernetes_user_permissions" "authz" {
  for_each = var.authz_permissions

  target_uin = local.resolved_target_uin[each.key]

  dynamic "permissions" {
    for_each = each.value.permissions
    content {
      cluster_id = coalesce(permissions.value.cluster_id, var.default_cluster_id)
      role_name  = permissions.value.role_name
      role_type  = permissions.value.role_type
      is_custom  = permissions.value.is_custom
      namespace  = permissions.value.namespace
    }
  }
}
