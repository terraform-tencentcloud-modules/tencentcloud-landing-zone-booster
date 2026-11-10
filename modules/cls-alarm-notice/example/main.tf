module "cls-alarm-notice" {
  source            = "../"
  notice_name       = "告警模板测试"
  notice_type       = "Trigger"
  notice_content_id = "Default-zh"

  web_callback_name   = "webhook"
  web_callback_url    = "http://127.0.0.1:8080"
  web_callback_method = "POST"
  web_callback_type   = "Http"
  web_callback_id     = ""
}
