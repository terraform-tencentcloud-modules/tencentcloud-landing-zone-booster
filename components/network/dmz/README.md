# Tencent Cloud DMZ Component

Terraform component under `components/network/dmz` for building a complete DMZ (Demilitarized Zone) network architecture in Tencent Cloud, implementing a secure isolated network boundary between external and internal traffic, as part of the `network` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates an inbound VPC (for external traffic), an outbound VPC (for internal services), a NAT gateway for the outbound VPC, and attaches both VPCs to a CCN (Cloud Connect Network) instance. Main features:

- **Inbound VPC** – receives external traffic; deploy web/API tiers here.
- **Outbound VPC** – hosts internal business services; egress via NAT gateway.
- **NAT gateway** – provides outbound network address translation and public egress for the outbound VPC.
- **CCN attachment** – attach both VPCs to a CCN instance for inter-VPC connectivity.
- **Multi-AZ subnets** – multi availability-zone subnet configuration.
- **Security isolation** – separate external/internal traffic with independent VPCs and tagging.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.125 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.125 |

### IAM Permissions

The executing principal needs the following Tencent Cloud permissions:

| Permission | Description |
|------------|-------------|
| `QcloudVPCFullAccess` | Full access to VPC management |
| `QcloudCCNFullAccess` | Full access to CCN management |
| `QcloudNATGatewayFullAccess` | Full access to NAT gateway management |
| `QcloudTagFullAccess` | Full access to Tag management |

### Prerequisites

- Plan the inbound/outbound VPC CIDR blocks so they do not overlap.
- Obtain the target CCN instance ID (`ccn_id`) and/or name (`ccn_name`).
- Plan the subnet division strategy and AZ placement.
- Determine the NAT gateway bandwidth and EIP requirements.
- Plan the network traffic direction (north-south vs east-west).

---

## Inputs

