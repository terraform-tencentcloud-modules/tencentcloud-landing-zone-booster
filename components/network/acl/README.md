# Tencent Cloud Network ACL Component

Terraform component under `components/network/acl` for creating and managing Network Access Control Lists (Network ACL) in Tencent Cloud VPC (Virtual Private Cloud). It implements VPC-level network security control as part of the `network` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates and manages network ACLs in a VPC, providing VPC-level network security control. Main features:

- **Batch ACL creation** – create multiple network ACLs at once.
- **Ingress rule management** – configure ingress traffic control rules.
- **Egress rule management** – configure egress traffic control rules.
- **VPC association** – associate ACLs via VPC ID or VPC name.
- **Tag management** – attach tags to ACLs for resource management.
- **Auto mapping** – automatically build a map from ACL name to ACL ID.

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
| `QcloudTagFullAccess` | Full access to Tag management |

### Prerequisites

- The target VPC must be created in advance.
- The VPC ID or VPC name must be obtained.
- The network ACL rule strategy must be planned.
- Knowledge of network protocols and port configuration is required.

---

## Inputs

### Network ACL configuration

| Name | Type | Required | Description |
|------|------|----------|-------------|
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | `list(object)` | no (default `[]`) | List of network ACLs to be created. |
| `↳ acl_name` | `string` | yes | Name of the network ACL. Must be unique within the VPC. |
| `↳ vpc_id` | `string` | no | VPC ID to associate the ACL with. |
| `↳ vpc_name` | `string` | no | VPC name to look up the VPC ID. |
| `↳ subnet_ids` | `list(string)` | no (default `[]`) | Subnet IDs to associate the ACL with. |
| `↳ ingress_rules` | `list(object)` | no (default `[]`) | Ingress rule list. |
| `↳↳ action` | `string` | yes | Action: `ACCEPT` (allow) or `DROP` (deny). |
| `↳↳ cidr` | `string` | yes | IP address network or CIDR segment. |
| `↳↳ port` | `string` | yes | Port, format: `80`, `80-90` or `ALL`. |
| `↳↳ protocol` | `string` | yes | Protocol: `TCP`, `UDP`, `ICMP` or `ALL`. When `ICMP`/`ALL`, `port` must be `ALL`. |
| `↳↳ desc` | `string` | yes | Rule description; must be uppercase. |
| `↳ egress_rules` | `list(object)` | no (default `[]`) | Egress rule list. |
| `↳↳ action` | `string` | yes | Action: `ACCEPT` (allow) or `DROP` (deny). |
| `↳↳ cidr` | `string` | yes | IP address network or CIDR segment. |
| `↳↳ port` | `string` | yes | Port, format: `80`, `80-90` or `ALL`. |
| `↳↳ protocol` | `string` | yes | Protocol: `TCP`, `UDP`, `ICMP` or `ALL`. When `ICMP`/`ALL`, `port` must be `ALL`. |
| `↳↳ desc` | `string` | yes | Rule description; must be uppercase. |
| `↳ tags` | `map(string)` | no | Tags of the network ACL. |

> **Note**: `vpc_id` and `vpc_name` cannot both be empty; if both are provided, `vpc_id` takes precedence.

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acl_ids"></a> [acl\_ids](#output\_acl\_ids) | The map of network ACL name to ACL ID. |

Example:

```hcl
acl_ids = {
  "web-tier-acl" = "acl-xxxxxx"
  "db-tier-acl"  = "acl-yyyyyy"
}
```

---

## Configuration Examples

### `terraform.tfvars` example

