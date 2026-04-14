# Create SSM Secret
resource "tencentcloud_ssm_secret" "tc_ssm_secret" {
  secret_name = var.secret_name
  description = var.secret_description
  
  recovery_window_in_days = var.recovery_window_in_days
  is_enabled              = var.secret_enabled
  kms_key_id              = var.kms_key_id
  additional_config       = var.additional_config 
  secret_type             = var.secret_type

  tags = var.tags
}

# Create SSM Secret Version
resource "tencentcloud_ssm_secret_version" "tc_ssm_secret_version" {
  secret_name   = tencentcloud_ssm_secret.tc_ssm_secret.secret_name
  version_id    = var.secret_version_id
  
  # Only set one of secret_string or secret_binary
  secret_string = var.secret_string
  # secret_binary = var.secret_binary
}