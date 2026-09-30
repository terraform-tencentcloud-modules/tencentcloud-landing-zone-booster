# Tencent Cloud CCN-VPC Component

Terraform component under `components/network/ccn-vpc` for creating a VPC (Virtual Private Cloud) in Tencent Cloud and attaching it to a CCN (Cloud Connect Network) instance, enabling VPC-to-CCN interconnection as part of the `network` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates (or references) a VPC, configures its subnets, and attaches the VPC to a CCN instance. Main features:

- **VPC creation** – create a new VPC (CIDR, multicast, custom DNS servers, tags).
- **Subnet configuration** – create multiple subnets with AZ, multicast and per-subnet tags.
- **CCN attachment** – attach the VPC to a specified CCN instance (toggleable via `attach_ccn`).
- **Route table association** – associate the VPC attachment with a specific CCN route table.
- **Cross-account support** – attach to a CCN owned by another account via `ccn_uin`.
- **Tag management** – attach tags to the VPC and subnets.

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
| `QcloudTagFullAccess` | Full access to Tag management |

### Prerequisites

- Plan the VPC CIDR block in advance and avoid overlapping with other VPCs.
- Obtain the target CCN instance ID (`ccn_id`).
- For cross-account attachments, obtain the CCN owner account UIN (`ccn_uin`).
- Plan the subnet division strategy and AZ placement.
- Understand the network interconnection topology and routing requirements.

---

## Inputs

