# terraform-tencentcloud-tco-organization-manage-policy

Terraform module which creates Organization management policies (service control policies / tag policies) on TencentCloud.

The following resources are included.

* [Organization Org Manage Policy](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_manage_policy)

## Usage

```hcl
variable "org_manage_policies" {
  type = list(object({
    name        = string           # Policy name. Length 1~128 chars, may include Chinese characters, English letters, numbers, and underscores.
    content     = string           # Policy content. Refer to the CAM policy syntax.
    type        = optional(string, "SERVICE_CONTROL_POLICY") # Policy type. SERVICE_CONTROL_POLICY or TAG_POLICY.
    description = optional(string, "") # Policy description.
  }))
  default = [
    {
      name        = "FullAccessPolicy"
      content     = "{\"version\":\"2.0\",\"statement\":[{\"effect\":\"allow\",\"action\":\"*\",\"resource\":\"*\"}]}"
      type        = "SERVICE_CONTROL_POLICY"
      description = "Full access policy"
    }
  ]
}

module "organization_manage_policy" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-manage-policy.git"

  org_manage_policies = var.org_manage_policies
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| org_manage_policies | A list of organization management policies. Each item contains: `name` (policy name, 1~128 chars), `content` (policy content, CAM syntax), optional `type` (SERVICE_CONTROL_POLICY or TAG_POLICY, default SERVICE_CONTROL_POLICY), optional `description` (default ""). | list(object({ name = string, content = string, type = optional(string, "SERVICE_CONTROL_POLICY"), description = optional(string, "") })) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy_ids | A map of policy names to the created organization management policy IDs. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-manage-policy)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
