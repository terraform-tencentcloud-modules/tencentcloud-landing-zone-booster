# TencentCloud NAT Gateway Component for Terraform

Terraform component under `components/network/nat-gateway` for creating and managing Tencent Cloud NAT Gateways (both traditional and standard product versions) along with their associated EIPs and optional flow monitoring. It is part of the `network` building block of the tencentcloud-landing-zone-booster framework.

## Features

- Provision one or more NAT Gateways in a VPC via a `map` input (keyed by logical name).
- Support both **traditional NAT** (`product_version = 1`) and **standard NAT** (`product_version = 2`).
- Automatic EIP creation when no `public_ips` are provided, or use pre-allocated public IPs.
- Optional flow monitor (`enable_flow_monitor`) per NAT Gateway.
- Separate tag maps for NAT Gateways (`nat_tags`) and EIPs (`eip_tags`).

## Usage

```hcl
module "nat_gateway" {
  source = "path/to/components/network/nat-gateway"

  vpc_id = "vpc-xxxxxxxx"

  nat_gateways = {
    ng_standard = {
      name            = "standard-nat"
      product_version = 2
      public_bandwidth_out = 100
      enable_flow_monitor  = true
      eips = [
        {
          name = "ng-ngw-1"
          type = "EIP"
        }
      ]
    }

    ng_traditional = {
      name            = "traditional-nat"
      product_version = 1
      bandwidth       = 100
      concurrent      = 1000000
      public_ips      = ["203.0.113.10"] # use pre-allocated IPs
    }
  }

  nat_tags = { Environment = "Production" }
  eip_tags = { Environment = "Production" }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.125 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.125 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of vpc where nat gateway created | `string` | n/a | yes |
| <a name="input_nat_gateways"></a> [nat\_gateways](#input\_nat\_gateways) | NAT Gateway configurations | <pre>map(object({<br>  name                 = string<br>  zone                 = optional(string)<br>  product_version      = optional(number, 2)        # 1: traditional NAT, 2: standard NAT<br>  bandwidth            = optional(number, 100)<br>  concurrent           = optional(number, 1000000)<br>  public_bandwidth_out = optional(number)<br>  enable_flow_monitor  = optional(bool, false)<br>  public_ips           = optional(list(string), [])<br>  eips = optional(list(object({<br>    name                       = optional(string, "Unnamed")<br>    type                       = optional(string, "EIP")<br>    internet_charge_type       = optional(string, "TRAFFIC_POSTPAID_BY_HOUR")<br>    internet_max_bandwidth_out = optional(number, 5)<br>    internet_service_provider  = optional(string, "BGP")<br>    prepaid_period             = optional(number, 1)<br>    auto_renew_flag            = optional(number, 0)<br>    bandwidth_package_id       = optional(string)<br>    egress                     = optional(string)<br>    anycast_zone               = optional(string)<br>    anti_ddos_package_id       = optional(string)<br>  })))<br>}))</pre> | `{}` | no |
| <a name="input_nat_tags"></a> [nat\_tags](#input\_nat\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_eip_tags"></a> [eip\_tags](#input\_eip\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

### `nat_gateways` object fields

| Field | Description | Default |
|-------|-------------|---------|
| `name` | Name of the NAT Gateway. | n/a (required) |
| `zone` | Availability zone of the NAT Gateway. | n/a |
| `product_version` | `1` = traditional NAT, `2` = standard NAT. | `2` |
| `bandwidth` | Max bandwidth (Mbps) for traditional NAT (`product_version = 1`). | `100` |
| `concurrent` | Max concurrent connections for traditional NAT. | `1000000` |
| `public_bandwidth_out` | Max outbound public bandwidth (Mbps) for standard NAT (`product_version = 2`). | n/a |
| `enable_flow_monitor` | Enable NAT Gateway flow monitor. | `false` |
| `public_ips` | Pre-allocated public IP list; if empty, EIPs are auto-created from `eips`. | `[]` |
| `eips` | List of EIP objects to create and bind when `public_ips` is empty. | n/a |

### `eips` object fields

| Field | Description | Default |
|-------|-------------|---------|
| `name` | EIP name. | `"Unnamed"` |
| `type` | EIP type. | `"EIP"` |
| `internet_charge_type` | EIP billing mode. | `"TRAFFIC_POSTPAID_BY_HOUR"` |
| `internet_max_bandwidth_out` | Max outbound bandwidth (Mbps). | `5` |
| `internet_service_provider` | ISP: `BGP` / `CMCC` / `CTCC` / `CUCC`. | `"BGP"` |
| `prepaid_period` | Prepaid period (months). | `1` |
| `auto_renew_flag` | `0` manual / `1` auto / `2` no auto renew. | `0` |
| `bandwidth_package_id` | Bandwidth package ID (when billing = `BANDWIDTH_PACKAGE`). | n/a |
| `egress` | Egress type. | n/a |
| `anycast_zone` | Anycast zone (for `AnycastEIP`). | n/a |
| `anti_ddos_package_id` | Anti-DDoS package ID (for `AntiDDoSEIP`). | n/a |

### Validation Rules

- `eips[].type` must be one of: `EIP`, `AnycastEIP`, `HighQualityEIP`, `AntiDDoSEIP`, `ResidentialEIP`.
- `eips[].internet_charge_type` must be one of: `BANDWIDTH_PACKAGE`, `BANDWIDTH_POSTPAID_BY_HOUR`, `BANDWIDTH_PREPAID_BY_MONTH`, `TRAFFIC_POSTPAID_BY_HOUR`.
- `eips[].internet_service_provider` must be one of: `BGP`, `CMCC`, `CTCC`, `CUCC` (or null).
- `eips[].auto_renew_flag` must be one of: `0`, `1`, `2`.
- `eips[].prepaid_period` must be one of: `1`, `2`, `3`, `4`, `6`, `7`, `8`, `9`, `12`, `24`, `36`.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | The IDs of the NAT Gateways, keyed by the nat_gateways input key. |
| <a name="output_nat_gateway_eips"></a> [nat\_gateway\_eips](#output\_nat\_gateway\_eips) | The IDs and PublicIP of the created EIPs, keyed by `<nat_gateway_key>:<index>`. |

## Notes

- When `public_ips` is empty, EIPs are created from the `eips` list and automatically assigned to the NAT Gateway; otherwise the provided `public_ips` are used directly.
- `public_bandwidth_out` applies only to standard NAT (`product_version = 2`); `bandwidth` and `max_concurrent` apply only to traditional NAT (`product_version = 1`).
- Flow monitor is provisioned only for NAT Gateways with `enable_flow_monitor = true`.

## License

See [LICENSE](../../../LICENSE) for full details.
