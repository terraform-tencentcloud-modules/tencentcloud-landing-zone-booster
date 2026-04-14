# cam-policy

Creates CAM policy.

## Examples:

- [cam-policy](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-cam/tree/main/examples/cam-policy
) - A complete example of CAM policy


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.18.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.18.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_cam_policy](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_policy) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Whether to create the CAM policy | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the CAM policy. | `string` | `"CAM Policy"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of CAM policy. | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | Document of the CAM policy. The syntax refers to CAM POLICY.  | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The policy's ID |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >1.18.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | 1.81.57 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_cam_policy.this](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Whether to create the CAM policy | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the CAM policy. | `string` | `"CAM Policy"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of CAM policy. | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | Document of the CAM policy. The syntax refers to CAM POLICY. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The policy's ID |
<!-- END_TF_DOCS -->