# terraform-tencentcloud-ccn-attachment
Terraform module which attaches network instances to a CCN on TencentCloud.

This module uses the `tencentcloud_ccn_attachment_v2` resource to **attach** a network instance (VPC, DIRECTCONNECT, BMVPC, VPNGW) to a specified CCN instance and outputs the resulting CCN route IDs.

## Usage

```hcl
module "ccn_attachment" {
  source = "terraform-tencentcloud-modules/ccn-attachment/tencentcloud"

  ccn_id          = "ccn-xxxxxxxx"   # ID of the target CCN instance
  instance_id     = "vpc-abc123"     # ID of the network instance to attach
  instance_type   = "VPC"            # VPC, DIRECTCONNECT, BMVPC or VPNGW
  instance_region = "ap-guangzhou"   # Region where the instance is located
  description     = "attach vpc to ccn"

  # Optional: required only when attaching a CCN owned by another account
  # ccn_uin = "100000000001"
}
```

## Examples

- [Complete](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-ccn-attachment/tree/master/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.136 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.136 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_ccn_attachment_v2.attachment](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_attachment_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ccn_id"></a> [ccn\_id](#input\_ccn\_id) | The ID of the CCN instance to which the network instance will be attached. | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the attached network instance. Valid values: `VPC`, `DIRECTCONNECT`, `BMVPC`, `VPNGW`. | `string` | `"VPC"` | no |
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | ID of the network instance which will be attached. | `string` | `""` | no |
| <a name="input_instance_region"></a> [instance\_region](#input\_instance\_region) | The region where the attached network instance is located. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the attachment, maximum length does not exceed 100 bytes. | `string` | `""` | no |
| <a name="input_ccn_uin"></a> [ccn\_uin](#input\_ccn\_uin) | UIN of the CCN being attached. If not set, the UIN of the current account is used. Required when attaching a CCN owned by another account (currently only `VPC` instance type is supported). | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ccn_route_ids"></a> [ccn\_route\_ids](#output\_ccn\_route\_ids) | The route IDs from CCN attachment (e.g. `ccnr-xxxxxxxx` format). |
<!-- END_TF_DOCS -->

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
