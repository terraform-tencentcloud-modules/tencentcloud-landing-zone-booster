################################################################################
### TKE cluster user permissions module
################################################################################
resource "tencentcloud_kubernetes_user_permissions" "authz" {
  count = var.authz_uin == null ? 0 : 1

  target_uin = var.authz_uin

  dynamic "permissions" {
    for_each = var.permissions
    content {
      cluster_id = coalesce(permissions.value.cluster_id, var.cluster_id)
      role_name  = permissions.value.role_name
      role_type  = permissions.value.role_type
      is_custom  = permissions.value.is_custom
      namespace  = permissions.value.namespace
    }
  }
}
