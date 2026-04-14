# TencentCloud VPN Gateway v2 Module

This module is used to create Tencent Cloud VPN Gateway v2 version with more features and parameters.

## Features

- Support all VPN gateway types: IPSEC, SSL, CCN, SSL_CCN
- Support BGP ASN configuration
- Support CDC instance ID
- Export complete VPN gateway attributes
- Support prepaid and postpaid billing modes

## Usage Example

```hcl
module "vpn_gateway_v2" {
  source = "./modules/tencentcloud-vpn-gateway-v2"
  
  vpn_gateway_name = "my-vpn-gateway-v2"
  bandwidth        = 100
  type             = "CCN"
  zone             = "ap-guangzhou-3"
  
  # v2 new parameters
  bgp_asn          = 65000
  cdc_id           = "cdc-xxxxxx"
  
  vpn_tags = {
    Environment = "production"
    Project     = "vpn-project"
  }
}
```

## Input Parameters

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| create_vpn_gateway | Whether to create VPN gateway | bool | No | true |
| vpn_gateway_name | VPN gateway name (1-60 characters) | string | Yes | - |
| bandwidth | Public network bandwidth (Mbps) | number | Yes | - |
| type | Gateway type | string | No | IPSEC |
| zone | Availability zone | string | No | ap-guangzhou-3 |
| vpc_id | VPC ID | string | No | null |
| vpc_instance_name | VPC instance name | string | No | null |
| charge_type | Billing type | string | No | POSTPAID_BY_HOUR |
| prepaid_period | Prepaid period | number | No | null |
| prepaid_renew_flag | Renewal flag | string | No | null |
| max_connection | SSL VPN max connections | number | No | null |
| vpn_tags | Tags | map(string) | No | {} |
| bgp_asn | BGP ASN | number | No | null |
| cdc_id | CDC instance ID | string | No | null |

## Output Parameters

| Name | Description |
|------|-------------|
| vpn_instance_id | VPN gateway ID |
| create_time | Creation time |
| expired_time | Expiration time |
| is_address_blocked | Whether IP is blocked |
| new_purchase_plan | New purchase plan |
| public_ip_address | Public IP address |
| restrict_state | Restriction state |
| state | Gateway state |

## Notes

- CCN type VPN gateway does not require VPC ID
- SSL type VPN gateway requires max_connection parameter
- Prepaid mode requires prepaid_period and prepaid_renew_flag parameters
