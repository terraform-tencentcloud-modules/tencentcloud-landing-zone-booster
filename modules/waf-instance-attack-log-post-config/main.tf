# NOTE:
# Only enterprise version and above are supported for activation
resource "tencentcloud_waf_instance_attack_log_post_config" "tc_waf_instance_attack_log_post_config" {
  attack_log_post = var.attack_log_post
  instance_id     = var.instance_id
}
