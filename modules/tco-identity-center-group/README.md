# terraform-tencentcloud-tco-identity-center-group

Terraform module which creates Identity Center groups and attaches users to them on TencentCloud.

The following resources are included.

* [Identity Center Group](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/identity_center_group)
* [Identity Center User Group Attachment](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/identity_center_user_group_attachment)

## Usage

```hcl
variable "zone_id" {
  type    = string
  default = "z-xxxxxxxxxxxxxxxxxxxx"
}

variable "groups" {
  type = map(object({
    group_name  = string
    users       = list(number)
    description = string
  }))
  default = {
    admins = {
      group_name  = "admins"
      users       = [1000001, 1000002]
      description = "Administrator group"
    }
    developers = {
      group_name  = "developers"
      users       = [1000003]
      description = "Developer group"
    }
  }
}

module "identity_center_group" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-group.git"

  zone_id = var.zone_id
  groups  = var.groups
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Whether to create the Identity Center groups. | bool | true | no |
| zone_id | CIC zone ID, copied from the console. | string | "" | no |
| groups | Group configs for CIC group creation. Each group contains a name and a list of user IDs. | map(object({ group_name = string, users = list(number), description = string })) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| group_ids | A map of group keys to the created Identity Center group IDs. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-group)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
