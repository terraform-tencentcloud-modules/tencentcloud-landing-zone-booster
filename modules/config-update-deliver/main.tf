resource "tencentcloud_config_update_config_deliver" "this" {
  status               = var.status ? 1 : 0
  deliver_name         = var.deliver_name
  target_arn           = var.target_arn
  deliver_prefix       = var.deliver_prefix
  deliver_type         = var.deliver_type
  deliver_content_type = var.deliver_content_type
}
