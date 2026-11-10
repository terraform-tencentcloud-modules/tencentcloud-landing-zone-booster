resource "tencentcloud_waf_log_post_cls_flow" "tc_waf_log_post_cls_flow" {
  # 所有参数都是可选的，使用默认值
  cls_region    = var.cls_region
  log_topic_name = var.log_topic_name
  log_type      = var.log_type
  logset_name   = var.logset_name
}