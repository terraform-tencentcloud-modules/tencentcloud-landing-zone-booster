# Tencent Cloud Security Group Management Component

Terraform component under `components/network/security-group` for creating and managing Tencent Cloud Security Groups (SG) in bulk, with flexible network access control policies. It is part of the `network` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates and manages multiple Security Groups and their inbound/outbound rules in a single pass. Main features:

- **Bulk Security Group creation** – create multiple security groups at once.
- **Ingress rule management** – configure inbound traffic access control policies.
- **Egress rule management** – configure outbound traffic access control policies.
- **Template-based configuration** – support address templates and service (protocol) templates.
- **Priority control** – rules are applied in configuration order; the first rule has the highest priority.
- **Tag management** – attach tags to each security group.
- **Project isolation** – isolate resources by project ID.
- **ID mapping output** – export a name-to-ID mapping of the created security groups.

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
| `QcloudSecurityGroupFullAccess` | Full access to Security Group management |
| `QcloudTagFullAccess` | Full access to Tag management |

### Prerequisites

- Plan a naming convention for your security groups.
- Understand your network access control requirements.
- Decide the priority order of your security group rules.
- Plan your tagging strategy.
- Know the target project ID if project isolation is required.

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security groups to be created. | <pre>list(object({<br>  name        = string<br>  project_id  = optional(number)<br>  description = optional(string)<br>  tags        = optional(map(string))<br>  ingress_rules = optional(list(object({<br>    action                 = string<br>    cidr_block             = optional(string)<br>    ipv6_cidr_block        = optional(string)<br>    protocol               = optional(string)<br>    port                   = optional(string)<br>    source_security_id     = optional(string)<br>    address_template_id    = optional(string)<br>    address_template_group = optional(string)<br>    service_template_id    = optional(string)<br>    service_template_group = optional(string)<br>    description            = optional(string)<br>  })), [])<br>  egress_rules = optional(list(object({<br>    action                 = string<br>    cidr_block             = optional(string)<br>    ipv6_cidr_block        = optional(string)<br>    protocol               = optional(string)<br>    port                   = optional(string)<br>    source_security_id     = optional(string)<br>    address_template_id    = optional(string)<br>    address_template_group = optional(string)<br>    service_template_id    = optional(string)<br>    service_template_group = optional(string)<br>    description            = optional(string)<br>  })), [])<br>}))</pre> | `[]` | no |

### `security_groups` object fields

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | `string` | yes | - | Name of the security group. |
| `project_id` | `number` | no | - | Project ID of the security group. |
| `description` | `string` | no | - | Description of the security group. |
| `tags` | `map(string)` | no | `{}` | Tags of the security group. |
| `ingress_rules` | `list(object)` | no | `[]` | List of ingress rules. |
| `egress_rules` | `list(object)` | no | `[]` | List of egress rules. |

### Rule object fields (ingress / egress)

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `action` | `string` | yes | - | Rule policy: `ACCEPT` or `DROP`. |
| `cidr_block` | `string` | no | - | An IPv4 address network or CIDR segment. |
| `ipv6_cidr_block` | `string` | no | - | An IPv6 address network or CIDR segment. |
| `protocol` | `string` | no | `ALL` | Protocol type: `TCP`, `UDP`, `ICMP`, `ICMPv6`, `ALL`. Conflicts with `service_template_*`. |
| `port` | `string` | no | `all` | Port range: `all`, a single port, or a port range (e.g. `80`, `80,90`, `80-90`). Conflicts with `service_template_*`. |
| `source_security_id` | `string` | no | - | ID of a nested (referenced) security group. |
| `address_template_id` | `string` | no | - | Address template ID (e.g. `ipm-xxxxxxxx`). |
| `address_template_group` | `string` | no | - | Address template group ID (e.g. `ipmg-xxxxxxxx`). |
| `service_template_id` | `string` | no | - | Service (protocol) template ID (e.g. `ppm-xxxxxxxx`). |
| `service_template_group` | `string` | no | - | Service (protocol) template group ID (e.g. `ppmg-xxxxxxxx`). |
| `description` | `string` | no | - | Description of the rule. |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | The id of security groups (map of security group name to ID). |

