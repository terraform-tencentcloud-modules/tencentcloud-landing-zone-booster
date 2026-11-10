# terraform-tencentcloud-vpn-gateway-ccn

Terraform module which provisions a full **VPN Gateway + CCN + VPN Connection** stack on TencentCloud.

The following resources are included.

* [VPN Gateway](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_gateway)
* [CCN](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn)
* [CCN Attachment V2](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_attachment_v2)
* [VPN Customer Gateway](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_customer_gateway)
* [VPN Connection](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpn_connection)

This module can create:

* A VPN gateway (always, controlled by `create_vpn_gateway`).
* A CCN instance (`create_ccn = true`) and/or attach the VPN gateway to an existing CCN (`attach_ccn = true`).
* A customer gateway and a VPN connection with full IKE/IPsec, BGP, DPD and health-check support.

> All resources are optional/conditional via their respective `create_*` / `attach_*` switches, so you can use this module for a standalone VPN gateway or a complete CCN-connected VPN.

## Usage

```hcl
module "vpn_gateway_ccn" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-gateway-ccn.git"

  # VPN gateway
  create_vpn_gateway = true
  vpn_gateway_name   = "example-vpngw"
  bandwidth          = 100
  type               = "CCN"
  zone               = "ap-guangzhou-3"
  vpn_tags           = { "createdBy" = "Terraform" }

  # CCN (created or reused)
  create_ccn = true
  ccn_name   = "example-ccn"

  attach_ccn = true
  instance_region = "ap-guangzhou"

  # Customer gateway + VPN connection
  customer_gateway_name              = "example-cgw"
  customer_gateway_public_ip_address = "203.0.113.10"

  vpn_connection_name           = "example-conn"
  vpn_connection_pre_share_key  = var.vpn_psk
  vpn_connection_route_type     = "StaticRoute"
  vpn_connection_security_group_policy = [
    {
      local_cidr_block  = "10.0.0.0/16"
      remote_cidr_block = ["172.16.0.0/16"]
    }
  ]
  vpn_connection_tags = { "createdBy" = "Terraform" }
}
```

## Inputs

### VPN Gateway

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vpn_gateway | Controls if the VPN gateway should be created. | bool | `true` | no |
| vpn_gateway_name | Name of the VPN gateway (1-60 chars). | string | n/a | yes |
| bandwidth | Max public network output bandwidth (Mbps). Valid: 5,10,20,50,100,200,500,1000. | number | `5` | no |
| type | Gateway instance type. Valid: `IPSEC`, `SSL`, `CCN`, `SSL_CCN`. | string | `IPSEC` | no |
| vpc_id | ID of the VPC. Required if the gateway is not CCN/SSL_CCN type. | string | null | no |
| zone | Zone of the VPN gateway. | string | `ap-guangzhou-3` | no |
| charge_type | Charge type. Valid: `PREPAID`, `POSTPAID_BY_HOUR`. | string | `POSTPAID_BY_HOUR` | no |
| prepaid_period | Prepaid period (months). Valid: 1,2,3,4,6,7,8,9,12,24,36. | number | null | no |
| prepaid_renew_flag | Renew flag. Valid: `NOTIFY_AND_AUTO_RENEW`, `NOTIFY_AND_MANUAL_RENEW`. | string | null | no |
| max_connection | Max SSL VPN clients. Valid: [5,10,20,50,100]. | number | null | no |
| vpn_tags | Tags of the VPN gateway. | map(string) | `{}` | no |
| bgp_asn | BGP ASN (1 - 4294967295). | number | null | no |
| cdc_id | CDC instance ID. | string | null | no |

### CCN

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_ccn | Controls if a CCN should be created. | bool | `false` | no |
| ccn_name | Name of the CCN. | string | null | no |
| bandwidth_limit_type | Bandwidth limit type. Valid: `INTER_REGION_LIMIT`, `OUTER_REGION_LIMIT`. | string | `INTER_REGION_LIMIT` | no |
| ccn_charge_type | Charge type of CCN. Valid: `PREPAID`, `POSTPAID_BY_HOUR`. | string | `POSTPAID_BY_HOUR` | no |
| ccn_description | Description of the CCN. | string | null | no |
| qos | QoS of CCN. Valid: `PT`, `AU`, `AG`. | string | `AU` | no |
| route_ecmp_flag | Enable equivalent routing. | bool | `false` | no |
| route_overlap_flag | Enable routing overlap (default true, cannot be false). | bool | `true` | no |
| ccn_tags | Tags of the CCN. | map(string) | `{}` | no |

### CCN Attachment

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attach_ccn | Controls if the CCN should be attached to the VPN gateway. | bool | `false` | no |
| ccn_id | ID of the CCN. | string | null | no |
| instance_id | ID of the attached instance. | string | null | no |
| instance_type | Attached instance type. Valid: `VPC`, `DIRECTCONNECT`, `BMVPC`, `VPNGW`. | string | null | no |
| instance_region | Region of the instance. | string | null | no |
| ccn_uin | Uin of the CCN attached (cross-account). | string | null | no |
| route_table_id | ID of the route table. | string | null | no |
| attachment_description | Remark of the attachment. | string | null | no |

