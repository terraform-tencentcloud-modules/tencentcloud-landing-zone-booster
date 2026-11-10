terraform {
  required_version = ">= 1.5.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.81.125"
    }
  }
}

provider "tencentcloud" {
  region = "ap-shanghai"
}

module "event_alert" {
  source = "../../../../components/audit-log/event-alert"

  # notice config
  enable_notice = true
  notice_name   = "根账号活动监控"
  notice_type   = "Trigger"
  notice_receivers = [
    {
      receiver_type     = "Uin"
      receiver_ids      = [100000000012, 100000000013]
      receiver_channels = ["Email"]
    }
  ]
  notice_tags = {
    Environment = "DEV"
  }

  # alarm config
  alarms = [
    {
      name               = "根账号活动监控"
      trigger_count      = 1
      alarm_period       = 15
      monitor_time_type  = "Period"
      monitor_time_value = 15
      message_template = "【安全告警】检测到根账号活动！\n时间：{{.FireTime}}\n告警详情：{{.Label}}\n查询结果：{{.QueryResult}}\n请立即核查根账号操作行为，确认是否为授权操作！"
      # classifications = {
      #   category = "security"
      #   source   = "cloudaudit"
      #   rule     = "root-account-activity"
      # }
      status = true
      tags = {
        Environment = "DEV"
      }


      alarm_targets = [
        {
          logset_id         = "e74efb8e-f647-48b2-a725-43f11b122081"
          topic_id          = "59cf3ec0-1612-4157-be3f-341b2e7a53cb"
          # Retrieve the CloudAudit operation logs of the root account (the main account UIN)
          query             = "userIdentity.type:Root | select count(*) as rootActivityCount, userIdentity.accountId, eventName, sourceIPAddress, eventTime"
          number            = 1
          start_time_offset = -15
          end_time_offset   = 0
          syntax_rule       = 1
        }
      ]

      analysis_fields = [
        {
          content = "userIdentity.type"
          name    = "账号类型"
          type    = "field"

          config_info = [{
            key   = "QueryIndex"
            value = "1"
          }]
        },
        {
          content = "eventName"
          name    = "操作事件"
          type    = "field"

          config_info = [{
            key   = "QueryIndex"
            value = "1"
          }]
        },
        {
          content = "sourceIPAddress"
          name    = "来源IP"
          type    = "field"

          config_info = [{
            key   = "QueryIndex"
            value = "1"
          }]
        },
        {
          content = "userIdentity.accountId"
          name    = "根账号ID"
          type    = "field"

          config_info = [{
            key   = "QueryIndex"
            value = "1"
          }]
        }
      ]

      multi_conditions = [
        {
          condition   = "[$1.rootActivityCount] > 0"
          alarm_level = 1  # 0: Warning; 1: Info; 2: Critical
        }
      ]

      # alarm_notice_ids = [ "notice-123456" ]
    }
  ]
}