# terraform-tencentcloud-tco-identity-center-role-configuration

Terraform module which creates Identity Center role configurations (access configurations) and attaches preset/custom policies to them on TencentCloud.

The following resources are included.

* [Identity Center Role Configuration](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/identity_center_role_configuration)
* [Identity Center Role Configuration Permission Policy Attachment](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/identity_center_role_configuration_permission_policy_attachment)
* [Identity Center Role Configuration Permission Custom Policies Attachment](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/identity_center_role_configuration_permission_custom_policies_attachment)

## Usage

```hcl
variable "zone_id" {
  type    = string
  default = "z-xxxxxxxxxxxxxxxxxxxx"
}

variable "roles" {
  type = list(object({
    role_name        = string                 # Permission (access configuration) name.
    relay_state      = optional(string)       # Initial access page URL (must be a Tencent Cloud console page). Default: null -> console home page.
    session_duration = optional(number)       # Maximum session duration in seconds. Range: 900-43200. Default: 3600.
    description      = optional(string)       # Permission description.
    policies         = optional(list(string), []) # Preset policy names/IDs to attach to this role.
    custom_policies  = optional(list(object({
      role_policy_name     = string # (Required, ForceNew) Role policy name.
      role_policy_document = string # (Required, ForceNew) Role policy document.
    })), [])
  }))
  default = [
    {
      role_name        = "PowerUser"
      session_duration = 3600
      description      = "Power user access configuration"
      policies         = ["QcloudCVMFullAccess"]
      custom_policies  = []
    }
  ]
}

module "identity_center_role_configuration" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-role-configuration.git"

  zone_id = var.zone_id
  roles   = var.roles
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| zone_id | CIC zone ID. | string | n/a | yes |
| roles | A list of role configurations for creation. Each item contains: `role_name` (permission name), optional `relay_state` (initial access page URL), optional `session_duration` (seconds, 900-43200, default 3600), optional `description`, optional `policies` (list of preset policy names/IDs), and optional `custom_policies` (list of objects with `role_policy_name` and `role_policy_document`). | list(object({ role_name = string, relay_state = optional(string), session_duration = optional(number), description = optional(string), policies = optional(list(string), []), custom_policies = optional(list(object({ role_policy_name = string, role_policy_document = string })), []) })) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| role_ids | A map of role configuration names to the created role configuration IDs. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-role-configuration)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