---

## Configuration Examples

### `terraform.tfvars` example

```hcl
# Basic security group configuration
security_groups = [
  {
    name        = "web-servers"
    description = "Security group for web servers"
    project_id  = 123456
    tags = {
      Environment = "production"
      Role        = "web"
      ManagedBy   = "terraform"
    }

    # Ingress rules
    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Allow HTTP access from anywhere"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Allow HTTPS access from anywhere"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "22"
        description = "Allow SSH access from internal network"
      }
    ]

    # Egress rules
    egress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "ALL"
        port        = "all"
        description = "Allow all outbound traffic"
      }
    ]
  },

  {
    name        = "database-servers"
    description = "Security group for database servers"
    tags = {
      Environment = "production"
      Role        = "database"
    }

    # Ingress rules
    ingress_rules = [
      {
        action              = "ACCEPT"
        source_security_id  = "sg-web-servers" # reference another security group by ID
        protocol            = "TCP"
        port                = "3306"
        description         = "Allow MySQL access from web servers"
      },
      {
        action              = "ACCEPT"
        source_security_id  = "sg-app-servers" # reference another security group by ID
        protocol            = "TCP"
        port                = "5432"
        description         = "Allow PostgreSQL access from app servers"
      }
    ]

    # Egress rules
    egress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Allow HTTP outbound for updates"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Allow HTTPS outbound for updates"
      }
    ]
  }
]
```

### Template-based configuration example

```hcl
# Security group using address and service templates
security_groups = [
  {
    name        = "template-based-sg"
    description = "Security group using templates"

    ingress_rules = [
      {
        action               = "ACCEPT"
        address_template_id  = "ipm-12345678"  # address template ID
        service_template_id  = "ppm-87654321"  # service (protocol) template ID
        description          = "Allow access based on address and service templates"
      }
    ],

    egress_rules = [
      {
        action                 = "ACCEPT"
        address_template_group = "ipmg-abcdefgh"  # address template group ID
        service_template_group = "ppmg-hgfedcba"  # service (protocol) template group ID
        description            = "Allow outbound based on template groups"
      }
    ]
  }
]
```

### IPv6 configuration example

```hcl
# Security group with IPv6 support
security_groups = [
  {
    name        = "ipv6-enabled-sg"
    description = "Security group with IPv6 support"

    ingress_rules = [
      {
        action          = "ACCEPT"
        ipv6_cidr_block = "2001:db8::/32"
        protocol        = "TCP"
        port            = "80"
        description     = "Allow HTTP from IPv6 network"
      },
      {
        action          = "ACCEPT"
        ipv6_cidr_block = "2001:db8::/32"
        protocol        = "TCP"
        port            = "443"
        description     = "Allow HTTPS from IPv6 network"
      }
    ],

    egress_rules = [
      {
        action          = "ACCEPT"
        ipv6_cidr_block = "::/0"
        protocol        = "ALL"
        port            = "all"
        description     = "Allow all IPv6 outbound traffic"
      }
    ]
  }
]
```

### Multi-environment configuration example

