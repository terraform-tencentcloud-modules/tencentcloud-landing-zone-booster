<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >1.18.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | 1.81.57 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_password.pwds](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tencentcloud_cam_group.groups](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_group) | resource |
| [tencentcloud_cam_group_membership.foo](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_group_membership) | resource |
| [tencentcloud_cam_group_policy_attachment.foo](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_group_policy_attachment) | resource |
| [tencentcloud_cam_policy.policies](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_policy) | resource |
| [tencentcloud_cam_user.users](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_user) | resource |
| [tencentcloud_cam_policies.all](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/data-sources/cam_policies) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_document"></a> [document](#input\_document) | Document of the CAM policy. The syntax refers to CAM POLICY. There are some notes when using this para in terraform: 1. The elements in JSON claimed supporting two types as string and array only support type array; 2. Terraform does not support the root syntax, when it appears, it must be replaced with the uin it stands for. | `string` | `""` | no |
| <a name="input_email"></a> [email](#input\_email) | Email of the CAM user. | `string` | `""` | no |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | Name of CAM group. | `string` | `""` | no |
| <a name="input_group_remark"></a> [group\_remark](#input\_group\_remark) | Description of the CAM group. | `string` | `""` | no |
| <a name="input_groups"></a> [groups](#input\_groups) | Map of groups to create. Name is the map key.see `tencentcloud_cam_group` | `any` | `{}` | no |
| <a name="input_need_reset_password"></a> [need\_reset\_password](#input\_need\_reset\_password) | Indicate whether the CAM user need to reset the password when first logins. | `bool` | `false` | no |
| <a name="input_password"></a> [password](#input\_password) | The password of the CAM user. Password should be at least 8 characters and no more than 32 characters, includes uppercase letters, lowercase letters, numbers and special characters. Only required when console\_login is true. If not set, a random password will be automatically generated. | `string` | `""` | no |
| <a name="input_phone_num"></a> [phone\_num](#input\_phone\_num) | Phone number of the CAM user. | `string` | `""` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | Map of policies to create. Name is the map key.see `tencentcloud_cam_policy` | `any` | `{}` | no |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | Description of the CAM policy. | `string` | `""` | no |
| <a name="input_policy_id"></a> [policy\_id](#input\_policy\_id) | ID of the policy. | `string` | `""` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name of CAM policy. | `string` | `""` | no |
| <a name="input_policy_names"></a> [policy\_names](#input\_policy\_names) | name of the policies | `list(string)` | `[]` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | Name. | `string` | `""` | no |
| <a name="input_user_names"></a> [user\_names](#input\_user\_names) | User name set as ID of the CAM group members. | `list(string)` | `[]` | no |
| <a name="input_user_remark"></a> [user\_remark](#input\_user\_remark) | Remark of the CAM user. | `string` | `""` | no |
| <a name="input_user_tags"></a> [user\_tags](#input\_user\_tags) | A list of tags used to associate different resources. | `map(string)` | <pre>{<br>  "created": "terraform-test"<br>}</pre> | no |
| <a name="input_users"></a> [users](#input\_users) | Map of users to create. Name is the map key.see `tencentcloud_cam_user` | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_ids"></a> [group\_ids](#output\_group\_ids) | group ids |
| <a name="output_policy_ids"></a> [policy\_ids](#output\_policy\_ids) | policy ids |
| <a name="output_user_ids"></a> [user\_ids](#output\_user\_ids) | user ids |
| <a name="output_user_passwords"></a> [user\_passwords](#output\_user\_passwords) | user passwords |
<!-- END_TF_DOCS -->