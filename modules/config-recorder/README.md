# Config Recorder Config Module

Manage the [Tencent Cloud Config recorder configuration](https://www.tencentcloud.com/document/product/1211) (`tencentcloud_config_recorder_config`) in a Landing Zone. The recorder enables resource monitoring (taking configuration snapshots) and defines which resource types are tracked.

## Important: account-level singleton

This resource is **account-scoped and unique**. The cloud API `DescribeConfigRecorder` / `OpenConfigRecorder` / `CloseConfigRecorder` / `UpdateConfigRecorder` operate on a single account-wide recorder setting with **no resource id filter** — there is only one recorder config per account.

- This module therefore manages **exactly one** instance (a single `object`, not a `for_each` map). Do not declare multiple instances; they would overwrite the same account-wide setting.
- `terraform destroy` is a **no-op** for this resource (the provider's delete returns without calling any API), so the cloud-side recorder config is NOT removed by destroying the Terraform resource. To stop monitoring, set `status = false`.

## Features

- Manage the account-wide recorder switch and monitored resource types via two top-level variables (`status`, `resource_types`).
- Plan-time `validation` that `resource_types` items follow the `QCS::` naming convention.

## Usage

Enable monitoring for a set of resource types:

```hcl
module "config_recorder" {
  source = "../../tc-modules/modules/config-recorder"

  status = true
  resource_types = [
    "QCS::CVM::Instance",
    "QCS::CAM::Group",
    "QCS::COS::Bucket",
  ]
}
```

Disable monitoring (recommended over destroying, since destroy is a no-op anyway):

```hcl
module "config_recorder" {
  source = "../../tc-modules/modules/config-recorder"

  status = false
  # resource_types left to its default (empty) when disabling
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
| `status` | Whether to enable resource monitoring. `true`: enable (`OpenConfigRecorder`), `false`: disable (`CloseConfigRecorder`). | `bool` | n/a | yes |
| `resource_types` | Resource type list to monitor (e.g. `QCS::CAM::Group`, `QCS::CVM::Instance`). Each item must start with `QCS::`. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `recorder_config_id` | The id of the recorder configuration (a generated token, not the cloud resource id). |
| `status` | Whether resource monitoring is enabled. |
| `resource_types` | Resource type list being monitored. |
| `create_time` | Recorder creation time. |
| `trigger_count` | Number of snapshots taken today. |
| `open_count` | Number of times monitoring was opened today. |
| `update_count` | Number of monitoring range updates today. |

## Notes / Constraints

- Only ONE recorder config exists per account. Re-applying with different values updates (overwrites) the same account-wide setting; declaring the module twice in the same account will cause the two instances to fight over the same cloud config.
- `terraform destroy` does NOT delete the cloud-side recorder config (provider delete is a no-op). To stop monitoring, set `status = false`.
- `resource_types` items must follow the `QCS::<Service>::<Resource>` naming convention (enforced by `validation`). When omitted, the recorder keeps its existing or default monitoring scope.

## Authors

`tc-modules` maintainers.
