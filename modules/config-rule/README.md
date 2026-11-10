# Config Rule Module

Manage [Tencent Cloud Config rules](https://www.tencentcloud.com/document/product/1211) (`tencentcloud_config_rule`) in a Landing Zone. A config rule evaluates resource compliance against a preset (SYSTEM) or custom (CUSTOMIZE) rule template, with configurable trigger types, scope (regions / tags / excluded resource IDs) and risk level.

This module follows the "single-big-object `for_each`" convention used across `tc-modules`: a single map variable `config_rules` drives all instances, keyed by a logical name.

## Features

- Create multiple config rules in one declaration via `for_each`.
- Nested blocks (`trigger_type`, `input_parameter`, `regions_scope`, `tags_scope`, `exclude_resource_ids_scope`) are expressed via `dynamic` blocks, so optional blocks are only emitted when provided.
- Plan-time `validation` that fails fast with readable messages when `identifier_type` / `risk_level` / `status` / `message_type` / `resource_type` are out of range.
- Supports deletion via the cloud API (`DeleteConfigRule`, which disables an ACTIVE rule before deleting). No `prevent_destroy`.

## Usage

```hcl
module "config_rule" {
  source = "../../tc-modules/modules/config-rule"

  config_rules = {
    encrypted-ebs-only = {
      identifier      = "cfg-encrypted-ebs"
      identifier_type = "SYSTEM"
      rule_name       = "Encrypted EBS volumes only"
      resource_type   = ["QCS::CVM::Instance"]
      trigger_type = [
        {
          message_type = "ConfigurationItemChangeNotification"
        }
      ]
      risk_level = 1
      description = "Ensure attached EBS volumes are encrypted."
      status     = "ACTIVE"
    }
    tag-compliance = {
      identifier      = "ap-guangzhou:my-custom-rule-fn"
      identifier_type = "CUSTOMIZE"
      rule_name       = "Custom tag compliance"
      resource_type   = ["QCS::COS::Bucket"]
      trigger_type = [
        {
          message_type                = "ScheduledNotification"
          maximum_execution_frequency = "TwentyFour_Hours"
        }
      ]
      risk_level           = 2
      regions_scope        = ["ap-guangzhou", "ap-shanghai"]
      tags_scope = [
        {
          tag_key   = "Env"
          tag_value = "prod"
        }
      ]
      exclude_resource_ids_scope = ["qcs::cos:ap-guangzhou:uin/100000000001:bucketName/my-excluded-bucket"]
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | >= 1.81.136 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `config_rules` | A map of config rules to create. Key is a logical name used as the `for_each` key. | `map(object({ ... see fields below ... }))` | n/a | yes |

### Config rule object fields

| Field | Description | ForceNew |
|-------|-------------|:--------:|
| `identifier` | Rule template identifier. System preset: identifier name; custom: cloud function ARN (`region:functionName`). | yes |
| `identifier_type` | Rule template type. `SYSTEM` (preset) or `CUSTOMIZE` (custom). | yes |
| `rule_name` | Rule name. | no |
| `resource_type` | Supported resource type list (e.g. `QCS::CAM::User`). Each item must start with `QCS::`. | yes |
| `trigger_type` | Trigger type list (up to 2). Each item: `message_type` (`ScheduledNotification` / `ConfigurationItemChangeNotification`, required) + `maximum_execution_frequency` (optional, only for `ScheduledNotification`, e.g. `TwentyFour_Hours`). | no |
| `risk_level` | Risk level. `1` (high), `2` (medium), `3` (low). | no |
| `input_parameter` | Rule input parameter list. Each item: `parameter_key` (required), `type` (optional), `value` (optional). | no |
| `description` | Rule description (0~1024 characters, optional). | no |
| `regions_scope` | Region scope list; rule only applies to resources in these regions (optional). | no |
| `tags_scope` | Tag scope list; rule only applies to resources with these tags. Each item: `tag_key`, `tag_value` (both required). | no |
| `exclude_resource_ids_scope` | Resource ID list excluded from rule evaluation (optional). | no |
| `status` | Rule status. `ACTIVE` (enabled) or `UN_ACTIVE` (disabled). Defaults to `ACTIVE` when omitted. | no |

## Outputs

Because the resource is created with `for_each`, every output is a `map` keyed by the same logical name used in `var.config_rules`.

| Name | Description |
|------|-------------|
| `config_rule_ids` | Map of config rule logical name to its config rule ID. |
| `status` | Map of config rule logical name to its status (`ACTIVE` / `UN_ACTIVE`). |
| `rule_names` | Map of config rule logical name to its rule name. |
| `risk_levels` | Map of config rule logical name to its risk level. |
| `create_time` | Map of config rule logical name to its creation time. |
| `compliance_result` | Map of config rule logical name to its compliance result. |
| `config_rule_invoked_time` | Map of config rule logical name to its last evaluation time. |

## Notes / Constraints

- `identifier`, `identifier_type` and `resource_type` are **ForceNew**: changing any of them triggers resource recreation.
- This resource supports deletion via the cloud API. On destroy, the provider first disables an `ACTIVE` rule (via `CloseConfigRule`) and then deletes it — so `terraform destroy` actually removes the rules. No `prevent_destroy` is set.
- `trigger_type` accepts at most 2 entries; `maximum_execution_frequency` is only meaningful when `message_type = "ScheduledNotification"`.
- `status` is Computed: when omitted the cloud defaults it to `ACTIVE`. Set `status = "UN_ACTIVE"` to create the rule disabled.

## Authors

`tc-modules` maintainers.
