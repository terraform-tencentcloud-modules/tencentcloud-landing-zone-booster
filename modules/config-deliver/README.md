# Config Deliver Config Module

Manage the [Tencent Cloud Config delivery configuration](https://www.tencentcloud.com/document/product/1211) (`tencentcloud_config_deliver_config`) in a Landing Zone. The delivery configuration controls whether and where Config resource snapshots / change records are delivered (to COS or CLS).

## Important: account-level singleton

This resource is **account-scoped and unique**. The cloud API `DescribeConfigDeliver` / `UpdateConfigDeliver` operate on a single account-wide delivery setting with **no resource id filter** — there is only one delivery configuration per account.

- This module therefore manages **exactly one** instance via a set of top-level variables (not a `for_each` map). Do not declare multiple instances; they would overwrite the same account-wide setting.
- `terraform destroy` is a **no-op** for this resource (the provider's delete returns without calling any API), so the cloud-side delivery config is NOT removed by destroying the Terraform resource.

## Features

- Manage the account-wide delivery switch and target via top-level variables (`status`, `deliver_name`, `target_arn`, `deliver_prefix`, `deliver_type`, `deliver_content_type`).
- Plan-time `validation` for `status`, `deliver_type` and `deliver_content_type` value ranges.

## Usage

Enable delivery to COS:

```hcl
module "config_deliver" {
  source = "../../tc-modules/modules/config-deliver"

  status               = 1 # enabled
  deliver_name         = "config-delivery-to-cos"
  deliver_type         = "COS"
  target_arn           = "qcs::cos:ap-guangzhou:uin/100000000001:prefix/1250000000/my-config-bucket"
  deliver_prefix       = "config-snapshots"
  deliver_content_type = 3 # all (configuration change + resource list)
}
```

To disable delivery, keep the module and set `status = 0` (recommended over destroying, since destroy is a no-op anyway):

```hcl
module "config_deliver" {
  source = "../../tc-modules/modules/config-deliver"

  status = 0 # disabled
  # other arguments left to their default (null) when disabling
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
| `deliver_name` | Delivery service name. | `string` | `null` | no |
| `target_arn` | Resource ARN. COS format: `qcs::cos:$region:$account:prefix/$appid/$BucketName`. CLS format: `qcs::cls:$region:$account:cls/topicId`. | `string` | `null` | no |
| `deliver_prefix` | Log prefix for stored delivery content. | `string` | `null` | no |
| `deliver_type` | Delivery type. `COS` or `CLS`. | `string` | `null` | no |
| `deliver_content_type` | Delivery content type. `1` (configuration change), `2` (resource list), `3` (all). | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `deliver_config_id` | The id of the delivery configuration (a generated token, not the cloud resource id). |
| `status` | Delivery switch. `0` (disabled), `1` (enabled). |
| `deliver_name` | Delivery service name. |
| `target_arn` | Resource ARN of the delivery target (COS or CLS). |
| `deliver_type` | Delivery type. `COS` or `CLS`. |
| `deliver_content_type` | Delivery content type. `1` / `2` / `3`. |
| `create_time` | Creation time of the delivery configuration. |

## Notes / Constraints

- Only ONE delivery config exists per account. Re-applying with different values updates (overwrites) the same account-wide setting; declaring the module twice in the same account will cause the two instances to fight over the same cloud config.
- `terraform destroy` does NOT delete the cloud-side delivery config (provider delete is a no-op). To stop delivery, set `status = 0`.
- `target_arn` format differs by `deliver_type`: use the COS prefix ARN when `deliver_type = "COS"`, and the CLS topic ARN when `deliver_type = "CLS"`.

## Authors

`tc-modules` maintainers.
