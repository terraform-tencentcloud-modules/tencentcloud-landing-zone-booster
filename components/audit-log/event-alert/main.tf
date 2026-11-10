# retrieve all logset info
data "tencentcloud_cls_logsets" "this" {}
# retrieve all topic info
data "tencentcloud_cls_topics" "this" {}

locals {
  # Get all logset ids
  logsets_map = {
    for logset in data.tencentcloud_cls_logsets.this.logsets : logset.logset_name => logset.logset_id
  }

  # Get all topic ids
  topics_map = {
    for topic in data.tencentcloud_cls_topics.this.topics : topic.topic_name => {
      logset_id = topic.logset_id
      topic_id  = topic.topic_id
    }
  }

  alarm_notice_id = var.enable_notice ? tencentcloud_cls_alarm_notice.notice[0].id : null

  alarm_ids = {
    for alarm in var.alarms : alarm.name => tencentcloud_cls_alarm.alarms[alarm.name].id
  }
}

resource "tencentcloud_cls_alarm_notice" "notice" {
  count = var.enable_notice ? 1 : 0

  name = var.notice_name
  type = var.notice_type

  dynamic "notice_receivers" {
    for_each = var.notice_receivers
    content {
      receiver_type     = notice_receivers.value.receiver_type
      receiver_ids      = notice_receivers.value.receiver_ids
      receiver_channels = notice_receivers.value.receiver_channels
      notice_content_id = notice_receivers.value.notice_content_id
      start_time        = notice_receivers.value.start_time
      end_time          = notice_receivers.value.end_time
    }
  }

  dynamic "web_callbacks" {
    for_each = var.notice_web_callbacks
    content {
      callback_type     = web_callbacks.value.callback_type
      url               = web_callbacks.value.url
      method            = web_callbacks.value.method
      web_callback_id   = web_callbacks.value.web_callback_id
      notice_content_id = web_callbacks.value.notice_content_id
      remind_type       = web_callbacks.value.remind_type
      mobiles           = web_callbacks.value.mobiles
      user_ids          = web_callbacks.value.user_ids
    }
  }

  tags = var.notice_tags
}

resource "tencentcloud_cls_alarm" "alarms" {
  for_each = {
    for alarm in var.alarms : alarm.name => alarm
  }

  name             = each.value.name
  trigger_count    = each.value.trigger_count
  alarm_period     = each.value.alarm_period
  message_template = each.value.message_template
  classifications  = each.value.classifications
  tags             = each.value.tags
  status           = each.value.status

  dynamic "alarm_targets" {
    for_each = each.value.alarm_targets
    content {
      logset_id         = alarm_targets.value.logset_id != null ? alarm_targets.value.logset_id : try(local.logsets_map[alarm_targets.value.logset_name].logset_id, null)
      topic_id          = alarm_targets.value.topic_id != null ? alarm_targets.value.topic_id : try(local.topics_map[alarm_targets.value.topic_name].topic_id, null)
      query             = alarm_targets.value.query
      number            = alarm_targets.value.number
      start_time_offset = alarm_targets.value.start_time_offset
      end_time_offset   = alarm_targets.value.end_time_offset
      syntax_rule       = alarm_targets.value.syntax_rule
    }
  }

  monitor_time {
    type = each.value.monitor_time_type
    time = each.value.monitor_time_value
  }

  dynamic "analysis" {
    for_each = each.value.analysis_fields
    content {
      name    = analysis.value.name
      type    = analysis.value.type
      content = analysis.value.content

      dynamic "config_info" {
        for_each = analysis.value.config_info
        content {
          key   = config_info.value.key
          value = config_info.value.value
        }
      }
    }
  }

  dynamic "multi_conditions" {
    for_each = each.value.multi_conditions
    content {
      condition   = multi_conditions.value.condition
      alarm_level = multi_conditions.value.alarm_level
    }
  }

  # Notice
  alarm_notice_ids = length(each.value.monitor_notice) > 0 ? null : length(each.value.alarm_notice_ids) > 0 ? each.value.alarm_notice_ids : [ local.alarm_notice_id ]

  dynamic "monitor_notice" {
    for_each = each.value.monitor_notice
    content {
      dynamic "notices" {
        for_each = monitor_notice.value.notices
        content {
          notice_id       = notices.value.notice_id
          content_tmpl_id = notices.value.notice_name
          alarm_levels    = notices.value.alarm_levels
        }
      }
    }
  }
}