# Example: enable specific write fields (body, bot, headers)
# This demonstrates the write_config dynamic block usage

brokers       = "broker1.example.com:9092"
ckafka_id     = "ckafka-xxxx"
ckafka_region = "ap-guangzhou"
compression   = "snappy"
kafka_version = "2.7.0"
log_type      = 1
topic         = "waf_post_access_log"
vip_type      = 2

write_config = [
  {
    enable_body    = 1
    enable_bot     = 1
    enable_headers = 0
  }
]
