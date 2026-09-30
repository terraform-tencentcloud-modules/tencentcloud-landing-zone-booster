# terraform-tencentcloud-tco-organization-org-identity

Terraform module which creates an Organization identity (cross-account access identity) on TencentCloud.

The following resources are included.

* [Organization Org Identity](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_identity)

## Usage

```hcl
variable "identity_policies" {
  type = list(object({
    policy_id       = optional(number) # CAM default policy ID. Valid and required when policy_type is 2 (preset policy).
    policy_name     = optional(string) # CAM default policy name. Valid and required when policy_type is 2 (preset policy).
    policy_type     = optional(number) # Policy type. 1: custom policy, 2: preset policy. Default: 2.
    policy_document = optional(string) # Custom policy content (CAM policy syntax). Valid and required when policy_type is 1 (custom policy).
  }))
  default = [
    {
      policy_id   = 1
      policy_name = "QcloudCVMFullAccess"
      policy_type = 2
    }
  ]
}

module "organization_org_identity" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-identity.git"

  identity_alias_name = "CrossOrgAccount"
  description         = "Cross organization account identity"
  identity_policies   = var.identity_policies
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| identity_alias_name | Identity alias name. | string | "CrossOrgAccount" | no |
| description | Identity description. | string | null | no |
| identity_policies | A list of identity policies. Each item contains: optional `policy_id` (CAM preset policy ID), optional `policy_name` (CAM preset policy name), optional `policy_type` (1: custom, 2: preset, default 2), optional `policy_document` (custom policy document). | list(object({ policy_id = optional(number), policy_name = optional(string), policy_type = optional(number), policy_document = optional(string) })) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| identity_id | The ID of the created organization identity. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-identity)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
