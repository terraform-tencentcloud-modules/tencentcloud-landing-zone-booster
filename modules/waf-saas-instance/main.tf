// Tencent Cloud WAF SaaS Instance resource
resource "tencentcloud_waf_saas_instance" "tc_waf_saas_instance" {
  instance_name   = var.instance_name
  goods_category  = var.goods_category
  api_security    = var.api_security
  auto_renew_flag = var.auto_renew_flag
  bot_management  = var.bot_management
  elastic_mode    = var.elastic_mode
  # Optional capabilities and limits
  qps_limit   = var.qps_limit
  real_region = var.real_region
  time_span   = var.time_span
  time_unit   = var.time_unit
}
