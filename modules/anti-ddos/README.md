# TencentCloud Anti-DDoS Module for Terraform

Terraform module for creating and managing TencentCloud Anti-DDoS BGP instances.

## terraform-tencentcloud-antiddos

This module provides a complete solution for deploying TencentCloud Anti-DDoS BGP instances with support for different package types and billing modes.

## Examples:

### Basic Usage - Enterprise Package (Prepaid)
```hcl
module "antiddos_enterprise" {
  source = "path/to/module"

  instance_charge_type = "PREPAID"
  package_type         = "Enterprise"

  instance_charge_prepaid = [{
    period     = 1
    renew_flag = "NOTIFY_AND_MANUAL_RENEW"
  }]

  enterprise_package_config = [{
    region                    = "ap-guangzhou"
    protect_ip_count          = 10
    basic_protect_bandwidth   = 100
    bandwidth                 = 500
    elastic_protect_bandwidth = 400
    elastic_bandwidth_flag    = true
  }]

  tag_info_list = [{
    tag_key   = "Environment"
    tag_value = "Production"
  }]
}
```

### Standard Package (Postpaid)
```hcl
module "antiddos_standard" {
  source = "path/to/module"

  instance_charge_type = "POSTPAID_BY_MONTH"
  package_type         = "Standard"

  standard_package_config = [{
    region                 = "ap-shanghai"
    protect_ip_count       = 5
    bandwidth              = 50
    elastic_bandwidth_flag = false
  }]
}
```

### Standard Plus Package
```hcl
module "antiddos_standard_plus" {
  source = "path/to/module"

  instance_charge_type = "PREPAID"
  package_type         = "StandardPlus"

  instance_charge_prepaid = [{
    period     = 6
    renew_flag = "NOTIFY_AND_AUTO_RENEW"
  }]

  standard_plus_package_config = [{
    region                 = "ap-beijing"
    protect_count          = "TWO_TIMES"
    protect_ip_count       = 8
    bandwidth              = 50
    elastic_bandwidth_flag = true
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.80.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.80.0 |

## Inputs

### Required Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance_charge_type | Payment Type: PREPAID (Prepaid) / POSTPAID_BY_MONTH (Postpaid) | `string` | n/a | yes |
| package_type | High-defense package types: Enterprise, Standard, StandardPlus | `string` | n/a | yes |

### Optional Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance_charge_prepaid | Prepaid configuration | <pre>list(object({<br>    period     = optional(number)<br>    renew_flag = optional(string)<br>  }))</pre> | `[]` | no |
| enterprise_package_config | Enterprise package configuration | <pre>list(object({<br>    region                    = string<br>    protect_ip_count          = number<br>    basic_protect_bandwidth   = number<br>    bandwidth                 = number<br>    elastic_protect_bandwidth = optional(number, 0)<br>    elastic_bandwidth_flag    = optional(bool, false)<br>  }))</pre> | `[]` | no |
| standard_package_config | Standard package configuration | <pre>list(object({<br>    region                 = string<br>    protect_ip_count       = number<br>    bandwidth              = number<br>    elastic_bandwidth_flag = optional(bool, false)<br>  }))</pre> | `[]` | no |
| standard_plus_package_config | Standard Plus package configuration | <pre>list(object({<br>    region                 = string<br>    protect_count          = string<br>    protect_ip_count       = number<br>    bandwidth              = number<br>    elastic_bandwidth_flag = optional(bool, false)<br>  }))</pre> | `[]` | no |
| tag_info_list | Tag information list | <pre>list(object({<br>    tag_key   = string<br>    tag_value = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| resource_id | BGP instance ID |

## Package Types Configuration

### Enterprise Package
- **basic_protect_bandwidth**: Guaranteed protection bandwidth (Mbps)
- **bandwidth**: Service bandwidth scale (Mbps)
- **elastic_protect_bandwidth**: Elastic bandwidth (Gbps), options: [0, 400, 500, 600, 800, 1000]

### Standard Package
- **bandwidth**: Protected service bandwidth (50Mbps)

### Standard Plus Package
- **protect_count**: Protection count - TWO_TIMES (Two full-power protections) or UNLIMITED (Infinite protections)
- **bandwidth**: Protected bandwidth (50Mbps)

## Renew Flag Options

- `NOTIFY_AND_MANUAL_RENEW`: Notify expiration, no auto-renew (default)
- `NOTIFY_AND_AUTO_RENEW`: Notify expiration, auto-renew
- `DISABLE_NOTIFY_AND_MANUAL_RENEW`: No notification, no auto-renew

## Notes

- All configuration blocks are optional and will be skipped if empty lists are provided
- Only one configuration block per type is allowed (MaxItems: 1)
- Resources are force-new (require replacement on changes)
- Elastic bandwidth is disabled by default

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.