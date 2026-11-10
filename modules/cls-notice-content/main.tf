# cls - monitoring alarm - notication template
resource "tencentcloud_cls_notice_content" "alarm_notice_content" {
  name = var.notice_content_name
  type = 1

  notice_contents {
    type = var.notice_content_channel
    trigger_content {
      title   = var.notice_content_trigger_title
      content = var.notice_content_trigger_content
      headers = var.notice_content_trigger_headers
    }
    recovery_content {
      title   = var.notice_content_recovery_title
      content = var.notice_content_recovery_content
      headers = var.notice_content_recovery_headers
    }
  }
}
