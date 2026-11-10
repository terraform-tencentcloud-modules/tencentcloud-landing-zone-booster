################################################################################
### TKE cluster user permissions outputs
################################################################################
output "user_permission_ids" {
  description = "IDs of the resources"
  value       = [for k, v in tencentcloud_kubernetes_user_permissions.authz : v.id]
}
