# terraform-tencentcloud-ccn
Terraform module which creates CCN resources on TencentCloud

## Usage

```hcl
module "ccn" {
  source  = "terraform-tencentcloud-modules/ccn/tencentcloud"
  version = "0.3.0"


  ccn_name             = "ccn_test"
  bandwidth_limit_type = "INTER_REGION_LIMIT"
  charge_type          = "POSTPAID"
  ccn_description      = "create for test"
  ccn_tags = {
    createdBy = "terraform"
  }

  attach_ccn = false
}
```

## Examples

- [Simple CCN](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-ccn/tree/master/examples/simple-ccn)
- [Exist CCN](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-ccn/tree/master/examples/exist-ccn)
- [Complete](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-ccn/tree/master/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >=1.81.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >=1.81.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_ccn.ccn](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn) | resource |
| [tencentcloud_ccn_attachment.attachment](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_attachment) | resource |
| [tencentcloud_ccn_bandwidth_limit.limit](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_bandwidth_limit) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_ccn"></a> [attach\_ccn](#input\_attach\_ccn) | Controls if attach CCN instance to other network instances. | `bool` | `true` | no |
| <a name="input_attachment_description"></a> [attachment\_description](#input\_attachment\_description) | Description of the CCN to be created, and maximum length does not exceed 100 bytes. | `string` | `""` | no |
| <a name="input_bandwidth_limit"></a> [bandwidth\_limit](#input\_bandwidth\_limit) | Limitation of bandwidth. | `number` | `"0"` | no |
| <a name="input_bandwidth_limit_type"></a> [bandwidth\_limit\_type](#input\_bandwidth\_limit\_type) | The speed limit type of CCN. Valid values: `INTER_REGION_LIMIT`, `OUTER_REGION_LIMIT`. | `string` | `"OUTER_REGION_LIMIT"` | no |
| <a name="input_ccn_description"></a> [ccn\_description](#input\_ccn\_description) | Description of the CCN to be created, and maximum length does not exceed 100 bytes. | `string` | `""` | no |
| <a name="input_ccn_id"></a> [ccn\_id](#input\_ccn\_id) | The ID of ccn which to attach. | `string` | `""` | no |
| <a name="input_ccn_name"></a> [ccn\_name](#input\_ccn\_name) | Name of the CCN to be created, and maximum length does not exceed 60 bytes. | `string` | `"ccn-example"` | no |
| <a name="input_ccn_tags"></a> [ccn\_tags](#input\_ccn\_tags) | Tags of the CCN to be created. | `map(string)` | `{}` | no |
| <a name="input_ccn_uin"></a> [ccn\_uin](#input\_ccn\_uin) | Uin of the ccn attached. If not set, which means the uin of this account. This parameter is used with case when attaching ccn of other account to the instance of this account. | `string` | `""` | no |
| <a name="input_charge_type"></a> [charge\_type](#input\_charge\_type) | Billing mode of CCN. Valid values: `PREPAID`, `POSTPAID`. | `string` | `"POSTPAID"` | no |
| <a name="input_create_ccn"></a> [create\_ccn](#input\_create\_ccn) | Controls if CCN should be created (it affects almost all resources) | `bool` | `true` | no |
| <a name="input_dst_region"></a> [dst\_region](#input\_dst\_region) | Destination area restriction. If the `CCN` rate limit type is `OUTER_REGION_LIMIT`, this value does not need to be set. | `string` | `"ap-chengdu"` | no |
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | ID of instance which will be attached. | `string` | `""` | no |
| <a name="input_instance_region"></a> [instance\_region](#input\_instance\_region) | The region which the attached instance locates at. | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of attached instance network, and available values include VPC, DIRECTCONNECT, BMVPC and VPNGW. | `string` | `"VPC"` | no |
| <a name="input_qos"></a> [qos](#input\_qos) | Service quality of CCN. Valid values: `PT`, `AU`, `AG`. The default is `AU`. | `string` | `"AU"` | no |
| <a name="input_set_bandwith_limit"></a> [set\_bandwith\_limit](#input\_set\_bandwith\_limit) | Control if set ccn bandwidth limit. | `bool` | `false` | no |
| <a name="input_src_region"></a> [src\_region](#input\_src\_region) | Limitation of region. | `string` | `"ap-guangzhou"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ccn_id"></a> [ccn\_id](#output\_ccn\_id) | The Id of CCN. |
<!-- END_TF_DOCS -->

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
