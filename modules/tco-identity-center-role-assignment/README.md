# terraform-tencentcloud-tco-identity-center-role-assignment

Terraform module which creates Identity Center role assignments on TencentCloud.

The following resources are included.

* [Identity Center Role Assignment](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/identity_center_role_assignment)

## Usage

```hcl
variable "zone_id" {
  type    = string
  default = "z-xxxxxxxxxxxxxxxxxxxx"
}

variable "assignments" {
  type = map(object({
    principal_id          = string # User or group ID to sync the CAM role and user.
    principal_type        = string # User: the identity for CAM user synchronization is a CIC user. Group: the identity for CAM user synchronization is a CIC user group.
    target_uin            = number # UIN of the synchronized target account of the Tencent Cloud Organization.
    target_type           = string # Type of the synchronized target account. ManagerUin: admin account; MemberUin: member account.
    role_configuration_id = string # ID of the CAM role configuration.
    deprovision_strategy  = optional(string, "None") # Deprovisioning strategy. Valid values: None, DeprovisionForDeletedUsers.
  }))
  default = {
    example = {
      principal_id          = "u-20000001"
      principal_type        = "Group"
      target_uin            = 100000001
      target_type           = "MemberUin"
      role_configuration_id = "rc-30000001"
    }
  }
}

module "identity_center_role_assignment" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-role-assignment.git"

  zone_id     = var.zone_id
  assignments = var.assignments
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Whether to create the role assignments. | bool | true | no |
| zone_id | CIC zone ID, copied from the console. | string | "" | no |
| assignments | A map of role assignments. Key is the assignment name, value is an assignment object. Each object contains: `principal_id` (User or group ID to sync the CAM role and user), `principal_type` (User or Group), `target_uin` (UIN of the synchronized target account), `target_type` (ManagerUin or MemberUin), `role_configuration_id` (ID of the CAM role configuration), and optional `deprovision_strategy` (default "None"). | map(object({ principal_id = string, principal_type = string, target_uin = number, target_type = string, role_configuration_id = string, deprovision_strategy = optional(string) })) | see variables.tf | no |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-role-assignment)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
