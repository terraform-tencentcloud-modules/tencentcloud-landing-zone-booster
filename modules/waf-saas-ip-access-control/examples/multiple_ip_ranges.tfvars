# 多 IP 段控制配置示例
# 替换 instance_id 和 domain 为实际值后再应用

instance_id = "waf-instance-xxxx"
domain      = "example.com"
ip_list     = ["192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
action_type = 40  # 白名单
description = "允许内部网络访问"