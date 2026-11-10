# Config Update Aggregate Config Deliver Module

Manage the [Tencent Cloud aggregate config delivery configuration](https://www.tencentcloud.com/document/product/1211) (`tencentcloud_config_update_aggregate_config_deliver`) in a Landing Zone. This controls whether and where aggregated (multi-account) Config resource snapshots / change records are delivered (to COS or CLS) **per account group** (`account_group_id`).

This module follows the "single-config" convention used by `config-deliver` / `config-recorder` across `tc-modules`: each module instance manages **one** aggregate delivery configuration via flat, individually-named input variables (no `for_each`).

## Important: per-account-group, destroy is a no-op

- The resource is **keyed by `account_group_id`** — the cloud keeps **one** aggregate delivery configuration per account group, and the resource id IS the account group id. Use a separate module instance (or a `for_each` wrapper) per account group.
- `account_group_id` is **ForceNew**: changing it triggers resource recreation.
- `terraform destroy` is a **no-op** for this resource (the provider's delete returns without calling any API), so the cloud-side aggregate delivery config is NOT removed by destroying the Terraform resource. To stop delivery, set `status = 0`.

## Features

- Manage a single aggregate delivery configuration via flat input variables.
- Plan-time `validation` for `status`, `deliver_type` and `deliver_content_type` value ranges.

## Usage

```hcl
module "config_aggregate_deliver" {
  source = "../../tc-modules/modules/config-update-aggregate-deliver"

  account_group_id     = "ag-xxxxxxxx"
  status               = 1 # enabled
  deliver_name         = "aggregate-delivery-to-cos"
  deliver_type         = "COS"
  target_arn           = "qcs::cos:ap-guangzhou:uin/100000000001:prefix/1250000000/my-config-bucket"
  deliver_prefix       = "aggregate-snapshots"
  deliver_content_type = 3 # all (configuration change + resource list)
}
```

To disable aggregate delivery, keep the module and set `status = 0` (recommended over destroying, since destroy is a no-op anyway):

```hcl
module "config_aggregate_deliver" {
  source = "../../tc-modules/modules/config-update-aggregate-deliver"

  account_group_id = "ag-xxxxxxxx"
  status           = 0 # disabled
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
| `account_group_id` | Account group ID. Identifies the resource (the resource id IS the account group id). ForceNew. | `string` | n/a | yes |
| `status` | Delivery switch. `0` (disabled), `1` (enabled). | `number` | n/a | yes |
| `deliver_name` | Delivery service name (optional, computed by cloud). | `string` | `null` | no |
| `target_arn` | Resource ARN. COS format: `qcs::cos:$region:$account:prefix/$appid/$BucketName`. CLS format: `qcs::cls:$region:$account:cls/topicId`. (optional, computed by cloud) | `string` | `null` | no |
| `deliver_prefix` | Log prefix for stored delivery content (optional, computed by cloud). | `string` | `null` | no |
| `deliver_type` | Delivery type. `COS` or `CLS`. Defaults to `COS` on the cloud side when omitted (optional, computed by cloud). | `string` | `null` | no |
| `deliver_uin` | Member account uin that supports cross-account delivery. Only the delegated administrator can be used. `0` (default) means delivery to the administrator account (optional, computed by cloud). | `number` | `null` | no |
| `deliver_content_type` | Delivery content type. `1` (configuration change), `2` (resource list), `3` (all). Defaults to `1` on the cloud side when omitted (optional, computed by cloud). | `number` | `null` | no |

## Outputs

Because the resource is a single config, every output is a scalar value.

| Name | Description |
|------|-------------|
| `id` | Resource id (the account group id). |
| `account_group_id` | Account group id. |
| `status` | Delivery switch (`0` / `1`). |
| `deliver_name` | Delivery service name. |
| `target_arn` | Target resource ARN (COS or CLS). |
| `deliver_type` | Delivery type (`COS` / `CLS`). |
| `deliver_prefix` | Log prefix for stored delivery content. |
| `deliver_uin` | Cross-account delivery member uin (`0` = administrator account). |
| `deliver_content_type` | Delivery content type (`1` / `2` / `3`). |
| `create_time` | Creation time. |

## Notes / Constraints

- The cloud keeps **one** aggregate delivery config per `account_group_id`. Re-applying with a different `account_group_id` recreates the resource (ForceNew); declaring two instances with the same `account_group_id` in the same account will cause them to fight over the same cloud config.
- `terraform destroy` does NOT delete the cloud-side aggregate delivery config (provider delete is a no-op). To stop delivery, set `status = 0`.
- `deliver_name`, `target_arn`, `deliver_prefix`, `deliver_type`, `deliver_uin`, `deliver_content_type` are Optional + Computed: when omitted the cloud applies its defaults and returns the computed value.
- `target_arn` format differs by `deliver_type`: use the COS prefix ARN when `deliver_type = "COS"`, and the CLS topic ARN when `deliver_type = "CLS"`.

## Authors

`tc-modules` maintainers.
