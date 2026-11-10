resource "tencentcloud_kubernetes_encryption_protection" "this" {
  cluster_id = var.cluster_id

  # kms_configuration is Required (max 1). Always pass one block; omit key_id /
  # kms_region to let the cloud generate the default TKE-KMS key.
  kms_configuration {
    key_id     = var.kms_key_id
    kms_region = var.kms_region
  }
}
