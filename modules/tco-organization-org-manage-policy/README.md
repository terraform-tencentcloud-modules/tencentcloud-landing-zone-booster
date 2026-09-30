# terraform-tencentcloud-tco-organization-org-manage-policy

Terraform module which creates an Organization management policy and attaches it to target nodes (departments) and members on TencentCloud.

The following resources are included.

* [Organization Org Manage Policy](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_manage_policy)
* [Organization Org Manage Policy Target](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_manage_policy_target)

## Usage

```hcl
module "organization_org_manage_policy" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-manage-policy.git"

  policy_name  = "FullAccessPolicy"
  content      = "{\"version\":\"2.0\",\"statement\":[{\"effect\":\"allow\",\"action\":\"*\",\"resource\":\"*\"}]}"
  type         = "SERVICE_CONTROL_POLICY"
  description  = "Full access policy"

  target_nodes = {
    node1 = { node_id = 1001 }
  }
  target_users = {
    user1 = { user_id = 1000001 }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Whether to create the policy and its targets. | bool | true | no |
| policy_name | Policy name. | string | "" | no |
| content | Policy content. Refer to the CAM policy syntax. | string | "" | no |
| type | Policy type. Default `SERVICE_CONTROL_POLICY`, other `TAG_POLICY`. | string | "SERVICE_CONTROL_POLICY" | no |
| description | Description of the policy. | string | "" | no |
| target_nodes | A map of target nodes to attach the policy. Each item contains `node_id` (number). | map(object({ node_id = number })) | {} | no |
| target_users | A map of target users/members to attach the policy. Each item contains `user_id` (number). | map(object({ user_id = number })) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| policy_name | The name of the created policy. |
| policy_id | The ID of the created policy. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-manage-policy)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