### VPC configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | `string` | yes | – | The VPC name, used to launch a new VPC. |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | `string` | yes | – | The CIDR block of the new VPC. |
| <a name="input_vpc_is_multicast"></a> [vpc\_is\_multicast](#input\_vpc\_is\_multicast) | `bool` | no | `null` | Whether to enable multicast for the VPC. |
| <a name="input_vpc_dns_servers"></a> [vpc\_dns\_servers](#input\_vpc\_dns\_servers) | `list(string)` | no | `null` | Custom DNS servers for the VPC. |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | `map(string)` | no | `{}` | Tags added to all resources. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | no | `{}` | Additional tags for the VPC. |

### Subnet configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | `list(object)` | no | – | Subnet definitions for the new VPC. |
| `↳ subnet_name` | `string` | yes | – | Subnet name (max 60 bytes). |
| `↳ subnet_cidr` | `string` | yes | – | Subnet CIDR block. |
| `↳ availability_zone` | `string` | no | – | Availability zone; if not set, randomly chosen from all. |
| `↳ subnet_is_multicast` | `bool` | no | `false` | Whether to enable multicast for the subnet. |
| `↳ tags` | `map(string)` | no | `{}` | Additional tags for the subnet. |

### CCN attachment configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_attach_ccn"></a> [attach\_ccn](#input\_attach\_ccn) | `bool` | no | `true` | Whether to attach this VPC to CCN. Set to `false` to skip attachment. |
| <a name="input_ccn_id"></a> [ccn\_id](#input\_ccn\_id) | `string` | no | `null` | The ID of the CCN instance to attach. |
| <a name="input_ccn_uin"></a> [ccn\_uin](#input\_ccn\_uin) | `string` | no | `null` | UIN of the CCN owner. If not set, uses the current account's UIN. Used for attaching a CCN of another account (only `VPC` instance type supported for now). |
| <a name="input_instance_region"></a> [instance\_region](#input\_instance\_region) | `string` | yes | – | The region of the VPC. |
| <a name="input_attachment_desc"></a> [attachment\_desc](#input\_attachment\_desc) | `string` | no | `null` | Description of the CCN attachment (max 100 bytes). |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | `string` | no | `null` | The ID of the CCN route table to associate the attachment with. |

> **Note**: CCN attachment is identified by `ccn_id` only (there is no `ccn_name` lookup). If `attach_ccn = true`, `ccn_id` and `instance_region` are required.

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC. |
| <a name="output_vpc_subnets"></a> [vpc\_subnets](#output\_vpc\_subnets) | The map of subnet definitions (name/CIDR/AZ/id, etc.). |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The ID of the VPC's default route table. |

---

## Configuration Examples

### `terraform.tfvars` – basic VPC and CCN attachment

```hcl
# VPC basic configuration
vpc_name        = "production-vpc"
vpc_cidr        = "10.0.0.0/16"
vpc_is_multicast = true
vpc_dns_servers = ["183.60.83.19", "183.60.82.98"]

vpc_tags = {
  Environment = "production"
  Project     = "ecommerce"
  ManagedBy   = "terraform"
}

tags = {
  NetworkTier = "core"
  SLA         = "99.9%"
}

# Subnet configuration
subnet_cidrs = [
  {
    subnet_name         = "web-subnet"
    subnet_cidr         = "10.0.1.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-3"
    tags                = { Tier = "web" }
  },
  {
    subnet_name         = "app-subnet"
    subnet_cidr         = "10.0.2.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-4"
  },
  {
    subnet_name         = "db-subnet"
    subnet_cidr         = "10.0.3.0/24"
    subnet_is_multicast = false
    availability_zone   = "ap-beijing-5"
  }
]

# CCN attachment configuration
attach_ccn      = true
ccn_id          = "ccn-abcdef"
instance_region = "ap-beijing"
attachment_desc = "Production VPC attached to CCN"
route_table_id  = "ccn-rtb-xxxxxx"
```

### Simple configuration (without routing table)

```hcl
# Basic VPC configuration
vpc_name = "development-vpc"
vpc_cidr = "192.168.0.0/16"

subnet_cidrs = [
  {
    subnet_name = "default-subnet"
    subnet_cidr = "192.168.1.0/24"
  }
]

# Attach to CCN using CCN ID only (default route table)
attach_ccn      = true
ccn_id          = "ccn-abcdef"
instance_region = "ap-shanghai"
attachment_desc = "Dev VPC attachment"
```

### Cross-account attachment

```hcl
# VPC configuration
vpc_name = "shared-services-vpc"
vpc_cidr = "172.16.0.0/16"

subnet_cidrs = [
  {
    subnet_name       = "shared-subnet-1"
    subnet_cidr       = "172.16.1.0/24"
    availability_zone = "ap-guangzhou-2"
  },
  {
    subnet_name       = "shared-subnet-2"
    subnet_cidr       = "172.16.2.0/24"
    availability_zone = "ap-guangzhou-3"
  }
]

# Cross-account CCN attachment
attach_ccn      = true
ccn_id          = "ccn-123456"
ccn_uin         = "123456789" # UIN of the other account owning the CCN
instance_region = "ap-guangzhou"
attachment_desc = "Cross-account shared services VPC attachment"
route_table_id  = "ccn-rtb-yyyyyy"

vpc_tags = {
  Environment  = "shared"
  BusinessUnit = "infrastructure"
  CostCenter   = "shared-services"
}
```

---

## Usage Examples

### Example 1: Production multi-subnet VPC attached to CCN

```hcl
vpc_name        = "prod-ecommerce-vpc"
vpc_cidr        = "10.100.0.0/16"
vpc_is_multicast = true

subnet_cidrs = [
  {
    subnet_name         = "prod-web-subnet"
    subnet_cidr         = "10.100.1.0/24"
    availability_zone   = "ap-beijing-3"
    subnet_is_multicast = true
    tags                = { Tier = "web" }
  },
  {
    subnet_name         = "prod-app-subnet"
    subnet_cidr         = "10.100.2.0/24"
    availability_zone   = "ap-beijing-4"
    subnet_is_multicast = true
    tags                = { Tier = "app" }
  },
  {
    subnet_name         = "prod-db-subnet"
    subnet_cidr         = "10.100.3.0/24"
    availability_zone   = "ap-beijing-5"
    subnet_is_multicast = false # multicast disabled for DB tier
    tags                = { Tier = "db" }
  }
]

attach_ccn      = true
ccn_id          = "ccn-prod-cross-region"
instance_region = "ap-beijing"
attachment_desc = "Production ecommerce VPC attached to cross-region CCN"
route_table_id  = "ccn-rtb-prod-main"

vpc_tags = {
  Environment = "production"
  Project     = "ecommerce"
  Tier        = "core"
  Owner       = "platform-team"
}

tags = {
  DataClassification = "restricted"
  Compliance         = "pci-dss"
}
```

### Example 2: Development simple VPC

```hcl
vpc_name = "dev-test-vpc"
vpc_cidr = "192.168.100.0/24"

subnet_cidrs = [
  {
    subnet_name = "dev-default-subnet"
    subnet_cidr = "192.168.100.0/24"
  }
]

attach_ccn      = true
ccn_id          = "ccn-dev-test"
instance_region = "ap-shanghai"
attachment_desc = "Dev test VPC attachment"

vpc_tags = {
  Environment = "development"
  Purpose     = "testing"
  CostCenter  = "rd"
}
```

### Example 3: Shared-services cross-account VPC

```hcl
vpc_name = "shared-infra-vpc"
vpc_cidr = "172.20.0.0/16"

subnet_cidrs = [
  {
    subnet_name       = "shared-networking-1"
    subnet_cidr       = "172.20.1.0/24"
    availability_zone = "ap-guangzhou-2"
  },
  {
    subnet_name       = "shared-networking-2"
    subnet_cidr       = "172.20.2.0/24"
    availability_zone = "ap-guangzhou-3"
  }
]

attach_ccn      = true
ccn_id          = "ccn-shared-services"
ccn_uin         = "987654321" # UIN of the CCN owner account
instance_region = "ap-guangzhou"
attachment_desc = "Shared infrastructure VPC cross-account attachment"
route_table_id  = "ccn-rtb-shared"

vpc_tags = {
  Environment  = "shared"
  BusinessUnit = "infrastructure"
  ServiceType  = "networking"
  CostModel    = "chargeback"
}
```

---

## Configuration Notes

### CCN attachment identification

- The CCN instance is identified by `ccn_id` only. There is **no** `ccn_name` lookup — always provide `ccn_id`.
- When `attach_ccn = true`, both `ccn_id` and `instance_region` are required.
- Set `attach_ccn = false` to create the VPC without attaching it to any CCN.

### Cross-account attachment

- To attach to a CCN owned by another account, set `ccn_uin` to that account's UIN.
- If `ccn_uin` is not set, the current account's UIN is used (same-account attachment).
- Only the `VPC` instance type is supported for cross-account attachment for now.
- The other account must have granted the attachment permission.

### Route table association

- Optional, enabled via `route_table_id`.
- Associates the VPC attachment with a specific CCN route table.
- If not set, the CCN default route table is used.

### Internal dependency order

1. The VPC and its subnets are created first.
2. CCN attachment is performed next (if `attach_ccn = true`).
3. Route table association is applied last (if `route_table_id` is set).

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Permissions**
   - Ensure the executing account has VPC and CCN management permissions (`QcloudVPCFullAccess`, `QcloudCCNFullAccess`).
   - Cross-account attachment requires additional permissions and the other account's authorization.

2. **Region consistency**
   - The VPC region (`instance_region`) must match the region of the attachment.
   - Use correct region codes such as `ap-beijing`.
   - Cross-region interconnection is achieved through CCN.

3. **CIDR planning**
   - Plan VPC and subnet CIDR blocks carefully to avoid conflicts.
   - Reserve enough IP address space.
   - Use standard CIDR notation.

4. **CCN identification**
   - Provide `ccn_id` (there is no `ccn_name` lookup).
   - Ensure the CCN instance exists and is in an available state.

5. **Cross-account attachment**
   - Provide the target account UIN via `ccn_uin`.
   - Confirm the other account has authorized the attachment.
   - Verify the network connectivity requirements.

6. **Route table association**
   - `route_table_id` is optional; ensure the route table exists and belongs to the target CCN.
   - Understand the impact of the route policy.

7. **Name length limits**
   - Subnet name ≤ 60 bytes.
   - CCN attachment description ≤ 100 bytes.

8. **Multicast configuration**
   - Multicast is enabled by default for the VPC (when `vpc_is_multicast = true`).
   - It can be disabled per subnet for security-sensitive tiers (e.g. databases).

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks VPC or CCN management permissions.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check `QcloudVPCFullAccess` and `QcloudCCNFullAccess` are included.

#### Error 2: CCN not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=CCN not found
```

**Cause**: The specified `ccn_id` does not exist.
**Solution**:
- Confirm the `ccn_id` is correct.
- Check whether the CCN has been deleted.
- Confirm the CCN is in an available state.

#### Error 3: Region mismatch

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region mismatch
```

**Cause**: The VPC region and the attachment region do not match.
**Solution**:
- Confirm `instance_region` is correct.
- Ensure the region code format is correct.

#### Error 4: CIDR conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=CIDR conflict
```

**Cause**: The CIDR block conflicts or is malformed.
**Solution**:
- Check the CIDR format.
- Ensure CIDR blocks do not overlap.
- Use standard CIDR notation.

#### Error 5: Cross-account operation not allowed

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=Cross account operation not allowed
```

**Cause**: Insufficient cross-account operation permission.
**Solution**:
- Confirm the target account has authorized the operation.
- Check the `ccn_uin` parameter is correct.
- Confirm the current account has attachment permission.

#### Error 6: Route table not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Route table not found
```

**Cause**: The specified route table does not exist.
**Solution**:
- Confirm the `route_table_id` is correct.
- Check the route table belongs to the specified CCN.
- Confirm the route table is available.

## License

See [LICENSE](../../../LICENSE) for full details.
