# terraform-tencentcloud-waf-clb-instance

A Terraform module that provisions a **WAF CLB instance** (a TencentCloud Web Application Firewall instance bound to a Cloud Load Balancer) on TencentCloud. The module creates the billing/subscription parameters and optional add-on features (API Security, Bot Management, elastic billing) for the WAF instance.

## Resources

This module creates the following resource:

* [tencentcloud_waf_clb_instance](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/waf_clb_instance) — the WAF CLB instance.

## Usage

```hcl
module "waf_clb_instance" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-waf-clb-instance.git"

  goods_category  = "premium_clb"
  instance_name   = "example-waf"
  time_span       = 1
  time_unit       = "m"
  auto_renew_flag = 1
  elastic_mode    = 1
  qps_limit       = 200000
  api_security    = 0
  bot_management  = 0
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| goods_category | Billing order parameters. Support: `premium_clb`, `enterprise_clb`, `ultimate_clb`. | string | `premium_clb` | no |
| instance_name | WAF instance name. | string | `""` | no |
| time_span | Time interval (subscription duration). | number | `1` | no |
| time_unit | Time unit, support `d`, `m`, `y` (`d`: day, `m`: month, `y`: year). | string | `m` | no |
| auto_renew_flag | Auto renew flag, `1`: enable, `0`: disable. | number | `1` | no |
| elastic_mode | Whether elastic billing is enabled, `1`: enable, `0`: disable. | number | `1` | no |
| qps_limit | QPS limit. Minimum 10000. Only settable when `elastic_mode` is `1`. | number | `200000` | no |
| api_security | Whether to purchase API Security, `1`: yes, `0`: no. | number | `0` | no |
| bot_management | Whether to purchase Bot Management, `1`: yes, `0`: no. | number | `0` | no |

## Outputs

No outputs (this module does not define an `outputs.tf`).

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-waf-clb-instance)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6 |
| tencentcloud | >= 1.81.136 |
