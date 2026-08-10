
# TKEs
output "cluster_id" {
  value       = local.cluster_id
  description = "TKE cluster id."
}

output "cluster_domain" {
  value       = tencentcloud_kubernetes_cluster.cluster[0].domain
  description = "Cluster domain."
}

output "kube_config_raw" {
  value       = local.kube_config_raw
  sensitive   = true
  description = "TKE cluster's kube config in raw."
}

output "intranet_kube_config" {
  value       = tencentcloud_kubernetes_cluster.cluster[0].kube_config_intranet
  sensitive   = true
  description = "Cluster's kube config of private access."
}

output "cluster_ca_certificate" {
  value       = tencentcloud_kubernetes_cluster.cluster[0].certification_authority
  description = "Cluster's certification authority."
}

output "client_key" {
  value       = try(local.kube_config.users[0].user["client-key-data"], "")
  description = "Base64 encoded cluster's client pem key."
}

output "client_certificate" {
  value       = try(local.kube_config.users[0].user["client-certificate-data"], "")
  description = "Base64 encoded cluster's client pem certificate."
}

# pod identity
output "enable_pod_identity" {
  value = var.enable_pod_identity
}

output "oidc_config_id" {
  value = try(tencentcloud_kubernetes_auth_attachment.auth_attach[0].id, null)
}

output "oidc_client_ids" {
  value = try(tencentcloud_kubernetes_auth_attachment.auth_attach[0].auto_create_client_id, ["sts.cloud.tencent.com"])
}

output "oidc_config_tke_default_issuer" {
  value = try(tencentcloud_kubernetes_auth_attachment.auth_attach[0].tke_default_issuer, null)
}

output "oidc_config_tke_default_jwks_uri" {
  value = try(tencentcloud_kubernetes_auth_attachment.auth_attach[0].tke_default_jwks_uri, null)
}