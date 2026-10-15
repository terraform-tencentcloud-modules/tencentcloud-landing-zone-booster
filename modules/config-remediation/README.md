# Config Remediation Module

Manage [Tencent Cloud Config remediation settings](https://www.tencentcloud.com/document/product/1211) (`tencentcloud_config_remediation`) in a Landing Zone. A remediation setting binds a Config rule to an automated remediation action (currently only SCF cloud functions), with a configurable invocation mode (manual / automatic / disabled).

This module follows the "single-big-object `for_each`" convention used across `tc-modules`: a single map variable `remediations` drives all instances, keyed by a logical name.

## Features

- Create multiple remediation settings in one declaration via `for_each`.
- Plan-time `validation` that fails fast with readable messages when `remediation_type` / `invoke_type` / `source_type` are out of range.
- Unlike `config-compliance-pack`, this resource **supports deletion** (the provider calls `DeleteRemediations`), so no `prevent_destroy` is set.

## Usage

```hcl
module "config_remediation" {
  source = "../../tc-modules/modules/config-remediation"

  remediations = {
    stop-idle-cvm = {
      rule_id                 = "cr-xxxxxxxx"
      remediation_type        = "SCF"
      remediation_template_id = "qcs::scf:ap-guangzhou:uin/100000000001:functions/stop-idle-cvm"
      invoke_type             = "AUTO_EXECUTION"
      source_type             = "CUSTOM"
    }
    tag-missing-resources = {
      rule_id                 = "cr-yyyyyyyy"
      remediation_type        = "SCF"
      remediation_template_id = "qcs::scf:ap-guangzhou:uin/100000000001:functions/tag-resources"
      invoke_type             = "MANUAL_EXECUTION"
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
| `remediations` | A map of config remediation settings to create. Key is a logical name used as the `for_each` key. | `map(object({ rule_id = string, remediation_type = string, remediation_template_id = string, invoke_type = string, source_type = optional(string) }))` | n/a | yes |

### Remediation object fields

| Field | Description |
|-------|-------------|
| `rule_id` | Config rule ID to bind the remediation setting to (**ForceNew** — changing it recreates the resource). |
| `remediation_type` | Remediation type. Currently only `SCF` (cloud function). |
| `remediation_template_id` | Remediation template ID, i.e. the SCF function resource path (e.g. `qcs::scf:ap-guangzhou:uin/100000000001:functions/xxx`). |
| `invoke_type` | Invocation mode. `MANUAL_EXECUTION` (manual), `AUTO_EXECUTION` (automatic), `NON_EXECUTION` (disabled), `NOT_CONFIG` (not configured). |
| `source_type` | Template source. `CUSTOM` (optional; omit to let the cloud default). |

## Outputs

Because the resource is created with `for_each`, every output is a `map` keyed by the same logical name used in `var.remediations`.

| Name | Description |
|------|-------------|
| `remediation_ids` | Map of remediation logical name to its remediation setting ID. |
| `owner_uins` | Map of remediation logical name to its owner account UIN. |
| `remediation_source_types` | Map of remediation logical name to its remediation source type returned from API. |
| `rule_ids` | Map of remediation logical name to its bound config rule ID. |
| `remediation_types` | Map of remediation logical name to its remediation type. |
| `invoke_types` | Map of remediation logical name to its invocation mode. |
| `source_types` | Map of remediation logical name to its template source type. |

## Notes / Constraints

- `rule_id` is **ForceNew**: changing it triggers resource recreation (Terraform will destroy the old setting and create a new one).
- This resource supports deletion via the cloud API (`DeleteRemediations`), so `terraform destroy` will actually remove the remediation settings — no `prevent_destroy` is set.
- Only `remediation_type = "SCF"` is supported today; `remediation_template_id` must be the SCF function resource path (`qcs::scf:$region:uin/$uin:functions/$funcName`).
- `source_type` is optional; when omitted the cloud applies its default.

## Authors

`tc-modules` maintainers.
