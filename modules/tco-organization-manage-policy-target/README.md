# terraform-tencentcloud-tco-organization-manage-policy-target

Terraform module which binds (attaches) Organization management policies to target nodes or members on TencentCloud.

The following resources are included.

* [Organization Org Manage Policy Target](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_manage_policy_target)

## Usage

```hcl
variable "org_manage_policy_targets" {
  type = list(object({
    target_id   = number # Binding target ID of the policy. Member UIN or Department ID.
    target_type = string # Target type. NODE: Department. MEMBER: Member.
    policy_id   = number # Policy ID.
    policy_type = optional(string, "SERVICE_CONTROL_POLICY") # Policy type. SERVICE_CONTROL_POLICY or TAG_POLICY.
  }))
  default = [
    {
      target_id   = 100001
      target_type = "MEMBER"
      policy_id   = 1
      policy_type = "SERVICE_CONTROL_POLICY"
    }
  ]
}

module "organization_manage_policy_target" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-manage-policy-target.git"

  org_manage_policy_targets = var.org_manage_policy_targets
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| org_manage_policy_targets | A list of organization management policy targets. Each item contains: `target_id` (member UIN or department ID), `target_type` (NODE or MEMBER), `policy_id` (policy ID), optional `policy_type` (SERVICE_CONTROL_POLICY or TAG_POLICY, default SERVICE_CONTROL_POLICY). | list(object({ target_id = number, target_type = string, policy_id = number, policy_type = optional(string, "SERVICE_CONTROL_POLICY") })) | n/a | yes |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-manage-policy-target)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
