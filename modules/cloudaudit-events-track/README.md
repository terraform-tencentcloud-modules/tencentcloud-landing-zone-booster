# TencentCloud CloudAudit Events Track Module for Terraform 

## terraform-tencentcloud-cloudaudit-events-track

A terraform module that creates a CloudAudit Events Track (`tencentcloud_events_audit_track`) which records account operation events and delivers them to a storage target (COS / CLS / CKafka). Optionally it can create the required CAM role and policy used by CloudAudit to write to the storage.

## Usage

```hcl
provider "tencentcloud" {
  region = var.region
}

module "cloud_audit_events_track" {
  source = "terraform-tencentcloud-modules/cloudaudit-events-track/tencentcloud"

  create_cam_strategy = true # Create the required CAM role and related policy (set false if already enabled via the console)

  track_name            = "tfmodule_audit"
  status                = 1  # 1 = open, 0 = close
  track_for_all_members = 0  # 0 = close, 1 = open (deliver member logs to management account)

  # Storage target (cos / cls / ckafka)
  storage_type     = "cos"
  storage_region   = var.region
  storage_name     = "your-bucket-name"
  storage_prefix   = "tfmodule"
  storage_app_id   = "your-appid"        # Required for cos/cls storage
  storage_account_id = "your-account-id" # Required for cos/cls storage

  # Event filters (at least one entry)
  audit_filters = [
    {
      resource_type = "*"
      action_type   = "*"
      event_names   = ["*"]
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_cam_strategy | Specify whether to create CAM role and related policy. Set to `false` if you have already enabled it via the TencentCloud Console. | bool | false | no |
| track_name | The name of the cloud audit track. | string | n/a | yes |
| track_for_all_members | Whether to enable the delivery of group member operation logs to the group management account or trusted service management account, optional: (close: 0, open: 1). | number | 1 | no |
| status | Track status, optional: (close: 0, open: 1). Default is 1. | number | 1 | no |
| storage_type | Track storage type, optional: `cos`, `cls`, `ckafka`. | string | n/a | yes |
| storage_region | The region of the storage. | string | n/a | yes |
| storage_name | The name of the bucket (COS) / logset (CLS) / topic (CKafka) to store the events. | string | n/a | yes |
| storage_prefix | Storage path prefix. | string | n/a | yes |
| storage_account_id | Designated to store user ID. Required for `cos`/`cls` storage. | string | null | no |
| storage_app_id | Your appid. Required for `cos`/`cls` storage. | string | null | no |
| audit_filters | Data filtering criteria (list of resource type / action type / event names). When `resource_type` is `*`, `event_names` must be `*`. When `resource_type` is a single product (`cos`, `cls`), up to 10 API names are supported. | list(object({ resource_type = string, action_type = string, event_names = list(string) })) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloudaudit_id | The ID of Cloud Audit Track. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-cloudaudit-events-track)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
