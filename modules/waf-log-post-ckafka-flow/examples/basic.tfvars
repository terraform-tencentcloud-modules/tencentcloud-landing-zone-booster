# Basic example: deliver access logs to CKafka
# Replace placeholders with real values before apply

brokers       = "broker1.example.com:9092,broker2.example.com:9092"
ckafka_id     = "ckafka-xxxx"
ckafka_region = "ap-guangzhou"
compression   = "snappy"
kafka_version = "2.7.0"
log_type      = 1
topic         = "waf_post_access_log"
vip_type      = 2

# no SASL, default write_config
