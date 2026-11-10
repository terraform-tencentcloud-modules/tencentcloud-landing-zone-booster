resource "tencentcloud_config_alarm_policy" "this" {
  for_each = var.alarm_policies

  name                   = each.value.name
  type                   = each.value.type
  event_scope            = each.value.event_scope
  risk_level             = each.value.risk_level
  notice_time            = each.value.notice_time
  notification_mechanism = each.value.notification_mechanism
  status                 = each.value.status
  notice_period          = each.value.notice_period
  description            = each.value.description
}
