################################################################################
### TKE cluster user permissions outputs
################################################################################
output "id" {
  description = "ID of the resource"
  value       = try(tencentcloud_kubernetes_user_permissions.authz[0].id, null)
}
