# terraform-tencentcloud-vpn-connection

Terraform module which creates a **VPN Customer Gateway** and a **VPN Connection** (IPSec/IKE tunnel) on TencentCloud.

The following resources are included.

* [VPN Customer Gateway](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_customer_gateway)
* [VPN Connection](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_connection)

This module creates a customer gateway from a public IP, then builds a VPN connection bound to an existing VPN gateway (`vpn_gateway_id`) with configurable IKE and IPsec parameters and SPD (security group) policies.

## Usage

```hcl
module "vpn_connection" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-connection.git"

  vpn_gateway_id             = "vpngw-xxxxxxxx"
  vpc_id                     = "vpc-xxxxxxxx"
  customer_gateway_name      = "my-cgw"
  customer_gateway_public_ip = "203.0.113.10"
  vpn_connection_name        = "my-conn"

  pre_share_key    = var.vpn_psk            # sensitive
  remote_cidr_blocks = ["10.0.0.0/16"]
  local_cidr_blocks  = ["172.16.0.0/16"]

  ike_proto_encry_algorithm  = "AES-CBC-128"
  ike_proto_authen_algorithm = "SHA"
  ipsec_encrypt_algorithm    = "AES-CBC-128"
  ipsec_integrity_algorithm  = "SHA1"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | VPC ID for the VPN gateway. | string | n/a | yes |
| vpn_gateway_id | ID of the existing VPN gateway. | string | n/a | yes |
| customer_gateway_name | Name of the customer gateway. | string | `example` | no |
| customer_gateway_public_ip | Public IP address of the customer gateway. | string | n/a | yes |
| vpn_connection_name | Name of the VPN connection. | string | `example` | no |
| pre_share_key | Pre-shared key for the VPN connection. | string (sensitive) | n/a | yes |
| ike_local_identity | IKE local identity type. | string | `ADDRESS` | no |
| ike_proto_encry_algorithm | IKE protocol encryption algorithm. | string | `3DES-CBC` | no |
| ike_proto_authen_algorithm | IKE protocol authentication algorithm. | string | `MD5` | no |
| ike_exchange_mode | IKE exchange mode. | string | `MAIN` | no |
| ike_local_address | IKE local address. | string | `""` | no |
| ike_remote_identity | IKE remote identity type. | string | `ADDRESS` | no |
| ike_remote_address | IKE remote address. | string | n/a | yes |
| ike_dh_group_name | IKE DH group name. | string | `GROUP1` | no |
| ike_sa_lifetime_seconds | IKE SA lifetime in seconds. | number | `86400` | no |
| ipsec_encrypt_algorithm | IPSec encryption algorithm. | string | `3DES-CBC` | no |
| ipsec_integrity_algorithm | IPSec integrity algorithm. | string | `MD5` | no |
| ipsec_sa_lifetime_seconds | IPSec SA lifetime in seconds. | number | `3600` | no |
| ipsec_pfs_dh_group | IPSec PFS DH group. | string | `DH-GROUP1` | no |
| ipsec_sa_lifetime_traffic | IPSec SA lifetime traffic. | number | `2560` | no |
| local_cidr_blocks | Local CIDR blocks for the security group policy. | list(string) | `["172.16.0.0/16"]` | no |
| remote_cidr_blocks | Remote CIDR blocks for the security group policy. | list(string) | n/a | yes |
| availability_zone | Availability zone for the VPN gateway. | string | `""` | no |
| tags | Tags to apply to resources. | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpn_connection_id | The ID of the VPN connection. |
| customer_gateway_id | The ID of the customer gateway. |
| vpn_connection_state | The state of the VPN connection. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-connection)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
