# terraform-tencentcloud-tco-organization-manage-policy-config

Terraform module which configures the Organization management policy feature (enables service control policy / tag policy) on TencentCloud.

The following resources are included.

* [Organization Org Manage Policy Config](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_manage_policy_config)

## Usage

```hcl
module "organization_manage_policy_config" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-manage-policy-config.git"

  organization_id = 100001
  policy_type     = "SERVICE_CONTROL_POLICY"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| organization_id | Organization ID. | number | n/a | yes |
| policy_type | Policy type. `SERVICE_CONTROL_POLICY`: Service control policy. `TAG_POLICY`: Tag policy. | string | "SERVICE_CONTROL_POLICY" | no |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-manage-policy-config)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
