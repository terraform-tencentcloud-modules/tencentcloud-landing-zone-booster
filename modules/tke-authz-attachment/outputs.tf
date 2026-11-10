output "tke_default_issuer" {
  value       = tencentcloud_kubernetes_auth_attachment.this.tke_default_issuer
  description = "The default issuer of TKE when `use_tke_default` is true."
}

output "tke_default_jwks_uri" {
  value       = tencentcloud_kubernetes_auth_attachment.this.tke_default_jwks_uri
  description = "The default jwks_uri of TKE when `use_tke_default` is true."
}