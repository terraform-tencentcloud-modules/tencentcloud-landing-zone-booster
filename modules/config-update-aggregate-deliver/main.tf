resource "tencentcloud_config_update_aggregate_config_deliver" "this" {
  status               = var.status ? 1 : 0
  account_group_id     = var.account_group_id
  deliver_name         = var.deliver_name
  target_arn           = var.target_arn
  deliver_prefix       = var.deliver_prefix
  deliver_type         = var.deliver_type
  deliver_uin          = var.deliver_uin
  deliver_content_type = var.deliver_content_type
}