# terraform-tencentcloud-vpn-connection-reset

Example / skeleton module that demonstrates how to build a **VPN connection** stack on TencentCloud using the `tencentcloud` provider.

> **Note:** This is an example module. The resources in `main.tf` use hard-coded values (e.g. public IP `3.3.3.3`, VPC name `Default-VPC`, pre-shared key `test`). Parameterize them via `variables.tf` before using in production.

The example `main.tf` demonstrates the following resources and data sources:

* [VPN Customer Gateway](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_customer_gateway)
* [VPN Gateway](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_gateway)
* [VPN Connection](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_connection)
* [VPN Gateway Route](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_gateway_route)
* Data sources: `tencentcloud_vpc_instances`, `tencentcloud_vpn_customer_gateways`, `tencentcloud_vpn_gateways`, `tencentcloud_vpn_connections`, `tencentcloud_vpn_gateway_routes`

It also shows how to create a CCN-type VPN gateway (`type = "CCN"`) that can be used to build a VPN tunnel in the usual way.

## Usage

```hcl
module "vpn_connection_reset" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-connection-reset.git"

  availability_zone = "ap-guangzhou-3"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability_zone | Availability zone of the VPN gateway. | string | `ap-guangzhou-3` | no |

> Other parameters (VPC name, gateway/customer-gateway names, public IP, pre-shared key, IKE/IPsec settings, route entries) are currently hard-coded in `main.tf`.

## Outputs

No outputs (`output.tf` is empty).

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-connection-reset)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | (provider required; pin a version in `version.tf`) |
