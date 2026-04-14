# Output definitions for SSM secret module

output "ssm_secret_id" {
  description = "ID of the SSM secret"
  value       = module.database_password_secret.ssm_secret_id
}

output "ssm_secret_status" {
  description = "Status of the SSM secret"
  value       = module.database_password_secret.ssm_secret_status
}

output "ssm_secret_version_id" {
  description = "Version ID of the SSM secret"
  value       = module.database_password_secret.ssm_secret_version_id
}

output "secret_details" {
  description = "Complete details of the secret and its version"
  value       = module.database_password_secret.secret_details
  sensitive   = true
}