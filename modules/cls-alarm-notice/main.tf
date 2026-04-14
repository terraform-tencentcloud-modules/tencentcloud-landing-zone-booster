// cls - monitoring alarm - integration configration
resource "tencentcloud_cls_web_callback" "web_callback" {
  count   = var.web_callback_id == "" ? 1 : 0
  name    = var.web_callback_name
  type    = var.web_callback_type
  webhook = var.web_callback_url
  method  = var.web_callback_method
}

# cls - monitoring alarm - notification group
resource "tencentcloud_cls_alarm_notice" "alarm_notice" {
  name = var.notice_name
  type = var.notice_type

  web_callbacks {
    callback_type     = "Http"
    url               = ""
    notice_content_id = var.notice_content_id
    web_callback_id   = var.web_callback_id == "" ? tencentcloud_cls_web_callback.web_callback[0].id : var.web_callback_id
  }

  tags = var.notice_tag
}
