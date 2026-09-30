# TencentCloud CLS Alarm Notification Content Module for Terraform

## terraform-tencentcloud-cls-notice-content

A terraform module that creates a CLS (Cloud Log Service) alarm notification content template (`tencentcloud_cls_notice_content`). It defines the notification channel and the message body/title for both trigger and recovery events, and is referenced by the `cls-alarm-notice` module via `notice_content_id`.

## Usage

```hcl
module "cls_alarm_notification_template" {
  source = "terraform-tencentcloud-modules/cls-notice-content/tencentcloud"

  notice_content_name             = "my-notice-content"
  notice_content_channel          = "Http"   # Email, Sms, WeChat, Phone, WeCom, DingTalk, Lark, Http
  notice_content_trigger_title    = "Alarm Triggered"
  notice_content_trigger_content  = "{{.Labels}}"
  notice_content_recovery_title   = "Alarm Recovered"
  notice_content_recovery_content = "{{.Labels}}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| notice_content_name | The name of notice content. | string | n/a | yes |
| notice_content_channel | Channel type. Values: Email, Sms, WeChat, Phone, WeCom, DingTalk, Lark, Http. | string | "Http" | no |
| notice_content_trigger_title | The title of the trigger notification content. | string | "" | no |
| notice_content_trigger_content | Notification content template body information. | string | n/a | yes |
| notice_content_trigger_headers | Request headers sent in HTTP requests. | set(string) | ["Content-Type:application/json"] | no |
| notice_content_recovery_title | The title of the recovery notification content. | string | "" | no |
| notice_content_recovery_content | Notification content template body information. | string | n/a | yes |
| notice_content_recovery_headers | Request headers sent in HTTP requests. | set(string) | ["Content-Type:application/json"] | no |

## Outputs

| Name | Description |
|------|-------------|
| cls_alarm_notification_template_id | The ID of cls alarm notification template. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-cls-notice-content)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
