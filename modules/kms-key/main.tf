# Create KMS Key
resource "tencentcloud_kms_key" "tc_kms_key" {
  count = var.create_key ? 1 : 0

  alias                = var.key_name
  description          = var.description
  is_enabled           = var.is_enabled
  key_usage            = var.key_usage
  key_rotation_enabled = var.key_rotation_enabled
  hsm_cluster_id       = var.hsm_cluster_id
  tags                 = var.tags
}
