# Tencent Cloud Config Compliance Pack Component

Terraform component under `components/compliance/pack` for creating a custom Config compliance pack based on a system (preset) compliance pack in Tencent Cloud. It is part of the `compliance` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component implements the following flow:

1. **Query system compliance packs** – use the `tencentcloud_system_config_compliance_packs` data source to retrieve the full list of preset (system) compliance packs.
2. **Filter by id** – pick the target system compliance pack by its `compliance_pack_id`.
3. **Create custom compliance pack** – use `tencentcloud_config_compliance_pack` to create a custom compliance pack that inherits the rules (and optionally metadata) of the source system pack. Individual rules can be excluded via `exclude_rules`.

This is useful when you want to clone a Tencent Cloud preset compliance pack into your own account/custom pack so that it can be assigned, managed and versioned independently.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.83.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.83.35 |

### IAM Permissions

The executing principal needs the following Tencent Cloud permissions:

| Permission | Description |
|------------|-------------|
| `QcloudConfigFullAccess` (or equivalent) | Full access to Cloud Config (Config) management |

### Prerequisites

- The Tencent Cloud Config service must be enabled.
- The `compliance_pack_id` of the desired system (preset) compliance pack must be obtained (from the console or the `tencentcloud_system_config_compliance_packs` data source).

---

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_target_compliance_pack_id"></a> [target\_compliance\_pack\_id](#input\_target\_compliance\_pack\_id) | `string` | yes | – | The `compliance_pack_id` of the system compliance pack used as the source. |
| <a name="input_compliance_pack_name"></a> [compliance\_pack\_name](#input\_compliance\_pack\_name) | `string` | no | `null` | Custom pack name. Falls back to the source system pack name when `null`. |
| <a name="input_description"></a> [description](#input\_description) | `string` | no | `null` | Custom pack description. Falls back to the source system pack description when `null`. |
| <a name="input_risk_level"></a> [risk\_level](#input\_risk\_level) | `number` | no | `null` | Custom pack risk level (`1` High / `2` Medium / `3` Low). Falls back to the source value when `null`. |
| <a name="input_status"></a> [status](#input\_status) | `string` | no | `ACTIVE` | Compliance pack status. Valid values: `ACTIVE`, `UN_ACTIVE`. |
| <a name="input_exclude_rules"></a> [exclude\_rules](#input\_exclude\_rules) | `list(string)` | no | `[]` | Rule identifiers to exclude from the source system pack when creating the custom pack. |
| <a name="input_custom_config_rules"></a> [custom\_config\_rules](#input\_custom\_config\_rules) | `list(object)` | no | `[]` | Additional custom compliance pack rules to merge with (and override by `identifier`) the source system pack rules. Each rule requires `identifier`. |

> **Note**: `compliance_pack_name` and `risk_level` are required by the `tencentcloud_config_compliance_pack` resource. When left as `null` they are inherited from the source system compliance pack. All other metadata fields default to the corresponding value of the source system compliance pack when `null`.

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compliance_pack_id"></a> [compliance\_pack\_id](#output\_compliance\_pack\_id) | The ID of the created custom compliance pack. |
| <a name="output_compliance_pack_name"></a> [compliance\_pack\_name](#output\_compliance\_pack\_name) | The name of the created custom compliance pack. |
| <a name="output_risk_level"></a> [risk\_level](#output\_risk\_level) | The risk level of the created custom compliance pack. |
| <a name="output_description"></a> [description](#output\_description) | The description of the created custom compliance pack. |
| <a name="output_status"></a> [status](#output\_status) | The status of the created custom compliance pack. |
| <a name="output_create_time"></a> [create\_time](#output\_create\_time) | The creation time of the created custom compliance pack. |
| <a name="output_rule_count"></a> [rule\_count](#output\_rule\_count) | The number of rules applied to the created custom compliance pack. |
| <a name="output_config_rules"></a> [config\_rules](#output\_config\_rules) | The list of rules applied to the created custom compliance pack. |
| <a name="output_source_compliance_pack_id"></a> [source\_compliance\_pack\_id](#output\_source\_compliance\_pack\_id) | The `compliance_pack_id` of the source system compliance pack. |

---

## Configuration Example

### `terraform.tfvars` example

```hcl
# Create a custom compliance pack cloned from the system pack with the given id
target_compliance_pack_id = "cpk-xxxxxxxx"

# Optional: override the pack metadata (falls back to the system pack values when null)
compliance_pack_name = "my-custom-pack"
description          = "Cloned from system preset pack"
risk_level           = 2
status               = "ACTIVE"

# Optional: exclude specific rules from the source pack by their identifier
exclude_rules = [
  "rule-identifier-xxxxxxxx",
]

# Optional: add custom rules (merged with, and overriding by `identifier`, the source pack rules)
custom_config_rules = [
  {
    # Override an existing source rule with the same identifier
    identifier              = "rule-identifier-xxxxxxxx"
    rule_name               = "customized-rule-name"
    description             = "Overridden rule description"
    risk_level              = 1
    managed_rule_identifier = "managed-rule-identifier"
  },
  {
    # Brand new custom rule (e.g. referencing a custom rule cloud function ARN)
    identifier  = "custome-rule-arn-or-identifier"
    rule_name   = "my-fully-custom-rule"
    description = "A fully custom compliance rule"
    risk_level  = 2
    input_parameter = [
      {
        parameter_key = "someKey"
        type          = "Require"
        value         = "someValue"
      }
    ]
  },
]
```

### Minimal configuration

```hcl
# Simply clone the system pack as-is (keeps its name/description/risk_level and all rules)
target_compliance_pack_id = "cpk-xxxxxxxx"
```

---

## Usage Notes

### Execution flow

```
┌───────────────────────────────────────────────┐
│ 1. data tencentcloud_system_config_compliance_ │
│    packs "system"  -> fetch all system packs   │
│         │                                       │
│ 2. locals: filter by compliance_pack_id        │
│         │                                       │
│ 3. map source config_rules -> resource rules   │
│    (identifier/rule_name/description/risk_     │
│     level), drop excluded identifiers           │
│         │                                       │
│ 4. resource tencentcloud_config_compliance_pack│
│    "pack" -> create custom pack                 │
└───────────────────────────────────────────────┘
```

### Important notes

1. **Permissions** – ensure the executing principal has Cloud Config (`QcloudConfigFullAccess` or equivalent) permissions.
2. **Valid id** – `target_compliance_pack_id` must exist in the system compliance pack list; otherwise no pack is created and Terraform will error on the missing source attributes.
3. **Required fields** – `compliance_pack_name` and `risk_level` are required by the resource. They are inherited from the source system pack when not explicitly set.
4. **Rule structure** – rules for `tencentcloud_config_compliance_pack` are specified via the `config_rules` set, where `identifier` is required (the managed rule identifier). Metadata such as `rule_name`, `description` and `risk_level` are carried over from the source system pack.
5. **Rule exclusion** – `exclude_rules` removes selected rule identifiers from the source pack; if you need to *add* extra rules, manage them outside this component or extend the `source_config_rules` derivation.
6. **Deletion** – the underlying API does not support deleting a compliance pack; `terraform destroy` will therefore fail. Contact Tencent Cloud support to remove a pack.

## License

See [LICENSE](../../../LICENSE) for full details.
