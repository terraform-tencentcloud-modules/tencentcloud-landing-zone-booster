# 定时黑名单配置示例
# 替换 instance_id 和 domain 为实际值后再应用

instance_id = "waf-instance-xxxx"
domain      = "example.com"
ip_list     = ["198.51.100.50", "198.51.100.51"]
action_type = 42  # 黑名单
description = "工作时间封禁异常访问 IP"
job_type    = "cron"

job_date_time = [
  {
    cron = [
      {
        days      = [1, 15, 30]  # 每月1号、15号、30号执行
        end_time  = "18:00:00"
        start_time = "09:00:00"
        w_days    = [1, 2, 3, 4, 5]  # 周一到周五
      }
    ]
    time_t_zone = "Asia/Shanghai"
  }
]