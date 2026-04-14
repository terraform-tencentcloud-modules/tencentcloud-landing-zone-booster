# Output WebCallback ID
output "cls_webcallback_id" {
  description = "The ID of the WebCallback"
  value       = var.web_callback_id == "" ? tencentcloud_cls_web_callback.web_callback[0].id : var.web_callback_id
}

# Output AlarmNotice ID
output "cls_alarmnotice_id" {
  description = "The ID of the AlarmNotice"
  value       = tencentcloud_cls_alarm_notice.alarm_notice.id
}