```hcl
# Security groups for multiple environments
security_groups = [
  # Development
  {
    name        = "dev-web-sg"
    description = "Development web servers security group"
    tags = {
      Environment = "development"
      Role        = "web"
    }

    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "80"
        description = "Dev HTTP access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "443"
        description = "Dev HTTPS access"
      }
    ]
  },

  # Testing
  {
    name        = "test-web-sg"
    description = "Testing web servers security group"
    tags = {
      Environment = "testing"
      Role        = "web"
    }

    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "10.1.0.0/16"
        protocol    = "TCP"
        port        = "80"
        description = "Test HTTP access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.1.0.0/16"
        protocol    = "TCP"
        port        = "443"
        description = "Test HTTPS access"
      }
    ]
  },

  # Production
  {
    name        = "prod-web-sg"
    description = "Production web servers security group"
    tags = {
      Environment = "production"
      Role        = "web"
      SLA         = "99.95%"
    }

    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Prod HTTP access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Prod HTTPS access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.2.0.0/16"
        protocol    = "TCP"
        port        = "22"
        description = "Prod SSH access from internal"
      }
    ]
  }
]
```

---

## Usage Examples

### Example 1: Web application security group

```hcl
security_groups = [
  {
    name        = "web-application-sg"
    description = "Security group for web application servers"
    project_id  = 1001
    tags = {
      Environment = "production"
      Application = "ecommerce"
      Tier        = "web"
    }

    # Ingress - external access
    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Public HTTP access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Public HTTPS access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "22"
        description = "SSH from internal network"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "8080"
        description = "Internal application port"
      }
    ]

    # Egress
    egress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Outbound HTTP"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Outbound HTTPS"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "3306"
        description = "Database access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "6379"
        description = "Redis access"
      }
    ]
  }
]
```

### Example 2: Database security group

```hcl
security_groups = [
  {
    name        = "database-sg"
    description = "Security group for database servers"
    project_id  = 1001
    tags = {
      Environment = "production"
      Application = "ecommerce"
      Tier        = "database"
    }

    # Ingress - only allow specific security groups
    ingress_rules = [
      {
        action              = "ACCEPT"
        source_security_id  = "sg-web-application"  # web app security group ID
        protocol            = "TCP"
        port                = "3306"
        description         = "MySQL access from web servers"
      },
      {
        action              = "ACCEPT"
        source_security_id  = "sg-application"      # app server security group ID
        protocol            = "TCP"
        port                = "3306"
        description         = "MySQL access from app servers"
      },
      {
        action              = "ACCEPT"
        source_security_id  = "sg-bastion"          # bastion security group ID
        protocol            = "TCP"
        port                = "22"
        description         = "SSH access from bastion"
      }
    ]

    # Egress - restricted outbound
    egress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "53"
        description = "DNS queries"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Package updates"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Secure package updates"
      }
    ]
  }
]
```

### Example 3: Bastion host security group

```hcl
security_groups = [
  {
    name        = "bastion-sg"
    description = "Security group for bastion host"
    project_id  = 1001
    tags = {
      Environment = "production"
      Role        = "bastion"
      Access      = "restricted"
    }

    # Ingress - strictly limited
    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "203.0.113.0/24"  # corporate office network
        protocol    = "TCP"
        port        = "22"
        description = "SSH from office network"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "198.51.100.0/24" # VPN network
        protocol    = "TCP"
        port        = "22"
        description = "SSH from VPN network"
      }
    ]

    # Egress - allow access to all internal services
    egress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "22"
        description = "SSH to all internal servers"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "3389"
        description = "RDP to Windows servers"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "5985"
        description = "WinRM access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "all"
        description = "All protocols to internal network"
      }
    ]
  }
]
```

---

## Configuration Notes

### Rule priority

Security group rules are applied in configuration order; **the first rule has the highest priority**. Matching is sequential and stops at the first match.

### Exclusive source / port fields

The following source fields are mutually exclusive and cannot be set together. **Exactly one** of them must be provided:
- `cidr_block` – IPv4 address network or CIDR segment
- `ipv6_cidr_block` – IPv6 address network or CIDR segment
- `source_security_id` – nested security group ID
- `address_template_id` – address template ID
- `address_template_group` – address template group ID

Similarly, `protocol` / `port` and `service_template_*` are mutually exclusive:
- Use `protocol` + `port` for literal protocol/port rules, **or**
- Use `service_template_id` / `service_template_group` for template-based protocol/port rules.

