# terraform-tencentcloud-tco-organization-instance

Terraform module which creates a TencentCloud Organization instance (enables the Organization service) on TencentCloud.

The following resources are included.

* [Organization Instance](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_instance)

## Usage

```hcl
module "organization_instance" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-instance.git"

  org_name = "my-organization"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| org_name | Name of the organization root node. | string | null | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the resource. |
| create_time | The creation time of the organization. |
| host_uin | The UIN of the host/creator. |
| is_allow_quit | Whether a member is allowed to quit. |
| is_assign_manager | Whether there is a trusted service administrator. |
| is_auth_manager | Whether there is a real-named administrator. |
| is_manager | Whether there is an organizational administrator. |
| join_time | Members join time. |
| nick_name | Creator nickname. |
| org_id | The ID of the organization created. |
| org_permission | List of membership authority of members. |
| org_policy_name | The organization policy name. |
| org_policy_type | The organization policy type. |
| org_type | Enterprise organization type. |
| pay_name | The name of the payment. |
| pay_uin | UIN of the payer. |
| root_node_id | The organization root node ID. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-instance)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.