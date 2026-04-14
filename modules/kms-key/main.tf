# Create KMS Key
resource "tencentcloud_kms_key" "tc_kms_key" {
  count       = var.create_key ? 1 : 0
  alias       = var.key_name
  description = var.description
  is_enabled  = var.is_enabled
  tags        = var.tags
}
