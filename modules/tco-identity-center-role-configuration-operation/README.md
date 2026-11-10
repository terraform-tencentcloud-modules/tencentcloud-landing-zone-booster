# terraform-tencentcloud-tco-identity-center-role-configuration-operation

Terraform module which triggers the provisioning (deployment) of Identity Center role configurations to target accounts on TencentCloud. The deployment is triggered only when `deployment_status` equals `DeployedRequired`, typically fed from the role-assignment module.

The following resources are included.

* [Provision Role Configuration Operation](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/provision_role_configuration_operation)

## Usage

```hcl
variable "zone_id" {
  type    = string
  default = "z-xxxxxxxxxxxxxxxxxxxx"
}

variable "role_id" {
  type    = string
  default = "rc-30000001"
}

variable "target_uin" {
  type    = number
  default = 100000001
}

variable "target_type" {
  type    = string
  default = "MemberUin"
}

variable "deployment_status" {
  type    = string
  default = "DeployedRequired"
}

module "provision_role_configuration_operation" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-role-configuration-operation.git"

  zone_id           = var.zone_id
  role_id           = var.role_id
  target_uin        = var.target_uin
  target_type       = var.target_type
  deployment_status = var.deployment_status
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Whether to create the resources. | bool | true | no |
| zone_id | The zone ID for the Tencent Cloud provision role operation. | string | null | no |
| target_uin | The target UIN for the provision operation. | number | null | no |
| target_type | Type of the synchronized target account of the Tencent Cloud Organization. ManagerUin: admin account; MemberUin: member account. | string | "MemberUin" | no |
| role_id | The role configuration ID. | string | null | no |
| deployment_status | Output from the role-assignment module. When the value is `DeployedRequired`, the redeploy is triggered. | string | "" | no |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-role-configuration-operation)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
