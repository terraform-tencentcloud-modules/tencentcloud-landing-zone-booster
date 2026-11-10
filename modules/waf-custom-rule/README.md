# terraform-tencentcloud-waf-custom-rule

A Terraform module that provisions a **WAF Custom Rule** on TencentCloud. A custom rule lets you define fine-grained access control / protection policies for a domain — matching request conditions (`strategies`) and applying an action such as block, CAPTCHA, observe, or redirect.

## Resources

This module creates the following resource:

* [tencentcloud_waf_custom_rule](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/waf_custom_rule) — the WAF custom rule.

## Usage

```hcl
module "waf_custom_rule" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-waf-custom-rule.git"

  name        = "example-custom-rule"
  sort_id     = "10"
  domain      = "www.example.com"
  expire_time = "1677254399"
  status      = "1"
  action_type = "1"
  redirect    = "/"
  strategies = [
    {
      field        = "IP"
      compare_func = "ipmatch"
      content      = "1.1.1.1"
      arg          = ""
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Rule name. | string | n/a | yes |
| sort_id | Priority, value range 0-100. | string | n/a | yes |
| domain | Domain name that needs to add policy. | string | n/a | yes |
| expire_time | Expiration time, measured in seconds, e.g. `1677254399`. | string | n/a | yes |
| redirect | If the action is a redirect, this is the redirect address; in other cases it can be left blank. | string | `/` | no |
| status | The status of the switch, `1` is on, `0` is off. | string | `1` | no |
| action_type | Action type: `1` block, `2` captcha, `3` observe, `4` redirect. | string | `1` | no |
| strategies | Strategies detail (matching conditions). | `list(object({ field = string, compare_func = string, content = string, arg = string }))` | `[]` | no |

### `strategies` object attributes

| Attribute | Description |
|-----------|-------------|
| `field` | The field to match (e.g. `IP`, `UA`, `HOST`, `URL`, etc.). |
| `compare_func` | The comparison function (e.g. `ipmatch`, `equal`, `include`, etc.). |
| `content` | The content to match against. |
| `arg` | The argument for the matched field, used when the field requires a sub-parameter. |

## Outputs

No outputs (this module does not define an `outputs.tf`).

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-waf-custom-rule)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6 |
| tencentcloud | >= 1.81.136 |
