# Config Aggregator Module

Manage [Tencent Cloud Config aggregators](https://www.tencentcloud.com/document/product/1211) (`tencentcloud_config_aggregator`) in a Landing Zone. An aggregator collects resource configuration snapshots from multiple member accounts into a single management account for centralized compliance review.

This module follows the "single-config" convention used by `config-deliver` / `config-recorder` / `config-update-deliver` / `config-update-aggregate-deliver` across `tc-modules`: a single module instance manages **one** aggregator via flat, individually-named input variables (no `for_each`). Declare the module multiple times (or wrap it in a `for_each`) if you need more than one aggregator.

## Features

- Manage a single config aggregator via flat input variables.
- Supports both aggregator types:
  - `RD` — global aggregator; member accounts are derived automatically from the Resource Directory (no member list needed).
  - `CUSTOM` — custom aggregator; you specify the member accounts explicitly (1–100).
- Plan-time `validation` that fails fast with a readable message when `type`/`aggregator_accounts` are inconsistent (mirrors the provider's `CustomizeDiff` rule).
- Member accounts are only sent to the API for `CUSTOM` aggregators (the `dynamic` block is skipped for `RD`), avoiding the cryptic `InvalidParameter: 参数错误。` from the cloud API.

## Usage

```hcl
module "config_aggregator_global" {
  source = "../../tc-modules/modules/config-aggregator"

  name        = "org-global-aggregator"
  description = "Global config aggregator across the resource directory"
  type        = "RD"
  owner_uin   = "100000000001"
}

module "config_aggregator_custom" {
  source = "../../tc-modules/modules/config-aggregator"

  name        = "spoke-accounts-aggregator"
  description = "Custom aggregator for spoke accounts"
  type        = "CUSTOM"
  owner_uin   = "100000000001"
  aggregator_accounts = [
    { member_uin = 100000000002, member_name = "account-a" },
    { member_uin = 100000000003, member_name = "account-b" },
  ]
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
| `name` | Aggregator name. | `string` | n/a | yes |
| `description` | Aggregator description. | `string` | n/a | yes |
| `type` | Aggregator type. `RD` (global, members from Resource Directory) or `CUSTOM` (members specified explicitly). `ForceNew`. | `string` | n/a | yes |
| `owner_uin` | Creator UIN of the aggregator. Required by Describe/Update/Delete APIs. `ForceNew`. | `string` | n/a | yes |
| `aggregator_accounts` | Member accounts. Required (≥1) when `type = "CUSTOM"`; must be empty for `type = "RD"`. Up to 100 entries. Each item has `member_uin` (number, account ID) and `member_name` (string, account name). | `list(object({ member_uin = number, member_name = string }))` | `[]` | no |

## Outputs

Because the resource is a single config, every output is a scalar value.

| Name | Description |
|------|-------------|
| `id` | Resource id (`account_group_id#owner_uin`). |
| `account_group_id` | Aggregator ID (`account_group_id`). |
| `aggregator_status` | Creation status of the aggregator. |
| `aggregator_accounts` | Resolved member accounts (filled automatically for `RD` aggregators by the cloud). |

## Notes / Constraints

- `type` and `owner_uin` are `ForceNew`: changing them triggers resource recreation.
- The `account_group_id` is only returned after creation; the resource id is `account_group_id#owner_uin`.
- For `RD` aggregators, do **not** set `aggregator_accounts` — members are maintained by the cloud and returned via read.
- For `CUSTOM` aggregators, `aggregator_accounts` must contain at least one entry.

## Authors

`tc-modules` maintainers.
