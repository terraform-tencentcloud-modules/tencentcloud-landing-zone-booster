resource "tencentcloud_waf_log_post_ckafka_flow" "tc_waf_log_post_ckafka_flow" {
  # 必需参数
  brokers       = var.brokers
  ckafka_id     = var.ckafka_id
  ckafka_region = var.ckafka_region
  compression   = var.compression
  kafka_version = var.kafka_version
  log_type      = var.log_type
  topic         = var.topic
  vip_type      = var.vip_type

  # 可选参数
  sasl_enable  = var.sasl_enable
  sasl_password = var.sasl_password
  sasl_user    = var.sasl_user

  # write_config 动态块
  dynamic "write_config" {
    for_each = var.write_config
    content {
      enable_body    = write_config.value.enable_body
      enable_bot     = write_config.value.enable_bot
      enable_headers = write_config.value.enable_headers
    }
  }
}