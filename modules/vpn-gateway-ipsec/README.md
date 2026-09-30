# terraform-tencentcloud-vpn-gateway-ipsec

Terraform module which creates an **IPSec VPN tunnel** on TencentCloud, including the customer gateway, the VPN connection (with IKE/IPsec, DPD and health-check settings) and a VPN gateway route pointing to the connection.

The following resources are included.

* [VPN Customer Gateway](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_customer_gateway)
* [VPN Connection](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_connection)
* [VPN Gateway Route](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_gateway_route)

## Usage

```hcl
module "vpn_gateway_ipsec" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-gateway-ipsec.git"

  vpc_id            = "vpc-xxxxxxxx"
  vpn_gateway_id    = "vpngw-xxxxxxxx"
  customer_gateway_name      = "my-cgw"
  customer_gateway_address   = "203.0.113.10"
  connection_name            = "my-ipsec-conn"
  pre_share_key              = var.vpn_psk

  ike_proto_encry_algorithm  = "AES-CBC-128"
  ipsec_encrypt_algorithm    = "AES-CBC-128"
  destination_cidr_block     = "192.168.0.0/24"

  spd_policy = [
    {
      local_cidr_block  = "10.0.0.0/16"
      remote_cidr_blocks = "172.16.0.0/16"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| customer_gateway_name | Name of the customer gateway (1-60 chars). | string | n/a | yes |
| customer_gateway_address | Public IP of the customer gateway. | string | n/a | yes |
| customer_gateway_tags | Tags of the customer gateway. | map(string) | `{}` | no |
| connection_name | Name of the VPN connection (1-60 chars). | string | n/a | yes |
| vpc_id | ID of the VPC. | string | n/a | yes |
| vpn_gateway_id | ID of the VPN gateway. | string | n/a | yes |
| pre_share_key | Pre-shared key of the VPN connection. | string | `test` | no |
| ike_version | IKE version. Valid: `IKEV1`, `IKEV2`. | string | `IKEV1` | no |
| ike_proto_encry_algorithm | IKE encryption algorithm. | string | `3DES-CBC` | no |
| ike_proto_authen_algorithm | IKE authentication algorithm. Valid: `MD5`, `SHA`, `SHA-256`. | string | `SHA` | no |
| ike_local_identity | IKE local identity. Valid: `ADDRESS`, `FQDN`. | string | `ADDRESS` | no |
| ike_exchange_mode | IKE exchange mode. Valid: `AGGRESSIVE`, `MAIN`. | string | `AGGRESSIVE` | no |
| ike_local_address | IKE local address (when identity is ADDRESS). | string | n/a | no |
| ike_remote_identity | IKE remote identity. Valid: `ADDRESS`, `FQDN`. | string | `ADDRESS` | no |
| ike_remote_address | IKE remote address (when identity is ADDRESS). | string | null | no |
| ike_dh_group_name | IKE DH group. Valid: `GROUP1`, `GROUP2`, `GROUP5`, `GROUP14`, `GROUP24`. | string | `GROUP2` | no |
| ike_sa_lifetime_seconds | IKE SA lifetime in seconds (60-604800). | number | `86400` | no |
| ipsec_encrypt_algorithm | IPsec encryption algorithm. | string | `3DES-CBC` | no |
| ipsec_integrity_algorithm | IPsec integrity algorithm. Valid: `SHA1`, `MD5`, `SHA-256`. | string | `MD5` | no |
| ipsec_sa_lifetime_seconds | IPsec SA lifetime in seconds (180-604800). | number | `3600` | no |
| ipsec_sa_lifetime_traffic | IPsec SA lifetime traffic in KB (>= 2560). | number | `2560` | no |
| ipsec_pfs_dh_group | IPsec PFS DH group. Valid: `GROUP1/2/5/14/24`, `NULL`. | string | null | no |
| dpd_action | DPD timeout action. Valid: `clear`, `restart`. | string | `restart` | no |
| dpd_enable | Enable DPD. Valid: 0 (disable), 1 (enable). | number | `1` | no |
| dpd_timeout | DPD timeout in seconds (30-60). | number | `30` | no |
| enable_health_check | Whether intra-tunnel health checks are supported. | bool | `false` | no |
| health_check_local_ip | Health check local address. | string | null | no |
| health_check_remote_ip | Health check peer address. | string | null | no |
| spd_policy | Security group policy of the VPN connection (list of maps with `local_cidr_block` and `remote_cidr_blocks`). | list(map(string)) | `[]` | no |
| vpn_connection_tags | Tags of the VPN connection. | map(string) | `{}` | no |
| destination_cidr_block | Destination IDC IP range for the gateway route. | string | `192.168.0.0/24` | no |
| route_priority | Route priority. Valid: 0 and 100. | number | `100` | no |
| route_status | Route status. Valid: `ENABLE`, `DISABLE`. | string | `ENABLE` | no |
| instance_type | Next hop type. Valid: `VPNCONN` (VPN tunnel), `CCN` (CCN instance). | string | `VPNCONN` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpn_customer_gateway_id | The ID of the VPN customer gateway. |
| vpn_connection_id | The ID of the VPN connection. |
| vpn_gateway_route | The ID of the VPN gateway route. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-gateway-ipsec)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
