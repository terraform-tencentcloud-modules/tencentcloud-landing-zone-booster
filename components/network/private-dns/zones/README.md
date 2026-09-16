# Tencent Cloud Private DNS Module

This module manages Tencent Cloud Private DNS resources.

## Supported Resources

- `tencentcloud_subscribe_private_zone_service` - Enable Private Zone service
- `tencentcloud_private_dns_zone` - Private DNS zones
- `tencentcloud_private_dns_record` - DNS records
- `tencentcloud_private_dns_zone_vpc_attachment` - Zone VPC attachments
- `tencentcloud_private_dns_forward_rule` - Forward rules

## Usage Examples

### Basic: Create Zone and Records

```hcl
module "private_dns" {
  source = "../../modules/tencent/tfmodule-tencentcloud-privatedns"

  # Enable service first (only need once per account)
  enable_private_zone_service = true

  zones = {
    internal = {
      domain = "internal.example.com"
      remark = "Internal domain"
      
      vpc_set = [{
        uniq_vpc_id = "vpc-xxxxxx"
        region      = "ap-guangzhou"
      }]
      
      tags = { Environment = "prod" }
    }
  }

  records = {
    api = {
      zone_key     = "internal"
      record_type  = "A"
      sub_domain   = "api"
      record_value = "10.0.0.100"
    }
  }
}
```

### Cross-Account VPC Association

```hcl
module "private_dns" {
  source = "../../modules/tencent/tfmodule-tencentcloud-privatedns"

  zones = {
    shared = {
      domain = "shared.internal"
      
      vpc_set = [{
        uniq_vpc_id = "vpc-xxxxxx"
        region      = "ap-guangzhou"
      }]
      
      # Cross-account VPC
      account_vpc_set = [{
        uin         = "100000000001"
        uniq_vpc_id = "vpc-yyyyyy"
        region      = "ap-shanghai"
      }]
    }
  }
}
```

### DNS Forward Rule

```hcl
module "private_dns" {
  source = "../../modules/tencent/tfmodule-tencentcloud-privatedns"

  zones = {
    forward_zone = {
      domain             = "forward.internal"
      dns_forward_status = "ENABLED"
      
      vpc_set = [{
        uniq_vpc_id = "vpc-xxxxxx"
        region      = "ap-guangzhou"
      }]
    }
  }

  end_points = {
    ep1 = {
      end_point_name    = "my-endpoint"
      end_point_region  = "ap-guangzhou"
      end_point_service = "vpce-xxxxxx"
      ip_num            = 2
    }
  }

  forward_rules = {
    rule1 = {
      rule_name    = "forward-to-idc"
      rule_type    = "DOWN"  # DOWN: cloud to IDC, UP: IDC to cloud
      zone_key     = "forward_zone"
      endpoint_key = "ep1"
    }
  }
}
```

### Load Balancing with Weight

```hcl
module "private_dns" {
  source = "../../modules/tencent/tfmodule-tencentcloud-privatedns"

  zones = {
    lb_zone = {
      domain = "lb.internal"
      vpc_set = [{
        uniq_vpc_id = "vpc-xxxxxx"
        region      = "ap-guangzhou"
      }]
    }
  }

  records = {
    backend1 = {
      zone_key     = "lb_zone"
      record_type  = "A"
      sub_domain   = "api"
      record_value = "10.0.0.1"
      weight       = 70
    }
    backend2 = {
      zone_key     = "lb_zone"
      record_type  = "A"
      sub_domain   = "api"
      record_value = "10.0.0.2"
      weight       = 30
    }
  }
}
```

### Using Existing Zone ID

```hcl
module "private_dns" {
  source = "../../modules/tencent/tfmodule-tencentcloud-privatedns"

  # Reference existing zone by ID instead of zone_key
  records = {
    record1 = {
      zone_id      = "zone-xxxxxx"  # Direct zone ID
      record_type  = "A"
      sub_domain   = "api"
      record_value = "10.0.0.100"
    }
  }

  vpc_attachments = {
    attach1 = {
      zone_id = "zone-xxxxxx"
      vpc_set = {
        uniq_vpc_id = "vpc-yyyyyy"
        region      = "ap-shanghai"
      }
    }
  }
}
```

## Input Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `enable_private_zone_service` | Enable private zone service | `bool` | `false` |
| `zones` | Zone configurations | `map(object)` | `{}` |
| `records` | Record configurations | `map(object)` | `{}` |
| `vpc_attachments` | VPC attachment configurations | `map(object)` | `{}` |
| `forward_rules` | Forward rule configurations | `map(object)` | `{}` |

### zones

```hcl
zones = {
  <key> = {
    domain               = string           # Required: domain name
    remark               = string           # Optional
    dns_forward_status   = string           # ENABLED/DISABLED, default: DISABLED
    cname_speedup_status = string           # ENABLED/DISABLED, default: ENABLED
    vpc_set = [{                            # Optional
      uniq_vpc_id = string
      region      = string
    }]
    account_vpc_set = [{                    # Optional: cross-account
      uin         = string
      uniq_vpc_id = string
      region      = string
    }]
    tags = map(string)                      # Optional
  }
}
```

### records

```hcl
records = {
  <key> = {
    zone_key     = string  # Reference to zones key (or use zone_id)
    zone_id      = string  # Direct zone ID (alternative to zone_key)
    record_type  = string  # A, AAAA, CNAME, MX, TXT, PTR, SRV, NS
    sub_domain   = string  # @ for root domain
    record_value = string
    ttl          = number  # Default: 600
    weight       = number  # 1-100, for load balancing
    mx           = number  # 1-50, only for MX records
  }
}
```

### vpc_attachments

```hcl
vpc_attachments = {
  <key> = {
    zone_key = string           # Reference to zones key (or use zone_id)
    zone_id  = string           # Direct zone ID
    vpc_set = {                 # Same account
      uniq_vpc_id = string
      region      = string
    }
    account_vpc_set = {         # Cross-account
      uin         = string
      uniq_vpc_id = string
      region      = string
    }
  }
}
```

### forward_rules

```hcl
forward_rules = {
  <key> = {
    rule_name    = string  # Rule name
    rule_type    = string  # DOWN (cloud->IDC) or UP (IDC->cloud)
    zone_key     = string  # Reference to zones key (or use zone_id)
    zone_id      = string  # Direct zone ID
    endpoint_key = string  # Reference to end_points key (or use endpoint_id)
    endpoint_id  = string  # Direct endpoint ID
  }
}
```

## Outputs

| Output | Description |
|--------|-------------|
| `private_zone_service_enabled` | Service enabled status |
| `zone_ids` | Map of zone keys to IDs |
| `zone_domains` | Map of zone keys to domains |
| `zones` | Complete zone objects |
| `record_ids` | Map of record keys to IDs |
| `record_sub_domains` | Map of record keys to sub domains |
| `records` | Complete record objects |
| `vpc_attachment_ids` | Map of attachment keys to IDs |
| `vpc_attachments` | Complete attachment objects |
| `forward_rule_ids` | Map of forward rule keys to IDs |
| `forward_rules` | Complete forward rule objects |

## Notes

1. Empty maps create no resources
2. Use `zone_key` to reference zones in this module, or `zone_id` for existing zones
3. Use `endpoint_key` to reference endpoints in this module, or `endpoint_id` for existing endpoints
4. Forward rules require both zone and endpoint

## Requirements

- Terraform >= 1.0.0
- tencentcloud provider >= 1.82.70
