# alarm policy
resource "tencentcloud_cls_alarm" "cls_alarm_policy" {
  name             = var.cls_alarm_policy_name
  alarm_notice_ids = var.alarm_notice_ids
  // Additional notification content
  message_template = var.message_template
  status           = var.status
  // Alarm Frequency
  alarm_period  = var.alarm_period
  trigger_count = var.trigger_count

  alarm_targets {
    logset_id         = var.logset_id
    topic_id          = var.topic_id
    query             = var.query
    start_time_offset = var.start_time_offset
    end_time_offset   = var.end_time_offset
    number            = 1
    syntax_rule       = var.syntax_rule
  }
  
  analysis {
      content = var.analysis_content
      name    = var.analysis_name
      type    = var.analysis_type

      dynamic "config_info" {
        for_each = var.analysis_config_infos
        content {
          key   = config_info.value["key"]
          value = config_info.value["value"]
        }
      }
    }

  dynamic "multi_conditions" {
    for_each = var.multi_conditions
    content {
      condition   = multi_conditions.value["condition"]
      alarm_level = multi_conditions.value["alarm_level"]
    }
  }

  // Execution Cycle	
  monitor_time {
    time = var.monitor_time.time
    type = var.monitor_time.type
  }

  tags = var.policy_tag
}
