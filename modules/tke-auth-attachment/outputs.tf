################################################################################
### TKE cluster authentication options attachment outputs
################################################################################
output "tke_default_issuer" {
  value       = tencentcloud_kubernetes_auth_attachment.this.tke_default_issuer
  description = "The default issuer of TKE when `use_tke_default` is true."
}

output "tke_default_jwks_uri" {
  value       = tencentcloud_kubernetes_auth_attachment.this.tke_default_jwks_uri
  description = "The default jwks_uri of TKE when `use_tke_default` is true."
}

################################################################################
### CAM OIDC config data outputs
################################################################################
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