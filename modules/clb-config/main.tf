resource "tencentcloud_clb_customized_config" "config" {
  config_content    = replace(trimsuffix(replace(var.clb_config_content, "\r\n", "\n"), "\n"), "\n", "\r\n")
  config_name       = var.clb_config_name
  load_balancer_ids = var.clb_ids
}