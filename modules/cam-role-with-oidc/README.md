# cam-role-with-oidc

Create role OIDC configuration and create cam role for identity provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_oidc | Whether to create a oidc sso. | bool | true | no |
| create_role | Whether to create a role. | bool | true | no |
| create_policy | Whether to create a policy. | bool | false | yes |
| client_ids | Client ids. | set(string) | [""] | yes |
| identity_key | Sign the public key. | string | "" | yes |
| identity_url | Identity provider URL. | string | "" | yes |
| oidc_name | The name of cam oidc sso. | string | "" | yes |
| oidc_description | The description of cam oidc sso. | string | "" | no |
| role_document | Document of the CAM role. The syntax refers to CAM POLICY. There are some notes when using this para in terraform: 1. The elements in json claimed supporting two types as string and array only support type array; 2. Terraform does not support the root syntax, when appears, it must be replaced with the uin it stands for. | string | "" | yes |
| role_name | Name of CAM role. | string | "" | yes |
| console_login | Indicates whether the CAM role can login or not. | bool | false | no |
| role_description | Description of the CAM role. | string | "" | no |
| role_tags | A list of tags used to associate different resources. | map(string) | {} | no |
| policy_name | Name of CAM policy. | string | "" | yes |
| policy_document | Document of the CAM policy. The syntax refers to CAM POLICY. There are some notes when using this para in terraform: 1. The elements in JSON claimed supporting two types as string and array only support type array; 2. Terraform does not support the root syntax, when it appears, it must be replaced with the uin it stands for. | string | "" | yes |
| policy_description | Description of the CAM policy. | string | "" | no |
| policy_id | ID of the policy. | string | "" | no |


## Outputs

| Name | Description |
|------|-------------|
| oidc_sso_id | The ID of CAM-ROLE-OIDC. |
| role_id | The ID of cam role. |
| policy_id | The ID of cam policy. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >=1.18.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | 1.81.57 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_cam_policy.policy](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_policy) | resource |
| [tencentcloud_cam_role.role](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_role) | resource |
| [tencentcloud_cam_role_policy_attachment.role_policy_attach](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_role_policy_attachment) | resource |
| [tencentcloud_cam_role_sso.oidc_sso](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_role_sso) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_ids"></a> [client\_ids](#input\_client\_ids) | Client ids. | `set(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_console_login"></a> [console\_login](#input\_console\_login) | Indicates whether the CAM role can login or not. | `bool` | `false` | no |
| <a name="input_create_oidc"></a> [create\_oidc](#input\_create\_oidc) | Whether to create a oidc sso. | `bool` | `true` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Whether to create a policy. | `bool` | `false` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether to create a role. | `bool` | `true` | no |
| <a name="input_identity_key"></a> [identity\_key](#input\_identity\_key) | Sign the public key. | `string` | `""` | no |
| <a name="input_identity_url"></a> [identity\_url](#input\_identity\_url) | Identity provider URL. | `string` | `""` | no |
| <a name="input_oidc_description"></a> [oidc\_description](#input\_oidc\_description) | The description of cam oidc sso. | `string` | `""` | no |
| <a name="input_oidc_name"></a> [oidc\_name](#input\_oidc\_name) | The name of cam oidc sso. | `string` | `""` | no |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | Description of the CAM policy. | `string` | `""` | no |
| <a name="input_policy_document"></a> [policy\_document](#input\_policy\_document) | Document of the CAM policy. The syntax refers to CAM POLICY. There are some notes when using this para in terraform: <br>  1. The elements in JSON claimed supporting two types as string and array only support type array; <br>  2. Terraform does not support the root syntax, when it appears, it must be replaced with the uin it stands for. | `string` | `""` | no |
| <a name="input_policy_id"></a> [policy\_id](#input\_policy\_id) | ID of the policy. | `string` | `""` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name of CAM policy. | `string` | `""` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description of the CAM role. | `string` | `""` | no |
| <a name="input_role_document"></a> [role\_document](#input\_role\_document) | Document of the CAM role. The syntax refers to CAM POLICY. There are some notes when using this para in terraform: <br>  1. The elements in json claimed supporting two types as string and array only support type array; <br>  2. Terraform does not support the root syntax, when appears, it must be replaced with the uin it stands for. | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of CAM role. | `string` | `""` | no |
| <a name="input_role_tags"></a> [role\_tags](#input\_role\_tags) | A list of tags used to associate different resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_sso_id"></a> [oidc\_sso\_id](#output\_oidc\_sso\_id) | The ID of CAM-ROLE-OIDC. |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | The ID of cam policy. |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The ID of cam role. |
<!-- END_TF_DOCS -->