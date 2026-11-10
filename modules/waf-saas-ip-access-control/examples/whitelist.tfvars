# IP 白名单配置示例
# 替换 instance_id 和 domain 为实际值后再应用

instance_id = "waf-instance-xxxx"
domain      = "api.example.com"
ip_list     = ["203.0.113.10", "203.0.113.20"]
action_type = 40  # 白名单
description = "仅允许内部 API 调用 IP 访问"