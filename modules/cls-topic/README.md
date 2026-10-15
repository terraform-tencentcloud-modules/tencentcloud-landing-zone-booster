# CLS Topic Module

Manage a [Tencent Cloud Cloud Log Service (CLS) log topic](https://www.tencentcloud.com/document/product/614) (`tencentcloud_cls_topic`) and its optional index (`tencentcloud_cls_index`) in a Landing Zone.

This module follows the "single-config" convention used across `tc-modules`: a single module instance manages **one** log topic via flat, individually-named input variables.

## Features

- Create a single CLS log topic with configurable partitions, lifecycle, storage class, web tracking and encryption.
- Optionally create the topic index (`create_index`) with full-text / key-value / tag / dynamic index rules.
- Plan-time `validation` that fails fast when more than one `rules` entry or more than one sub-rule is supplied.

## Usage

```hcl
module "cls_topic" {
  source = "../../tc-modules/modules/cls-topic"

  region    = "ap-shanghai"
  logset_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  topic_name           = "test-topic"
  partition_count      = 1
  auto_split           = false
  max_split_partitions = 40
  storage_type         = "cold"
  period               = 15
  topic_tags = {
    test = "testTags"
  }

  create_index = true
  index_status = true
  rules = [{
    full_text = [{
      case_sensitive = false
      tokenizer      = "@&?|#()='\",;:<>[]{}/ \n\t\r\\"
      contain_z_h    = false
    }]
    key_value = [{
      case_sensitive = false
      key_values = [{
        key = "action"
        value = [{
          type        = "text"
          tokenizer   = "@&?|#()='\",;:<>[]{}/ \n\t\r\\"
          sql_flag    = true
          contain_z_h = false
        }]
      }]
    }]
    tag = []
  }]
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
| `region` | The topic and logset region. | `string` | `""` | no |
| `logset_id` | The logset ID to which the topic belongs. | `string` | n/a | yes |
| `topic_name` | Log topic name. | `string` | n/a | yes |
| `partition_count` | Number of log topic partitions. Default value: 1. Maximum value: 10. | `number` | `null` | no |
| `auto_split` | Whether to enable automatic split. Default value: `true`. | `bool` | `true` | no |
| `max_split_partitions` | Maximum number of partitions to split into for this topic if automatic split is enabled. Default value: 50. | `number` | `50` | no |
| `storage_type` | Log topic storage class. Valid values: `hot` (real-time storage), `cold` (offline storage, needs allowlist). Default value: `hot`. | `string` | `"hot"` | no |
| `period` | Lifecycle in days. Value range: 1~366. Default value: 30. | `number` | `30` | no |
| `topic_tags` | Tag description list. | `map(string)` | `null` | no |
| `hot_period` | `0`: turn off log sinking; non-0: number of days of standard storage after enabling log settling. Must be >= 7 and < `period`. Only effective when `storage_type` is `hot`. | `number` | `7` | no |
| `is_web_tracking` | No-authentication switch. `false`: closed; `true`: enable anonymous access for specified operations. Default: `false`. | `bool` | `false` | no |
| `encryption` | Encryption-related parameters. `0` or not passed: no encryption; `1`: KMS-CLS cloud product key encryption (cannot be disabled once enabled). Only for allowlisted users / encrypted regions. | `number` | `null` | no |
| `describes` | Log topic description. | `string` | `null` | no |
| `create_index` | Controls whether the CLS index should be created. | `bool` | `false` | no |
| `index_status` | Whether the index takes effect. Default value: `true`. | `bool` | `true` | no |
| `include_internal_fields` | Internal field marker of full-text index. `false`: excluding internal fields; `true`: including internal fields. Default: `false`. | `bool` | `false` | no |
| `metadata_flag` | Metadata flag. `0`: full-text index (including metadata field with key-value index enabled); `1`: full-text index (including all metadata fields); `2`: full-text index (excluding metadata fields). Default: `0`. | `number` | `0` | no |
| `rules` | Index rule (set; at most 1 entry). See below for the nested structure. | `set(object({...}))` | `[]` | no |

### `rules` object structure

See `variables.tf` for the authoritative schema. The set accepts **at most one** `rule` object, and each sub-section accepts **at most one** entry (`full_text`, `key_value`, `tag`, `dynamic_index`).

| Field | Sub-fields | Description |
|-------|-----------|-------------|
| `full_text` | `case_sensitive` (bool), `tokenizer` (string), `contain_z_h` (bool) | Full-text index configuration. |
| `key_value` | `case_sensitive` (bool), `key_values[].key` (string), `key_values[].value[].{type, tokenizer, sql_flag, contain_z_h}` | Key-value index configuration for log fields. |
| `tag` | `case_sensitive` (bool), `key_values[].key` (string), `key_values[].value[].{type, tokenizer, sql_flag, contain_z_h}` | Tag (`__TAG__.`) index configuration. |
| `dynamic_index` | `status` (bool) | Automatic index configuration switch. Empty means disabled. |

> Note: metafield keys do not need the `__TAG__.` prefix in `key` — it is added automatically for console display.

## Outputs

| Name | Description |
|------|-------------|
| `topic_id` | The ID of the created log topic. |
| `index_id` | The ID of the created index, or `null` when `create_index` is `false`. |

## Notes / Constraints

- This module does **not** create the logset; pass an existing `logset_id`.
- `rules` is limited to a single rule object with single sub-rules via plan-time validation (mirrors the provider's one-index constraint).
- `storage_type = "cold"` and `encryption` require the log topic to be added to an allowlist first.
- `hot_period` is only meaningful when `storage_type = "hot"` and must satisfy `7 <= hot_period < period`.

## Authors

`tc-modules` maintainers.
