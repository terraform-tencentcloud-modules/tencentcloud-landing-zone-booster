output "tcr_instance_id" {
  description = "ID of the TCR instance."
  value       = tencentcloud_tcr_instance.registry.id
}

output "tcr_namespace_ids" {
  description = "IDs of the namespace."
  value       = [for k, v in tencentcloud_tcr_namespace.namespace : v.id]
}

output "tcr_repository_ids" {
  description = "IDs of the repository"
  value       = [for k, v in tencentcloud_tcr_repository.repository : v.id]
}

output "tcr_service_account_password" {
  description = "Password of the service account."
  value       = [for k, v in tencentcloud_tcr_service_account.service_acount : v.password]
  sensitive   = true
}