### Protocol and port

- **Protocol**: `TCP`, `UDP`, `ICMP`, `ICMPv6`, `ALL`.
- **Port**: `all`, a single port (e.g. `80`), a port range (e.g. `80-90`), or a port list (e.g. `80,90`).
- **Special rule**: if `protocol` is set to `ALL`, `port` must also be set to `all`.

### Templates

| Template type | Format | Description |
|---------------|--------|-------------|
| Address template | `ipm-xxxxxxxx` | Predefined set of IP addresses |
| Address template group | `ipmg-xxxxxxxx` | Group of address templates |
| Service (protocol) template | `ppm-xxxxxxxx` | Predefined protocol/port combination |
| Service (protocol) template group | `ppmg-xxxxxxxx` | Group of service templates |

### Output

The component outputs a name-to-ID mapping of the created security groups:

```hcl
security_group_ids = {
  "web-servers"      = "sg-12345678"
  "database-servers" = "sg-87654321"
  "bastion-sg"       = "sg-abcdefgh"
}
```

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Rule priority**
   - Rules are applied in configuration order; the first rule has the highest priority.
   - Plan rule order carefully to avoid unintended access control.
   - Place `DROP` rules last.

2. **Source configuration**
   - Set exactly one source field per rule.
   - Use correct network masks in CIDR blocks.
   - `source_security_id` must reference an existing security group.

3. **Protocol and port**
   - When `protocol` is `ALL`, `port` must be `all`.
   - Use a hyphen for port ranges (e.g. `80-90`).
   - Use commas for port lists (e.g. `80,443`).

4. **Templates**
   - Ensure template IDs are correct and exist.
   - Templates and literal protocol/port configs are mutually exclusive.
   - Understand the template contents and usage limits.

5. **Security best practices**
   - Follow the principle of least privilege.
   - Regularly review and clean up security group rules.
   - Use the `description` field to record each rule's purpose.
   - Implement network segmentation and isolation.

6. **Performance**
   - The number of rules affects network performance.
   - Plan the rule count reasonably; avoid excessive rules.
   - Consider Network ACLs for coarse-grained control.

7. **Change management**
   - Record all security group changes.
   - Test the impact of rule changes on your workloads.
   - Prepare a rollback plan.

8. **Monitoring & auditing**
   - Enable security group flow logs.
   - Monitor for anomalous access patterns.
   - Perform periodic security audits.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Conflicting source types

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Conflict address source types
```

**Cause**: Multiple source types set in the same rule.
**Solution**:
- Check the rule config and set only one source type.
- Remove the conflicting source config.
- Re-plan the source selection.

#### Error 2: Protocol/port mismatch

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Protocol and port mismatch
```

**Cause**: `protocol` is `ALL` but `port` is not `all`.
**Solution**:
- Set `port = "all"` when `protocol = "ALL"`, or
- Choose a specific protocol type.

#### Error 3: Security group not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Security group not found
```

**Cause**: The referenced nested security group does not exist.
**Solution**:
- Verify the referenced security group ID is correct.
- Ensure the referenced security group was created (e.g. in the same `security_groups` list or a prior step).
- Check the security group name spelling.

#### Error 4: Template not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Template not found
```

**Cause**: The referenced template ID does not exist.
**Solution**:
- Verify the template ID is correct.
- Check that the template was created.
- Validate template permissions.

#### Error 5: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks the required permissions.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Ensure Security Group management permissions are included.
- Verify project permissions (if `project_id` is set).

#### Error 6: Quota exceeded

```
Error: [TencentCloudSDKError] Code=QuotaExceeded
Message=Security group quota exceeded
```

**Cause**: Reached the security group or rule quota limit.
**Solution**:
- Check the security group and rule quotas.
- Request a quota increase or delete unused resources.
- Consolidate similar security group rules.

## License

See [LICENSE](../../../LICENSE) for full details.