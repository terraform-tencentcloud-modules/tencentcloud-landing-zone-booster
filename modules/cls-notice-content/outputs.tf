// Output cls alarm notification template id
output "cls_alarm_notification_template_id" {
  description = "The ID of cls alarm notification template"
  value       = tencentcloud_cls_notice_content.alarm_notice_content.id
}
