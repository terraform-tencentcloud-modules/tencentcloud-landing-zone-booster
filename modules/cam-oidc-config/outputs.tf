output "provider_type" {
  value       = tencentcloud_cam_oidc_config.this.provider_type
  description = "IdP type. 11: Role IdP."
}

output "identity_url" {
  value       = tencentcloud_cam_oidc_config.this.identity_url
  description = "IdP URL."
}

output "identity_key" {
  value       = tencentcloud_cam_oidc_config.this.identity_key
  description = "Public key for signature."
}

output "client_id" {
  value       = tencentcloud_cam_oidc_config.this.client_id
  description = "Client ID."
}

output "status" {
  value       = tencentcloud_cam_oidc_config.this.status
  description = "Status. 0: Not set; 2: Disabled; 11: Enabled."
}

output "description" {
  value       = tencentcloud_cam_oidc_config.this.description
  description = "Description."
}
