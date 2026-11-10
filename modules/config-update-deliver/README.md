# Config Update Config Deliver Module

Manage the [Tencent Cloud config delivery configuration](https://www.tencentcloud.com/document/product/1211) (`tencentcloud_config_update_config_deliver`) in a Landing Zone. This controls whether and where Config resource snapshots / change records are delivered (to COS or CLS) at the **account level**.

This module follows the "single-config" convention used by `config-deliver` / `config-recorder` / `config-update-aggregate-deliver` across `tc-modules`: a single module instance manages **one** account-level delivery configuration via flat, individually-named input variables (no `for_each`).

## Important: account-level singleton, destroy is a no-op

- The delivery configuration is an **account-level singleton**: the cloud keeps **one** delivery config per account (region), and the resource id is the provider region. Declaring more than one instance of this module for the same account/region makes them fight over the same cloud config.
- `terraform destroy` is a **no-op** for this resource (the provider's delete returns without calling any API), so the cloud-side delivery config is NOT removed by destroying the Terraform resource. To stop delivery, set `status = 0`.

## Features

- Manage a single account-level delivery configuration via flat input variables.
- Plan-time `validation` for `status`, `deliver_type` and `deliver_content_type` value ranges.

## Usage

```hcl
module "config_deliver" {
  source = "../../tc-modules/modules/config-update-deliver"

  status               = 1 # enabled
  deliver_name         = "config-delivery-to-cos"
  deliver_type         = "COS"
  target_arn           = "qcs::cos:ap-guangzhou:uin/100000000001:prefix/1250000000/my-config-bucket"
  deliver_prefix       = "snapshots"
  deliver_content_type = 3 # all (configuration change + resource list)
}
```

To disable delivery, keep the module and set `status = 0` (recommended over destroying, since destroy is a no-op anyway):

```hcl
module "config_deliver" {
  source = "../../tc-modules/modules/config-update-deliver"

  status = 0 # disabled
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
| `status` | Delivery switch. `0` (disabled), `1` (enabled). | `number` | n/a | yes |
| `deliver_name` | Delivery service name (optional, computed by cloud when omitted). | `string` | `null` | no |
| `target_arn` | Resource ARN. COS format: `qcs::cos:$region:$account:prefix/$appid/$BucketName`. CLS format: `qcs::cls:$region:$account:cls/topicId`. (optional, computed by cloud when omitted) | `string` | `null` | no |
| `deliver_prefix` | Log prefix for stored delivery content (optional, computed by cloud when omitted). | `string` | `null` | no |
| `deliver_type` | Delivery type. `COS` or `CLS`. Defaults to `COS` on the cloud side when omitted (optional, computed by cloud). | `string` | `null` | no |
| `deliver_content_type` | Delivery content type. `1` (configuration change), `2` (resource list), `3` (all). Defaults to `1` on the cloud side when omitted (optional, computed by cloud). | `number` | `null` | no |

## Outputs

Because the resource is a single config, every output is a scalar value.

| Name | Description |
|------|-------------|
| `id` | Resource id (the provider region, since the delivery config is an account-level singleton). |
| `status` | Delivery switch (`0` / `1`). |
| `deliver_name` | Delivery service name. |
| `target_arn` | Target resource ARN (COS or CLS). |
| `deliver_type` | Delivery type (`COS` / `CLS`). |
| `deliver_prefix` | Log prefix for stored delivery content. |
| `deliver_content_type` | Delivery content type (`1` / `2` / `3`). |
| `create_time` | Creation time of the delivery configuration. |

## Notes / Constraints

- The cloud keeps **one** delivery config per account/region. Use exactly one instance of this module per account/region.
- `terraform destroy` does NOT delete the cloud-side delivery config (provider delete is a no-op). To stop delivery, set `status = 0`.
- `deliver_name`, `target_arn`, `deliver_prefix`, `deliver_type`, `deliver_content_type` are Optional + Computed: when omitted the cloud applies its defaults and returns the computed value.
- `target_arn` format differs by `deliver_type`: use the COS prefix ARN when `deliver_type = "COS"`, and the CLS topic ARN when `deliver_type = "CLS"`.
- This is the **account-level** delivery resource. Use `config-update-aggregate-deliver` for per-account-group (aggregated / multi-account) delivery instead.

## Authors

`tc-modules` maintainers.
