resource "tencentcloud_waf_clb_instance" "tc_waf_clb_instance" {
  goods_category  = var.goods_category
  instance_name   = var.instance_name
  time_span       = var.time_span
  time_unit       = var.time_unit
  auto_renew_flag = var.auto_renew_flag
  elastic_mode    = var.elastic_mode
  qps_limit    = var.qps_limit
  api_security    = var.api_security
  bot_management  = var.bot_management
}
