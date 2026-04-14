module "cls_alarm_notification_template" {
  source                          = "../"
  notice_content_name             = "通知模板测试"
  notice_content_trigger_content  = "{{.Labels}}"
  notice_content_recovery_content = "{{.Labels}}"
}
