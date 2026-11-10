# terraform-tencentcloud-vpn-gateway

Terraform module which creates a **VPN Gateway** on TencentCloud.

The following resources are included.

* [VPN Gateway](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_gateway)

The VPN gateway is created only when `create_vpn_gateway` is `true`. The target VPC can be identified either by `vpc_id` directly, or by looking up its ID from `vpc_instance_name` using the `tencentcloud_vpc_instances` data source.

## Usage

```hcl
module "vpn_gateway" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-gateway.git"

  create_vpn_gateway = true
  vpn_gateway_name   = "example-vpngw"
  bandwidth          = 100
  type               = "IPSEC"
  zone               = "ap-guangzhou-3"
  vpc_instance_name  = "Default-VPC"
  charge_type        = "POSTPAID_BY_HOUR"

  vpn_tags = {
    "createdBy" = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vpn_gateway | Controls if the VPN gateway should be created. | bool | `true` | no |
| vpn_gateway_name | Name of the VPN gateway (1-60 chars). | string | n/a | yes |
| bandwidth | Max public network output bandwidth (Mbps). Valid values: 5,10,20,50,100,200,500,1000. | number | n/a | yes |
| type | Type of gateway instance. Valid values: `IPSEC`, `SSL`, `CCN`, `SSL_CCN`. | string | `IPSEC` | no |
| vpc_id | ID of the VPC. Required if the gateway is not CCN/SSL_CCN type. | string | `"null"` | no |
| vpc_instance_name | Name of the VPC (looked up to resolve `vpc_id`). | string | `"null"` | no |
| zone | Zone of the VPN gateway. | string | `""` | no |
| charge_type | Charge type. Valid values: `PREPAID`, `POSTPAID_BY_HOUR`. | string | `POSTPAID_BY_HOUR` | no |
| prepaid_period | Prepaid period in months. Valid values: 1,2,3,4,6,7,8,9,12,24,36. Only for IPSEC & PREPAID. | number | n/a | no |
| prepaid_renew_flag | Prepaid renew flag. Valid values: `NOTIFY_AND_AUTO_RENEW`, `NOTIFY_AND_MANUAL_RENEW`. | string | n/a | no |
| max_connection | Max number of connected clients for SSL VPN gateway. Valid values: [5,10,20,50,100]. | number | n/a | no |
| vpn_tags | Tags of the VPN gateway. | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpn_instance_id | The ID of the VPN gateway (null when `create_vpn_gateway` is false). |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-gateway)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
