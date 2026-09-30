# terraform-tencentcloud-waf-attack-white-rule

A Terraform module that manages a **WAF Attack White Rule** on TencentCloud. An attack white rule lets you whitelist specific requests so they bypass WAF attack detection, either by specific rule IDs, by rule type, or by custom matching conditions.

## Resources

This module creates the following resource:

* [tencentcloud_waf_attack_white_rule](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/waf_attack_white_rule) — the WAF attack white/allowlist rule.

## Usage

```hcl
module "waf_attack_white_rule" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-waf-attack-white-rule.git"

  waf_attack_white_rule = {
    name          = "example-white-rule"
    domain        = "www.example.com"
    status        = 1
    mode          = 0
    signature_ids = ["10000001", "10000002"]
    type_ids      = ["11", "13"]
    rules = [
      {
        match_content = "test.com"
        match_field   = "HTTPXCUSTOM"
        match_method  = "eq"
        match_params  = ""
      }
    ]
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| waf_attack_white_rule | WAF attack white rule object. | `object({ name = string, domain = string, status = number, mode = optional(number), signature_ids = optional(set(string)), type_ids = optional(set(string)), rules = list(object({ match_content = string, match_field = string, match_method = string, match_params = optional(string) })) })` | n/a | yes |

### `waf_attack_white_rule` object attributes

| Attribute | Description |
|-----------|-------------|
| `name` | Rule name. |
| `domain` | Domain protected by the rule. |
| `status` | Rule status (`1` enabled, `0` disabled). |
| `mode` | Whitening mode: `0` whiten by specific rule IDs (`signature_ids`), `1` whiten by rule type (`type_ids`). |
| `signature_ids` | (Optional) Set of rule IDs to whitelist. |
| `type_ids` | (Optional) Set of category rule IDs to whitelist. |
| `rules` | List of custom matching conditions. Each item has `match_content` (matching content), `match_field` (matching field/domain), `match_method` (matching method), and optional `match_params` (matching params). |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the WAF attack white rule. |
| rule_id | The rule ID of the WAF attack white rule. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-waf-attack-white-rule)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6 |
| tencentcloud | >= 1.81.197 |
