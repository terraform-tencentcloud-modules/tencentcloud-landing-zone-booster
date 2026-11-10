output "id" {
  description = "Resource id (the cluster id)."
  value       = tencentcloud_kubernetes_encryption_protection.this.id
}

output "cluster_id" {
  description = "Cluster id."
  value       = tencentcloud_kubernetes_encryption_protection.this.cluster_id
}

output "status" {
  description = "KMS encryption status."
  value       = tencentcloud_kubernetes_encryption_protection.this.status
}

output "kms_key_id" {
  description = "Custom KMS key ID (null means the cloud-generated default TKE-KMS key)."
  value       = tencentcloud_kubernetes_encryption_protection.this.kms_configuration[0].key_id
}

output "kms_region" {
  description = "Region of the KMS key."
  value       = tencentcloud_kubernetes_encryption_protection.this.kms_configuration[0].kms_region
}
