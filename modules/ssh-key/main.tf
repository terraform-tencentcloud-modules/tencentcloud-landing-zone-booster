################################################################################
### SSH key pair resource
################################################################################
resource "tencentcloud_key_pair" "ssh_key_pair" {

  key_name   = var.ssh_key.key_name
  project_id = var.ssh_key.project_id
  public_key = var.ssh_key.public_key

  tags = var.ssh_key.tags
}

################################################################################
### SSM secret resource
################################################################################

# Create secret storing the private key 
resource "tencentcloud_ssm_secret" "secret" {
  count = var.ssh_key != null && var.ssh_key.enable_store_in_ssm ? 1 : 0

  secret_name = "${replace(var.ssh_key.key_name, "_", "-")}-secret"
  description = "SSH key pair for ${var.ssh_key.key_name}"
  tags        = var.ssh_key.tags

  depends_on = [tencentcloud_key_pair.ssh_key_pair]
}

resource "tencentcloud_ssm_secret_version" "v1" {
  count = var.ssh_key != null && var.ssh_key.enable_store_in_ssm ? 1 : 0

  secret_name = tencentcloud_ssm_secret.secret[0].secret_name
  version_id  = "v1"
  secret_string = jsonencode({
    key_name    = var.ssh_key.key_name
    public_key  = tencentcloud_key_pair.ssh_key_pair.public_key
    private_key = tencentcloud_key_pair.ssh_key_pair.private_key
  })
}
