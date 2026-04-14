# SSM Secret Outputs
output "ssm_secret_id" {
  description = "ID of the SSM secret"
  value       = tencentcloud_ssm_secret.tc_ssm_secret.id
}

output "ssm_secret_status" {
  description = "Status of the SSM secret"
  value       = tencentcloud_ssm_secret.tc_ssm_secret.status
}

# SSM Secret Version Outputs
output "ssm_secret_version_id" {
  description = "Version ID of the SSM secret"
  value       = tencentcloud_ssm_secret_version.tc_ssm_secret_version.version_id
}


# Combined Output
output "secret_details" {
  description = "Complete details of the secret and its version"
  value = {
    secret_name = tencentcloud_ssm_secret.tc_ssm_secret.secret_name
    secret_id   = tencentcloud_ssm_secret.tc_ssm_secret.id
    version_id  = tencentcloud_ssm_secret_version.tc_ssm_secret_version.version_id
    status      = tencentcloud_ssm_secret.tc_ssm_secret.status
    is_enabled  = tencentcloud_ssm_secret.tc_ssm_secret.is_enabled
  }
  sensitive = true
}
