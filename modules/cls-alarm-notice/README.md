# TencentCloud CLS Alarm Notice Module for Terraform

## terraform-tencentcloud-cls-alarm-notice

A terraform module that creates a CLS (Cloud Log Service) alarm notice (notification group, `tencentcloud_cls_alarm_notice`) and an optional Web callback (`tencentcloud_cls_web_callback`). It is typically used together with the `cls-alarm` module to deliver alarm messages to receivers (email/SMS/WeChat/phone) and/or a custom webhook.

## Usage

```hcl
module "cls_alarm_notice" {
  source = "terraform-tencentcloud-modules/cls-alarm-notice/tencentcloud"

  notice_name       = "my-alarm-notice"
  notice_type       = "All"          # Trigger / Recovery / All
  notice_content_id = "Default-zh"   # Refer to the built-in notice content templates

  # (Optional) Create a Web callback automatically.
  web_callback_name   = "webhook"
  web_callback_url    = "http://127.0.0.1:8080"
  web_callback_type   = "Http"       # Http / WeCom / DingTalk / Lark
  web_callback_method = "POST"       # GET / POST
}
```

If you already have an existing Web callback, pass its ID directly and no new callback will be created:

```hcl
module "cls_alarm_notice" {
  source = "terraform-tencentcloud-modules/cls-alarm-notice/tencentcloud"

  notice_name       = "my-alarm-notice"
  notice_type       = "All"
  notice_content_id = "Default-zh"

  web_callback_id = "existing-web-callback-id"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| notice_name | Alarm notice name. | string | n/a | yes |
| notice_type | Notice type. Valid values: `Trigger`, `Recovery`, `All`. | string | n/a | yes |
| notice_content_id | Notice content id. | string | "" | no |
| notice_receivers_channels | Receiver channels, Values: Email, Sms, WeChat, Phone. | set(string) | [] | no |
| notice_receivers_ids | Receiver ids. | set(string) | [] | no |
| notice_receivers_type | Receiver type. Values: `Group`, `Uin`. | string | "" | no |
| notice_receivers_start_time | Start time allowed to receive messages. | string | "" | no |
| notice_receivers_end_time | End time allowed to receive messages. | string | "" | no |
| notice_tag | Tag description list. | map(string) | {} | no |
| web_callback_id | Web Callback id. When set, the existing callback is reused and no new one is created. | string | "" | no |
| web_callback_name | Callback name. Used only when `web_callback_id` is empty. | string | "" | no |
| web_callback_type | Callback type. Values: Http, WeCom, DingTalk, Lark. Used only when `web_callback_id` is empty. | string | "" | no |
| web_callback_url | Callback url. Used only when `web_callback_id` is empty. | string | "" | no |
| web_callback_method | Callback method. Values: GET, POST. Used only when `web_callback_id` is empty. | string | "POST" | no |

## Outputs

| Name | Description |
|------|-------------|
| cls_alarmnotice_id | The ID of the AlarmNotice. |
| cls_webcallback_id | The ID of the WebCallback. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-cls-alarm-notice)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