```hcl
# Network ACL configuration example
network_acls = [
  {
    acl_name = "web-tier-acl"
    vpc_name = "production-vpc"

    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "80"
        protocol = "TCP"
        desc     = "ALLOW HTTP FROM INTERNAL"
      },
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "443"
        protocol = "TCP"
        desc     = "ALLOW HTTPS FROM INTERNAL"
      },
      {
        action   = "DROP"
        cidr     = "0.0.0.0/0"
        port     = "ALL"
        protocol = "ALL"
        desc     = "DENY ALL OTHER TRAFFIC"
      }
    ]

    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "80"
        protocol = "TCP"
        desc     = "ALLOW HTTP TO INTERNET"
      },
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "443"
        protocol = "TCP"
        desc     = "ALLOW HTTPS TO INTERNET"
      }
    ]

    tags = {
      Environment = "production"
      Tier        = "web"
      ManagedBy   = "terraform"
    }
  },
  {
    acl_name = "db-tier-acl"
    vpc_id   = "vpc-xxxxxx"

    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.1.0/24"
        port     = "3306"
        protocol = "TCP"
        desc     = "ALLOW MYSQL FROM WEB TIER"
      },
      {
        action   = "DROP"
        cidr     = "0.0.0.0/0"
        port     = "ALL"
        protocol = "ALL"
        desc     = "DENY ALL OTHER TRAFFIC"
      }
    ]

    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.1.0/24"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW ALL TO WEB TIER"
      }
    ]
  }
]
```

### Simple configuration example

```hcl
# Basic configuration example
network_acls = [
  {
    acl_name = "basic-acl"
    vpc_name = "my-vpc"

    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW ALL INTERNAL TRAFFIC"
      }
    ]

    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW ALL OUTBOUND TRAFFIC"
      }
    ]
  }
]
```

---

## Usage Examples

### Example 1: Web-tier ACL

```hcl
# Web-tier network ACL configuration
network_acls = [
  {
    acl_name = "web-acl"
    vpc_name = "app-vpc"

    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "80"
        protocol = "TCP"
        desc     = "ALLOW HTTP FROM INTERNET"
      },
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "443"
        protocol = "TCP"
        desc     = "ALLOW HTTPS FROM INTERNET"
      },
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW ALL INTERNAL TRAFFIC"
      }
    ]

    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "80"
        protocol = "TCP"
        desc     = "ALLOW HTTP TO INTERNET"
      },
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "443"
        protocol = "TCP"
        desc     = "ALLOW HTTPS TO INTERNET"
      },
      {
        action   = "ACCEPT"
        cidr     = "10.0.1.0/24"
        port     = "3306"
        protocol = "TCP"
        desc     = "ALLOW MYSQL TO DB TIER"
      }
    ]

    tags = {
      Environment = "production"
      Tier        = "web"
    }
  }
]
```

### Example 2: Database-tier ACL

```hcl
# Database-tier network ACL configuration
network_acls = [
  {
    acl_name = "db-acl"
    vpc_id   = "vpc-abcdef"

    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/24"
        port     = "3306"
        protocol = "TCP"
        desc     = "ALLOW MYSQL FROM WEB TIER"
      },
      {
        action   = "ACCEPT"
        cidr     = "10.0.2.0/24"
        port     = "5432"
        protocol = "TCP"
        desc     = "ALLOW POSTGRES FROM APP TIER"
      },
      {
        action   = "DROP"
        cidr     = "0.0.0.0/0"
        port     = "ALL"
        protocol = "ALL"
        desc     = "DENY ALL OTHER TRAFFIC"
      }
    ]

    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW ALL INTERNAL TRAFFIC"
      }
    ]

    tags = {
      Environment = "production"
      Tier        = "database"
      DataClass   = "sensitive"
    }
  }
]
```

### Example 3: Batch multi-ACL configuration

```hcl
# Batch multi-ACL configuration example
network_acls = [
  # Web-tier ACL
  {
    acl_name = "web-acl"
    vpc_name = "multi-tier-vpc"

    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "80"
        protocol = "TCP"
        desc     = "ALLOW HTTP"
      },
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "443"
        protocol = "TCP"
        desc     = "ALLOW HTTPS"
      }
    ]

    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.1.0/24"
        port     = "3306"
        protocol = "TCP"
        desc     = "ALLOW DB ACCESS"
      }
    ]
  },

  # App-tier ACL
  {
    acl_name = "app-acl"
    vpc_name = "multi-tier-vpc"

    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/24"
        port     = "8080"
        protocol = "TCP"
        desc     = "ALLOW APP TRAFFIC"
      }
    ]

    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.2.0/24"
        port     = "5432"
        protocol = "TCP"
        desc     = "ALLOW DB ACCESS"
      }
    ]
  },

  # DB-tier ACL
  {
    acl_name = "db-acl"
    vpc_name = "multi-tier-vpc"

    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/24"
        port     = "3306"
        protocol = "TCP"
        desc     = "ALLOW MYSQL"
      },
      {
        action   = "ACCEPT"
        cidr     = "10.0.1.0/24"
        port     = "5432"
        protocol = "TCP"
        desc     = "ALLOW POSTGRES"
      }
    ]

    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW INTERNAL"
      }
    ]
  }
]
```

