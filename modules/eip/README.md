# terraform-tencentcloud-eip
Terraform module which creates an Elastic IP (EIP) resource on TencentCloud.

> **Note:** This module wraps `tencentcloud_eip`. The EIP type, charge type, ISP, auto-renew flag and prepaid period are validated against allowed values.

## Resources created

| Resource | Count | Notes |
|----------|-------|-------|
| `tencentcloud_eip.eip` | 1 | The Elastic IP address. |

## Usage

```hcl
module "eip" {
  source = "../../../../tc-modules/modules/eip"

  eip = {
    name                       = "boost-life-eip"
    type                       = "EIP"                       # EIP, AnycastEIP, HighQualityEIP, AntiDDoSEIP, ResidentialEIP
    internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR" # BANDWIDTH_PACKAGE, BANDWIDTH_POSTPAID_BY_HOUR, BANDWIDTH_PREPAID_BY_MONTH, TRAFFIC_POSTPAID_BY_HOUR
    internet_max_bandwidth_out = 5                           # in Mbps
    internet_service_provider  = "BGP"                      # BGP, CMCC, CTCC, CUCC
    auto_renew_flag            = 0                           # 0 manual, 1 automatic, 2 explicit no auto renew
    prepaid_period             = 1                           # valid: 1,2,3,4,6,7,8,9,12,24,36 (monthly plan)
  }

  tags = {
    createdBy = "terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | >= 1.81.0 |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `eip` | (Optional) EIP configuration object. See object definition below. | `object` | `{}` |
| `tags` | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` |

### `eip` object

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `name` | (Optional) EIP name. | `string` | `"Unnamed"` |
| `type` | (Optional) EIP type. Valid: `EIP`, `AnycastEIP`, `HighQualityEIP`, `AntiDDoSEIP`, `ResidentialEIP`. | `string` | `"EIP"` |
| `internet_charge_type` | (Optional) Charge type. Valid: `BANDWIDTH_PACKAGE`, `BANDWIDTH_POSTPAID_BY_HOUR`, `BANDWIDTH_PREPAID_BY_MONTH`, `TRAFFIC_POSTPAID_BY_HOUR`. | `string` | `"TRAFFIC_POSTPAID_BY_HOUR"` |
| `internet_max_bandwidth_out` | (Optional) Max outbound bandwidth in Mbps. | `number` | `5` |
| `internet_service_provider` | (Optional) ISP. Valid: `BGP`, `CMCC`, `CTCC`, `CUCC`. | `string` | `"BGP"` |
| `prepaid_period` | (Optional) Prepaid period in months. Valid: 1, 2, 3, 4, 6, 7, 8, 9, 12, 24, 36. | `number` | `1` |
| `auto_renew_flag` | (Optional) Auto renew flag: 0 manual, 1 automatic, 2 explicit no auto renew. | `number` | `0` |
| `bandwidth_package_id` | (Optional) Bandwidth package ID (when charge type is `BANDWIDTH_PACKAGE`). | `string` | `null` |
| `egress` | (Optional) Egress. | `string` | `null` |
| `anycast_zone` | (Optional) Anycast zone (when type is `AnycastEIP`). | `string` | `null` |
| `anti_ddos_package_id` | (Optional) Anti-DDoS package ID (when type is `AntiDDoSEIP`). | `string` | `null` |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the EIP. |
| `public_ip` | The public IP address of the EIP. |

## Authors

Maintained by the Boost Life migration / Landing Zone team.

## License

Mozilla Public License Version 2.0.