### VPC common configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | `string` | yes | – | The region of the VPCs. |
| <a name="input_vpc_common_tags"></a> [vpc\_common\_tags](#input\_vpc\_common\_tags) | `map(string)` | no | `{}` | Common tags added to all resources. |

### Inbound VPC configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_vpc_inbound_name"></a> [vpc\_inbound\_name](#input\_vpc\_inbound\_name) | `string` | no | `"my-vpc"` | Name of the inbound VPC. |
| <a name="input_vpc_inbound_cidr"></a> [vpc\_inbound\_cidr](#input\_vpc\_inbound\_cidr) | `string` | no | `"172.16.0.0/16"` | CIDR block of the inbound VPC. |
| <a name="input_vpc_inbound_is_multicast"></a> [vpc\_inbound\_is\_multicast](#input\_vpc\_inbound\_is\_multicast) | `bool` | no | `true` | Whether the inbound VPC supports multicast. |
| <a name="input_vpc_inbound_dns_servers"></a> [vpc\_inbound\_dns\_servers](#input\_vpc\_inbound\_dns\_servers) | `list(string)` | no | `null` | Custom DNS servers for the inbound VPC. |
| <a name="input_vpc_inbound_tags"></a> [vpc\_inbound\_tags](#input\_vpc\_inbound\_tags) | `map(string)` | no | `{}` | Additional tags for the inbound VPC. |
| <a name="input_vpc_inbound_subnet_cidrs"></a> [vpc\_inbound\_subnet\_cidrs](#input\_vpc\_inbound\_subnet\_cidrs) | `list(object)` | yes | – | Subnet definitions for the inbound VPC. |
| `↳ subnet_name` | `string` | yes | – | Subnet name (max 60 characters). |
| `↳ subnet_cidr` | `string` | yes | – | Subnet CIDR block. |
| `↳ subnet_is_multicast` | `bool` | no | `true` | Whether the subnet supports multicast. |
| `↳ availability_zone` | `string` | no | – | Availability zone; if not set, randomly chosen from all. |
| <a name="input_vpc_inbound_subnet_tags"></a> [vpc\_inbound\_subnet\_tags](#input\_vpc\_inbound\_subnet\_tags) | `map(string)` | no | `{}` | Additional tags for the inbound subnets. |

### Outbound VPC configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_vpc_outbound_name"></a> [vpc\_outbound\_name](#input\_vpc\_outbound\_name) | `string` | no | `"my-vpc"` | Name of the outbound VPC. |
| <a name="input_vpc_outbound_cidr"></a> [vpc\_outbound\_cidr](#input\_vpc\_outbound\_cidr) | `string` | no | `"172.16.0.0/16"` | CIDR block of the outbound VPC. |
| <a name="input_vpc_outbound_is_multicast"></a> [vpc\_outbound\_is\_multicast](#input\_vpc\_outbound\_is\_multicast) | `bool` | no | `true` | Whether the outbound VPC supports multicast. |
| <a name="input_vpc_outbound_dns_servers"></a> [vpc\_outbound\_dns\_servers](#input\_vpc\_outbound\_dns\_servers) | `list(string)` | no | `null` | Custom DNS servers for the outbound VPC. |
| <a name="input_vpc_outbound_tags"></a> [vpc\_outbound\_tags](#input\_vpc\_outbound\_tags) | `map(string)` | no | `{}` | Additional tags for the outbound VPC. |
| <a name="input_vpc_outbound_subnet_cidrs"></a> [vpc\_outbound\_subnet\_cidrs](#input\_vpc\_outbound\_subnet\_cidrs) | `list(object)` | yes | – | Subnet definitions for the outbound VPC. |
| `↳ subnet_name` | `string` | yes | – | Subnet name (max 60 characters). |
| `↳ subnet_cidr` | `string` | yes | – | Subnet CIDR block. |
| `↳ subnet_is_multicast` | `bool` | no | `true` | Whether the subnet supports multicast. |
| `↳ availability_zone` | `string` | no | – | Availability zone; if not set, randomly chosen from all. |
| <a name="input_vpc_outbound_subnet_tags"></a> [vpc\_outbound\_subnet\_tags](#input\_vpc\_outbound\_subnet\_tags) | `map(string)` | no | `{}` | Additional tags for the outbound subnets. |

### NAT gateway configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_nat_gateway_name"></a> [nat\_gateway\_name](#input\_nat\_gateway\_name) | `string` | no | `""` | Name of the NAT gateway (created in the outbound VPC). |
| <a name="input_nat_eips"></a> [nat\_eips](#input\_nat\_eips) | `list(string)` | no | `[]` | List of EIPs to bind to the NAT gateway. |
| <a name="input_nat_public_ips"></a> [nat\_public\_ips](#input\_nat\_public\_ips) | `list(string)` | no | `[]` | List of public IPs to bind to the NAT gateway. |
| <a name="input_nat_internet_max_bandwidth_out"></a> [nat\_internet\_max\_bandwidth\_out](#input\_nat\_internet\_max\_bandwidth\_out) | `number` | no | `100` | Max egress bandwidth to the internet (Mbps). |
| <a name="input_nat_product_version"></a> [nat\_product\_version](#input\_nat\_product\_version) | `number` | no | `1` | NAT product version: `1` (traditional), `2` (standard). |
| <a name="input_nat_gateway_bandwidth"></a> [nat\_gateway\_bandwidth](#input\_nat\_gateway\_bandwidth) | `number` | no | `100` | Bandwidth of the NAT gateway. |
| <a name="input_nat_gateway_concurrent"></a> [nat\_gateway\_concurrent](#input\_nat\_gateway\_concurrent) | `number` | no | `1000000` | Max concurrent connections of the NAT gateway. |
| <a name="input_nat_enable_flow_monitor"></a> [nat\_enable\_flow\_monitor](#input\_nat\_enable\_flow\_monitor) | `bool` | no | `false` | Whether to enable flow monitoring. |
| <a name="input_nat_tags"></a> [nat\_tags](#input\_nat\_tags) | `map(string)` | no | `{}` | Tags for the NAT gateway. |

### CCN attachment configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ccn_id"></a> [ccn\_id](#input\_ccn\_id) | `string` | no | `null` | The ID of the CCN instance to attach. |
| <a name="input_ccn_name"></a> [ccn\_name](#input\_ccn\_name) | `string` | no | `null` | The name of the CCN instance to attach (used if `ccn_id` is not set). |
| <a name="input_attachment_description"></a> [attachment\_description](#input\_attachment\_description) | `string` | no | `""` | Description of the CCN attachment (max 100 bytes). |
| <a name="input_ccn_uin"></a> [ccn\_uin](#input\_ccn\_uin) | `string` | no | `null` | UIN of the CCN owner. If not set, uses the current account's UIN. Used for cross-account CCN attachment (only `VPC` instance type supported for now). |

> **Note**: CCN attachment is identified by `ccn_id` first, falling back to `ccn_name` lookup. If neither is provided, the VPCs are created without CCN attachment.

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_inbound_vpc_id"></a> [inbound\_vpc\_id](#output\_inbound\_vpc\_id) | The ID of the inbound VPC. |
| <a name="output_outbound_vpc_id"></a> [outbound\_vpc\_id](#output\_outbound\_vpc\_id) | The ID of the outbound VPC. |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | The ID of the NAT gateway. |

---

## Configuration Examples

### `terraform.tfvars` – production DMZ

```hcl
# VPC common configuration
vpc_region = "ap-beijing"
vpc_common_tags = {
  Environment = "production"
  NetworkType = "dmz"
  ManagedBy   = "terraform"
}

# Inbound VPC
vpc_inbound_name         = "dmz-inbound-vpc"
vpc_inbound_cidr         = "10.0.0.0/16"
vpc_inbound_is_multicast = true
vpc_inbound_dns_servers  = ["183.60.83.19", "183.60.82.98"]
vpc_inbound_tags = {
  VPCType = "inbound"
  Purpose = "external-access"
}

vpc_inbound_subnet_cidrs = [
  {
    subnet_name         = "inbound-subnet-1"
    subnet_cidr         = "10.0.1.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-3"
  },
  {
    subnet_name         = "inbound-subnet-2"
    subnet_cidr         = "10.0.2.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-4"
  }
]

vpc_inbound_subnet_tags = {
  SubnetType = "inbound"
}

# Outbound VPC
vpc_outbound_name         = "dmz-outbound-vpc"
vpc_outbound_cidr         = "10.1.0.0/16"
vpc_outbound_is_multicast = true
vpc_outbound_dns_servers  = ["183.60.83.19"]
vpc_outbound_tags = {
  VPCType = "outbound"
  Purpose = "internal-services"
}

vpc_outbound_subnet_cidrs = [
  {
    subnet_name         = "outbound-subnet-1"
    subnet_cidr         = "10.1.1.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-3"
  },
  {
    subnet_name         = "outbound-subnet-2"
    subnet_cidr         = "10.1.2.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-4"
  }
]

vpc_outbound_subnet_tags = {
  SubnetType = "outbound"
}

# NAT gateway
nat_gateway_name                = "dmz-nat-gateway"
nat_eips                        = ["eip-xxxxxx", "eip-yyyyyy"]
nat_internet_max_bandwidth_out = 500
nat_product_version             = 2
nat_gateway_bandwidth           = 500
nat_gateway_concurrent          = 2000000
nat_enable_flow_monitor         = true
nat_tags = {
  GatewayType = "nat"
  Bandwidth   = "500Mbps"
}

# CCN attachment
ccn_id                 = "ccn-abcdef"
attachment_description = "DMZ network attached to production CCN"
```

### Simple configuration

```hcl
vpc_region = "ap-shanghai"

# Inbound VPC
vpc_inbound_name = "dmz-inbound"
vpc_inbound_cidr = "10.10.0.0/16"
vpc_inbound_subnet_cidrs = [
  {
    subnet_name = "inbound-subnet"
    subnet_cidr = "10.10.1.0/24"
  }
]

# Outbound VPC
vpc_outbound_name = "dmz-outbound"
vpc_outbound_cidr = "10.11.0.0/16"
vpc_outbound_subnet_cidrs = [
  {
    subnet_name = "outbound-subnet"
    subnet_cidr = "10.11.1.0/24"
  }
]

# NAT gateway
nat_gateway_name                = "dmz-nat"
nat_internet_max_bandwidth_out = 200

# CCN attachment
ccn_id = "ccn-123456"
```

### Multi-AZ high-availability configuration

```hcl
vpc_region = "ap-guangzhou"

# Inbound VPC (multi-AZ)
vpc_inbound_name = "ha-dmz-inbound"
vpc_inbound_cidr = "10.20.0.0/16"
vpc_inbound_subnet_cidrs = [
  {
    subnet_name       = "inbound-zone3"
    subnet_cidr       = "10.20.1.0/24"
    availability_zone = "ap-guangzhou-3"
  },
  {
    subnet_name       = "inbound-zone4"
    subnet_cidr       = "10.20.2.0/24"
    availability_zone = "ap-guangzhou-4"
  },
  {
    subnet_name       = "inbound-zone6"
    subnet_cidr       = "10.20.3.0/24"
    availability_zone = "ap-guangzhou-6"
  }
]

# Outbound VPC (multi-AZ)
vpc_outbound_name = "ha-dmz-outbound"
vpc_outbound_cidr = "10.21.0.0/16"
vpc_outbound_subnet_cidrs = [
  {
    subnet_name       = "outbound-zone3"
    subnet_cidr       = "10.21.1.0/24"
    availability_zone = "ap-guangzhou-3"
  },
  {
    subnet_name       = "outbound-zone4"
    subnet_cidr       = "10.21.2.0/24"
    availability_zone = "ap-guangzhou-4"
  }
]

# High-availability NAT gateway
nat_gateway_name                = "ha-dmz-nat"
nat_eips                        = ["eip-ha1", "eip-ha2", "eip-ha3"]
nat_internet_max_bandwidth_out = 1000
nat_product_version             = 2
nat_gateway_bandwidth           = 1000
nat_enable_flow_monitor         = true

# CCN attachment
ccn_id                 = "ccn-ha-infra"
attachment_description = "High-availability DMZ network attachment"

vpc_common_tags = {
  Environment       = "production"
  HighAvailability  = "enabled"
  MultiAZ           = "true"
}
```

---

## Usage Examples

### Example 1: Production DMZ architecture

```hcl
vpc_region = "ap-beijing"

# Inbound VPC - external access zone
vpc_inbound_name = "prod-dmz-inbound"
vpc_inbound_cidr = "10.100.0.0/16"
vpc_inbound_subnet_cidrs = [
  {
    subnet_name       = "prod-inbound-web"
    subnet_cidr       = "10.100.1.0/24"
    availability_zone = "ap-beijing-3"
  },
  {
    subnet_name       = "prod-inbound-api"
    subnet_cidr       = "10.100.2.0/24"
    availability_zone = "ap-beijing-4"
  }
]

# Outbound VPC - internal services zone
vpc_outbound_name = "prod-dmz-outbound"
vpc_outbound_cidr = "10.101.0.0/16"
vpc_outbound_subnet_cidrs = [
  {
    subnet_name       = "prod-outbound-app"
    subnet_cidr       = "10.101.1.0/24"
    availability_zone = "ap-beijing-3"
  },
  {
    subnet_name       = "prod-outbound-db"
    subnet_cidr       = "10.101.2.0/24"
    availability_zone = "ap-beijing-4"
  }
]

nat_gateway_name                = "prod-dmz-nat"
nat_eips                        = ["eip-prod-1", "eip-prod-2"]
nat_internet_max_bandwidth_out = 1000
nat_product_version             = 2
nat_enable_flow_monitor         = true

ccn_id                 = "ccn-prod-main"
attachment_description = "Production DMZ network attachment"

vpc_common_tags = {
  Environment = "production"
  NetworkType = "dmz"
  SLA         = "99.95%"
  CostCenter  = "infrastructure"
}

vpc_inbound_tags = {
  SecurityZone = "external"
  AccessLevel  = "public"
}

vpc_outbound_tags = {
  SecurityZone = "internal"
  AccessLevel  = "private"
}
```

### Example 2: Development DMZ

```hcl
vpc_region = "ap-shanghai"

vpc_inbound_name = "dev-dmz-inbound"
vpc_inbound_cidr = "10.200.0.0/16"
vpc_inbound_subnet_cidrs = [
  {
    subnet_name = "dev-inbound"
    subnet_cidr = "10.200.1.0/24"
  }
]

vpc_outbound_name = "dev-dmz-outbound"
vpc_outbound_cidr = "10.201.0.0/16"
vpc_outbound_subnet_cidrs = [
  {
    subnet_name = "dev-outbound"
    subnet_cidr = "10.201.1.0/24"
  }
]

nat_gateway_name                = "dev-dmz-nat"
nat_internet_max_bandwidth_out = 100
ccn_id                          = "ccn-dev"

vpc_common_tags = {
  Environment = "development"
  Purpose     = "testing"
  CostCenter  = "rd"
}
```

### Example 3: Finance-grade secure DMZ

```hcl
vpc_region = "ap-singapore"

# Inbound VPC - strict security control
vpc_inbound_name = "finance-dmz-inbound"
vpc_inbound_cidr = "10.50.0.0/16"
vpc_inbound_subnet_cidrs = [
  {
    subnet_name       = "finance-inbound-web"
    subnet_cidr       = "10.50.1.0/24"
    availability_zone = "ap-singapore-1"
  },
  {
    subnet_name       = "finance-inbound-api"
    subnet_cidr       = "10.50.2.0/24"
    availability_zone = "ap-singapore-2"
  }
]

# Outbound VPC - internal core services
vpc_outbound_name = "finance-dmz-outbound"
vpc_outbound_cidr = "10.51.0.0/16"
vpc_outbound_subnet_cidrs = [
  {
    subnet_name       = "finance-outbound-app"
    subnet_cidr       = "10.51.1.0/24"
    availability_zone = "ap-singapore-1"
  },
  {
    subnet_name       = "finance-outbound-db"
    subnet_cidr       = "10.51.2.0/24"
    availability_zone = "ap-singapore-2"
  }
]

nat_gateway_name                = "finance-dmz-nat"
nat_eips                        = ["eip-finance-1", "eip-finance-2"]
nat_internet_max_bandwidth_out = 500
nat_product_version             = 2
nat_enable_flow_monitor         = true

ccn_id                 = "ccn-finance"
attachment_description = "Finance-grade DMZ network attachment"

vpc_common_tags = {
  Environment   = "production"
  Industry      = "finance"
  SecurityLevel = "high"
  Compliance    = "pci-dss"
}

vpc_inbound_tags = {
  SecurityZone = "dmz"
  AccessType   = "restricted"
}

vpc_outbound_tags = {
  SecurityZone = "internal"
  AccessType   = "controlled"
}
```

---

## Configuration Notes

### DMZ architecture components

| Component | Description | Security level |
|-----------|-------------|----------------|
| **Inbound VPC** | Receives external traffic; hosts web servers, API gateways, etc. | Medium |
| **Outbound VPC** | Hosts internal business services; egress via NAT. | High |
| **NAT gateway** | Provides outbound network address translation. | Network boundary |
| **CCN attachment** | Enables inter-VPC connectivity. | Internal network |

### Subnet object schema

```hcl
{
  subnet_name         = "subnet-name"        # Subnet name (max 60 characters)
  subnet_cidr         = "10.0.1.0/24"        # Subnet CIDR
  subnet_is_multicast = true                 # Whether multicast is supported (optional, default true)
  availability_zone   = "ap-beijing-3"       # Availability zone (optional)
}
```

### NAT gateway versions

| Version | Description | Use case |
|---------|-------------|----------|
| **Version 1** | Traditional NAT gateway | Basic network address translation. |
| **Version 2** | Standard NAT gateway | High-performance / high-availability scenarios. |

### CCN attachment priority

- If both `ccn_id` and `ccn_name` are provided, `ccn_id` takes precedence.
- If only `ccn_name` is provided, the CCN instance ID is looked up by name.
- If neither is provided, the VPCs are created without CCN attachment.

### Internal dependency order

1. The inbound VPC and outbound VPC are created first.
2. The NAT gateway is created (depends on the outbound VPC).
3. Finally the CCN attachment is applied (depends on both VPCs).

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Network planning**
   - Ensure the inbound VPC and outbound VPC CIDR blocks do not overlap.
   - Right-size subnets and reserve room for expansion.
   - Consider multi-AZ deployment for higher availability.

2. **Security policy**
   - Apply strict security group rules to the inbound VPC.
   - Restrict external access to the outbound VPC.
   - Use network ACLs for traffic control.

3. **NAT gateway configuration**
   - Choose bandwidth according to business needs.
   - Prefer the standard NAT gateway (version 2) for better performance.
   - Enable flow monitoring for troubleshooting.

4. **CCN attachment**
   - Ensure the CCN instance exists and is in a normal state.
   - Understand CCN routing policy and bandwidth limits.
   - For cross-account attachment, configure `ccn_uin`.

5. **Cost optimization**
   - Choose NAT bandwidth appropriately to avoid waste.
   - Use tags for cost allocation and monitoring.
   - Consider prepaid mode to reduce cost.

6. **Monitoring & alerting**
   - Configure NAT gateway traffic monitoring.
   - Set VPC network traffic alerts.
   - Monitor CCN bandwidth usage.

7. **Backup & recovery**
   - Back up network configuration periodically.
   - Prepare a network failure recovery plan.
   - Test network failover procedures.

8. **Compliance**
   - Ensure the network architecture meets security/compliance requirements.
   - Record network change operations.
   - Conduct periodic security audits.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: VPC CIDR conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=VPC CIDR conflict
```

**Cause**: The VPC CIDR blocks conflict or overlap.
**Solution**:
- Check whether the inbound and outbound VPC CIDRs overlap.
- Ensure the CIDR is unique within the region.
- Use different private address ranges.

#### Error 2: Subnet CIDR out of VPC range

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Subnet CIDR out of VPC range
```

**Cause**: The subnet CIDR is not within the VPC CIDR range.
**Solution**:
- Ensure the subnet CIDR is a subset of the VPC CIDR.
- Check the subnet mask is correct.
- Re-plan the subnet division.

#### Error 3: NAT gateway creation failed

```
Error: [TencentCloudSDKError] Code=NatGatewayError
Message=NAT gateway creation failed
```

**Cause**: The NAT gateway creation failed.
**Solution**:
- Check the VPC ID is correct.
- Verify the EIPs are available.
- Confirm the bandwidth settings are reasonable.

#### Error 4: CCN attachment failed

```
Error: [TencentCloudSDKError] Code=CcnAttachmentError
Message=CCN attachment failed
```

**Cause**: The CCN attachment operation failed.
**Solution**:
- Confirm the CCN instance exists and is in a normal state.
- Check region consistency.
- Verify attachment permissions (and `ccn_uin` for cross-account).

#### Error 5: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks the required permissions.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check VPC, CCN and NAT gateway management permissions are included.
- Verify cross-account operation permissions.

#### Error 6: Resource quota exceeded

```
Error: [TencentCloudSDKError] Code=QuotaExceeded
Message=Resource quota exceeded
```

**Cause**: A resource quota limit has been reached.
**Solution**:
- Check the quotas for VPC, subnet and NAT gateway.
- Request a quota increase or delete unused resources.
- Plan resource usage reasonably.

## License

See [LICENSE](../../../LICENSE) for full details.