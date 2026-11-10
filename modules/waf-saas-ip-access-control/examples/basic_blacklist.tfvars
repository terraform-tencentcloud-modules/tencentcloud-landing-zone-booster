# 基本 IP 黑名单配置示例
# 替换 instance_id 和 domain 为实际值后再应用

instance_id = "waf-instance-xxxx"
domain      = "example.com"
ip_list     = ["192.168.1.100", "10.0.0.0/24"]
action_type = 42  # 黑名单
description = "阻止恶意 IP 访问"