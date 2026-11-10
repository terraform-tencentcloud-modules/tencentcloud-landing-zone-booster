output "cluster_endpoint" {
  value       = try(tencentcloud_kubernetes_cluster_endpoint.endpoints[0].cluster_external_endpoint, "")
  description = "Cluster endpoint if cluster_public_access or endpoint enabled"
}

output "cluster_intranet_endpoint" {
  value       = try(tencentcloud_kubernetes_cluster_endpoint.endpoints[0].pgw_endpoint, "")
  description = "Cluster endpoint if cluster_private_access or endpoint enabled"
}