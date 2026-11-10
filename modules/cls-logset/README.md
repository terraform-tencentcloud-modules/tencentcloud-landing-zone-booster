# CLS Logset Module

Manage a [Tencent Cloud Cloud Log Service (CLS) logset](https://www.tencentcloud.com/document/product/614) (`tencentcloud_cls_logset`) in a Landing Zone.

This module follows the "single-config" convention used across `tc-modules`: a single module instance manages **one** logset via flat, individually-named input variables.

## Features

- Create a single CLS logset with a name and optional tags.
- `logset_tags` uses the CLS-native tag list schema (with plan-time validation on count and key uniqueness) rather than a `map(string)`.
- Defaults `logset_tags` to `null` so the attribute stays Computed (no drift on values read back from the CLS API).

## Usage

```hcl
module "cls_logset" {
  source = "../../tc-modules/modules/cls-logset"

  logset_name = "ys-test-logset"
  logset_tags = [
    {
      key   = "test"
      value = "testTags"
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | > 0.14.06 |
| tencentcloud | >= 1.83.28 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `logset_name` | The logset name. | `string` | n/a | yes |
| `logset_tags` | Tag description list (CLS resource). Mutually exclusive with `tags` (provider: ConflictsWith). The CLS API supports up to 10 tag key-value pairs; duplicate keys are not allowed. Defaults to `null` (NOT `[]`) so the attribute stays Computed: values read back from the CLS API are kept and produce no diff. Passing `[]` means "explicitly clear all tags". | `list(object({ key = string, value = string }))` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `logset_id` | The ID of the created logset. |

## Notes / Constraints

- `logset_tags` must be a list of `{ key, value }` objects (CLS-native schema), **not** a `map(string)`.
- At most 10 tag key-value pairs; duplicate keys are rejected at plan time.
- Both `key` and `value` are required for every entry.
- Use `null` (the default) to keep the attribute Computed; use `[]` to explicitly clear all tags.

## Authors

`tc-modules` maintainers.