---

## Configuration Notes

### Rule format

A network ACL rule uses the following format: `[action]#[cidr]#[port]#[protocol]#[description]`

| Field | Description | Allowed values |
|-------|-------------|----------------|
| **action** | Action | `ACCEPT`, `DROP` |
| **cidr** | IP address / CIDR | Valid IP address or CIDR |
| **port** | Port range | `80`, `80-90`, `ALL` |
| **protocol** | Protocol | `TCP`, `UDP`, `ICMP`, `ALL` |
| **description** | Rule description | Must be uppercase |

### Protocol and port constraints

| Protocol | Port constraint | Description |
|----------|-----------------|-------------|
| `TCP` | Any port | Specific port or range |
| `UDP` | Any port | Specific port or range |
| `ICMP` | Must be `ALL` | ICMP has no port concept |
| `ALL` | Must be `ALL` | All protocols and ports |

### VPC association

Two association methods are supported:

- **VPC ID** – associate directly via VPC ID.
- **VPC name** – look up the VPC ID by name automatically.

> **Note**: `vpc_id` and `vpc_name` cannot both be empty. If both are provided, `vpc_id` takes precedence.

### Output mapping

The component automatically builds a map from ACL name to ACL ID:

```hcl
acl_ids = {
  "web-tier-acl" = "acl-xxxxxx"
  "db-tier-acl"  = "acl-yyyyyy"
}
```

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Permissions**
   - Ensure the executing account has VPC management permissions.
   - `QcloudVPCFullAccess` is required.

2. **VPC requirement**
   - The VPC must be created in advance.
   - Ensure the VPC ID or VPC name is correct.

3. **ACL name uniqueness**
   - The ACL name must be unique within the VPC.
   - Avoid reusing ACL names.

4. **Rule order**
   - ACL rules are evaluated in order.
   - The first matching rule decides how traffic is handled.
   - Arrange rules from specific to general.

5. **Protocol/port constraints**
   - ICMP protocol port must be `ALL`.
   - ALL protocol port must be `ALL`.
   - Violations cause creation to fail.

6. **Description format**
   - Rule descriptions must be uppercase.
   - English descriptions are recommended for easier management.

7. **Batch operations**
   - Multiple ACLs can be created in a batch.
   - Each ACL has its own rule configuration.
   - Group configurations by business tier.

8. **Tag management**
   - Tags can be attached to ACLs.
   - Useful for resource classification and management.
   - It is recommended to add environment, tier, etc.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks VPC management permissions.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check `QcloudVPCFullAccess` is included.

#### Error 2: VPC not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=VPC not found
```

**Cause**: The specified VPC ID or VPC name does not exist.
**Solution**:
- Confirm the VPC ID or VPC name is correct.
- Check whether the VPC has been deleted.

#### Error 3: Duplicate ACL name

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Network ACL name already exists
```

**Cause**: The ACL name already exists within the VPC.
**Solution**:
- Use a unique ACL name.
- Check for an existing ACL with the same name.
- Add a prefix or suffix to differentiate.

#### Error 4: Invalid rule format

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid rule format
```

**Cause**: The rule format does not meet the requirements.
**Solution**:
- Check the rule format.
- Verify protocol and port constraints.
- Ensure the description is uppercase.

#### Error 5: Protocol and port mismatch

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Protocol and port mismatch
```

**Cause**: The protocol and port configuration do not match.
**Solution**:
- ICMP protocol port must be `ALL`.
- ALL protocol port must be `ALL`.
- Adjust the protocol or port configuration.

#### Error 6: Invalid CIDR format

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid CIDR format
```

**Cause**: The CIDR format is incorrect.
**Solution**:
- Check the CIDR format.
- Ensure it is a valid IP address or segment.
- Use standard CIDR notation.

## License

See [LICENSE](../../../LICENSE) for full details.
