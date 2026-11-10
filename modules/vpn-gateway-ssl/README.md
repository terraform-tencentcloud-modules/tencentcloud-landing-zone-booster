# terraform-tencentcloud-vpn-gateway-ssl

Terraform module which creates an **SSL VPN server** and an **SSL VPN client** on TencentCloud.

The following resources are included.

* [VPN SSL Server](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_ssl_server)
* [VPN SSL Client](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_ssl_client)

This module provisions an SSL VPN server bound to an existing VPN gateway, then creates an SSL VPN client attached to that server.

## Usage

```hcl
module "vpn_gateway_ssl" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-gateway-ssl.git"

  vpn_gateway_id       = "vpngw-xxxxxxxx"
  ssl_vpn_server_name  = "example-ssl-server"
  ssl_vpn_client_name  = "example-ssl-client"
  local_address        = ["10.0.0.0/16"]
  remote_address       = "172.16.0.0/16"
  ssl_vpn_protocol     = "UDP"
  ssl_vpn_port         = "1194"
  encrypt_algorithm    = "AES-128-CBC"
  integrity_algorithm  = "SHA1"
  compress             = false
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpn_gateway_id | The ID of the VPN gateway. | string | n/a | yes |
| ssl_vpn_server_name | The name of the SSL VPN server to create. | string | n/a | yes |
| ssl_vpn_client_name | The name of the SSL VPN client to create. | string | n/a | yes |
| local_address | List of local CIDR blocks. | list(string) | n/a | yes |
| remote_address | Remote CIDR for the client. | string | n/a | yes |
| ssl_vpn_protocol | The protocol of the SSL VPN. | string | `UDP` | no |
| ssl_vpn_port | The port of the SSL VPN. | string | `1194` | no |
| integrity_algorithm | Integrity algorithm. Valid: `SHA1`, `MD5`, `NONE`. | string | `NONE` | no |
| encrypt_algorithm | Encrypt algorithm. Valid: `AES-128-CBC`, `AES-192-CBC`, `AES-256-CBC`, `NONE`. | string | `NONE` | no |
| compress | Whether to enable compression. | bool | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpn_ssl_server_id | The ID of the VPN SSL server. |
| vpn_ssl_client_id | The ID of the VPN SSL client. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-gateway-ssl)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
