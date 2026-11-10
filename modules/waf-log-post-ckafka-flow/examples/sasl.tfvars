# Example: enable SASL authentication
# WARNING: sasl_password is sensitive. Use secure injection in CI/TF Cloud rather than committing secrets.

brokers       = "broker1.example.com:9092,broker2.example.com:9092"
ckafka_id     = "ckafka-xxxx"
ckafka_region = "ap-guangzhou"
compression   = "snappy"
kafka_version = "2.7.0"
log_type      = 1
topic         = "waf_post_access_log"
vip_type      = 2

sasl_enable   = 1
sasl_user     = "my_sasl_user"
sasl_password = "REPLACE_WITH_SECRET"