### Customer Gateway

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| customer_gateway_name | Name of the customer gateway (1-60 chars). | string | n/a | yes |
| customer_gateway_public_ip_address | Public IP of the customer gateway. | string | n/a | yes |
| customer_gateway_bgp_asn | BGP ASN (1 - 4294967295). 139341, 45090, 58835 unavailable. | number | null | no |
| customer_gateway_tags | Tags of the customer gateway. | map(string) | `{}` | no |

### VPN Connection

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpn_connection_customer_gateway_id | ID of the customer gateway (overrides the created one if set). | string | `""` | no |
| vpn_connection_name | Name of the VPN connection (1-60 chars). | string | n/a | yes |
| vpn_connection_pre_share_key | Pre-shared key of the VPN connection. | string | `""` | no |
| vpn_connection_route_type | Route type. Valid: `STATIC`, `StaticRoute`, `Policy`, `Bgp`. | string | null | no |
| vpn_connection_bgp_config | BGP config (list of `local_bgp_ip`, `remote_bgp_ip`, `tunnel_cidr`). Used when route type is `Bgp`. | list(object) | null | no |
| vpn_connection_negotiation_type | Negotiation type. Valid: `active`, `passive`, `flowTrigger`. | string | null | no |
| vpn_connection_dpd_enable | Enable DPD. Valid: 0 (disable), 1 (enable). | number | null | no |
| vpn_connection_dpd_action | DPD timeout action. Valid: `clear`, `restart`. | string | null | no |
| vpn_connection_dpd_timeout | DPD timeout in seconds (30-60). | number | null | no |
| vpn_connection_enable_health_check | Whether intra-tunnel health checks are supported. | bool | `false` | no |
| vpn_connection_health_check_config | Health check config object (`probe_interval`, `probe_threshold`, `probe_timeout`, `probe_type`). | object | null | no |
| vpn_connection_health_check_local_ip | Health check local address. | string | null | no |
| vpn_connection_health_check_remote_ip | Health check peer address. | string | null | no |
| vpn_connection_ike_version | IKE version. Valid: `IKEV1`, `IKEV2`. | string | null | no |
| vpn_connection_ike_exchange_mode | IKE exchange mode. Valid: `AGGRESSIVE`, `MAIN`. | string | null | no |
| vpn_connection_ike_local_identity | IKE local identity. Valid: `ADDRESS`, `FQDN`. | string | null | no |
| vpn_connection_ike_remote_identity | IKE remote identity. Valid: `ADDRESS`, `FQDN`. | string | null | no |
| vpn_connection_ike_local_fqdn_name | IKE local FQDN name. | string | null | no |
| vpn_connection_ike_remote_fqdn_name | IKE remote FQDN name. | string | null | no |
| vpn_connection_ike_remote_address | IKE remote address (when identity is ADDRESS). | string | null | no |
| vpn_connection_ike_dh_group_name | IKE DH group. Valid: `GROUP1`, `GROUP2`, `GROUP5`, `GROUP14`, `GROUP24`. | string | null | no |
| vpn_connection_ike_sa_lifetime_seconds | IKE SA lifetime in seconds (60-604800). | number | null | no |
| vpn_connection_ike_proto_encry_algorithm | IKE encryption algorithm. | string | null | no |
| vpn_connection_ike_proto_authen_algorithm | IKE authentication algorithm. Valid: `MD5`, `SHA`, `SHA-256`. | string | null | no |
| vpn_connection_ipsec_encrypt_algorithm | IPsec encryption algorithm. | string | null | no |
| vpn_connection_ipsec_integrity_algorithm | IPsec integrity algorithm. Valid: `SHA1`, `MD5`, `SHA-256`. | string | null | no |
| vpn_connection_ipsec_pfs_dh_group | IPsec PFS DH group. Valid: `DH-GROUP1/2/5/14/24`, `NULL`. | string | null | no |
| vpn_connection_ipsec_sa_lifetime_seconds | IPsec SA lifetime in seconds (180-604800). | number | null | no |
| vpn_connection_ipsec_sa_lifetime_traffic | IPsec SA lifetime traffic in KB (>= 2560). | number | null | no |
| vpn_connection_security_group_policy | SPD policy group (set of `local_cidr_block` and `remote_cidr_block` set). | set(object) | null | no |
| vpn_connection_vpc_id | VPC ID of the VPN connection (not for CCN type). | string | null | no |
| vpn_connection_tags | Tags of the VPN connection. | map(string) | `{}` | no |

## Outputs

Outputs are defined in `outputs.tf` (e.g. VPN gateway ID, CCN ID, attachment ID, customer gateway ID and VPN connection ID). Please refer to that file for the exact list.

## Examples

See the [`examples/`](./examples) directory:

* `basic-vpn-gateway` — create a standalone VPN gateway.
* `vpn-gateway-with-existing-ccn` — attach to an existing CCN.
* `vpn-gateway-with-new-ccn` — create a new CCN then attach.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpn-gateway-ccn)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
