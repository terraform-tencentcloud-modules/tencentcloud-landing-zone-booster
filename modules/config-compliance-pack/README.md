# Config Compliance Pack Module

Manage [Tencent Cloud Config compliance packs](https://www.tencentcloud.com/document/product/1211) (`tencentcloud_config_compliance_pack`) in a Landing Zone. A compliance pack is a collection of config rules (managed or custom) grouped by risk level, used to evaluate resource compliance against organizational guardrails.

This module follows the "single-big-object `for_each`" convention used across `tc-modules`: a single map variable `compliance_packs` drives all instances, keyed by a logical name.

## Features

- Create multiple compliance packs in one declaration via `for_each`.
- `config_rules` is modeled as a `set` (keyed by `identifier`), matching the resource's `TypeSet` schema.
- `input_parameter` per rule is supported via a nested `dynamic` block.
- Plan-time `validation` that fails fast with readable messages when `risk_level` / `status` are out of range.
- `lifecycle { prevent_destroy = true }` because the cloud does NOT support deleting a compliance pack via API (see Notes).

## Usage

```hcl
module "config_compliance_pack" {
  source = "../../tc-modules/modules/config-compliance-pack"

  compliance_packs = {
    cis_baseline = {
      compliance_pack_name = "cis-baseline-pack"
      risk_level           = 1 # high
      description           = "CIS-aligned baseline compliance pack"
      status                = "ACTIVE"
      config_rules = [
        {
          identifier              = "cls-marked-resources"
          rule_name               = "Tagged resources"
          risk_level             = 2
          managed_rule_identifier = "cfg-cis-001"
          input_parameter = [
            { parameter_key = "requiredTagKeys", type = "Require", value = "Owner,Environment" }
          ]
        },
        {
          identifier = "custom-lambda-rule-arn"
          rule_name  = "Custom encryption check"
          risk_level = 1
        },
      ]
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
| `compliance_packs` | A map of config compliance packs to create. Key is a logical name used as the `for_each` key. | `map(object({ compliance_pack_name = string, risk_level = number, config_rules = set(object({ identifier = string, rule_name = optional(string), description = optional(string), risk_level = optional(number), managed_rule_identifier = optional(string), config_rule_id = optional(string), compliance_pack_id = optional(string), input_parameter = optional(list(object({ parameter_key = string, type = optional(string), value = optional(string) })), []) })), description = optional(string), status = optional(string) }))` | n/a | yes |

### Compliance pack object fields

| Field | Description |
|-------|-------------|
| `compliance_pack_name` | Compliance pack name. |
| `risk_level` | Risk level. `1` (high), `2` (medium), `3` (low). |
| `config_rules` | Set of compliance pack rules, keyed by `identifier`. See below. |
| `description` | Description of the compliance pack (optional). |
| `status` | Compliance pack status. `ACTIVE` or `UN_ACTIVE`. Defaults to `ACTIVE` when omitted. |

### Config rule object fields

| Field | Description |
|-------|-------------|
| `identifier` | Rule identifier (managed rule name or custom rule cloud function ARN). **Required**, used as the set key. |
| `rule_name` | Rule name (optional, computed by cloud). |
| `description` | Rule description (optional, computed by cloud). |
| `risk_level` | Rule risk level. `1` (high), `2` (medium), `3` (low) (optional). |
| `managed_rule_identifier` | Managed rule identifier (preset rule identity, optional). |
| `config_rule_id` | Config rule ID (optional, computed by cloud). |
| `compliance_pack_id` | Compliance pack ID that this rule belongs to (optional, computed by cloud). |
| `input_parameter` | Rule input parameters. Each item has `parameter_key` (required), `type` (optional) and `value` (optional). |

## Outputs

Because the resource is created with `for_each`, every output is a `map` keyed by the same logical name used in `var.compliance_packs`.

| Name | Description |
|------|-------------|
| `compliance_pack_ids` | Map of compliance pack logical name to its compliance pack ID. |
| `status` | Map of compliance pack logical name to its status (`ACTIVE` / `UN_ACTIVE`). |
| `create_time` | Map of compliance pack logical name to its creation time. |
| `config_rules` | Map of compliance pack logical name to its resolved config rules (including computed fields like `status` and `compliance_result`). |

## Notes / Constraints

> ⚠️ **Deletion is NOT supported by the cloud API.** The provider's delete implementation returns an error: `tencentcloud config compliance pack not supported delete, please contact the work order for processing`. This module sets `lifecycle { prevent_destroy = true }` to block accidental `terraform destroy`. To actually remove a pack, open a Tencent Cloud support ticket. Plan changes that would recreate/destroy a pack will be blocked by `prevent_destroy`.

- `config_rules` is a `set` keyed by `identifier`; do not rely on ordering, and avoid duplicate `identifier` values.
- `risk_level` and rule `risk_level` must be in `1`-`3`; `status` must be `ACTIVE` or `UN_ACTIVE` (enforced by `validation`).
- `status`, `rule_name`, `description`, `config_rule_id`, `compliance_pack_id`, `config_rules[].status` and `config_rules[].compliance_result` are computed/returned by the cloud — set `status = "UN_ACTIVE"` at create time if you want the pack disabled on creation.

## Authors

`tc-modules` maintainers.
