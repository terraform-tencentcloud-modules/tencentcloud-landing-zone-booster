# Tencent Cloud Organization Departments Component

Terraform component under `components/organization/departments` for creating and managing the Organization's department (node) structure, supporting a two-level (L1/L2) hierarchy, as part of the `organization` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates Organization department nodes and manages their parent-child hierarchy. Main features:

- **Multi-level department creation** – create Level-1 (L1) and Level-2 (L2) department nodes.
- **Hierarchy management** – parent-child relationships are handled automatically.
- **Node information** – configure node name, remark, and tags.
- **Flexible placement** – an optional `parent_id` lets an L1 node be created under a specific parent instead of the root.
- **Dependency handling** – node creation order dependencies are handled automatically.
- **ID mapping output** – output name → ID maps for both L1 and L2 nodes.
- **Batch operations** – configure multiple node levels at once.
- **Optional parameters** – optional fields and defaults supported.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.126 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.126 |

### IAM Permissions

The executing principal needs the following Tencent Cloud permissions:

| Permission | Description |
|------------|-------------|
| `QcloudOrganizationFullAccess` | Full access to Organization management |
| `QcloudOrganizationReadOnlyAccess` | Organization read-only access |

### Prerequisites

- Understand the Tencent Cloud Organization structure.
- Plan a department naming convention.
- Decide the department hierarchy.
- Prepare optional node remarks/tags.
- Note the node name → ID mapping produced by the module.

---

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_org_nodes"></a> [org\_nodes](#input\_org\_nodes) | `list(object)` | no | `[]` | Organization department (node) configuration list. |

### `org_nodes` object (L1 node)

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `parent_id` | `number` | no | `null` | Parent node ID. When omitted, the node is created directly under the root. |
| `name` | `string` | yes | – | Level-1 department name. |
| `remark` | `string` | no | – | Level-1 department remark. |
| `tags` | `map(string)` | no | – | Tags attached to the L1 node. |
| `sub_nodes` | `list(object)` | no | `[]` | Level-2 sub-node list. |

### `sub_nodes` object (L2 node)

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Level-2 department name. |
| `remark` | `string` | no | – | Level-2 department remark. |
| `tags` | `map(string)` | no | – | Tags attached to the L2 node. |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_l1_nodes"></a> [l1\_nodes](#output\_l1\_nodes) | Map of L1 node name → node ID. |
| <a name="output_l2_nodes"></a> [l2\_nodes](#output\_l2\_nodes) | Map of `L1/L2` name → node ID. |

---

## Configuration Examples

### `terraform.tfvars` – basic structure

```hcl
# Basic department structure configuration
org_nodes = [
  {
    name      = "Technology"
    remark    = "Responsible for R&D and operations"
    sub_nodes = [
      {
        name   = "Frontend Team"
        remark = "Frontend development"
      },
      {
        name   = "Backend Team"
        remark = "Backend development"
      },
      {
        name   = "Ops Team"
        remark = "System operations and deployment"
      }
    ]
  },

  {
    name      = "Product"
    remark    = "Product design and planning"
    sub_nodes = [
      {
        name   = "Product Design"
        remark = "UI and interaction design"
      },
      {
        name   = "Product Planning"
        remark = "Feature planning and requirements"
      }
    ]
  },

  {
    name      = "Marketing"
    remark    = "Marketing and branding"
    sub_nodes = [
      {
        name   = "Promotion"
        remark = "Online and offline campaigns"
      },
      {
        name   = "Branding"
        remark = "Brand building and maintenance"
      },
      {
        name   = "Customer Relations"
        remark = "Customer relationship management"
      }
    ]
  },

  {
    name      = "Finance"
    remark    = "Finance and treasury"
    sub_nodes = [] # no sub-nodes
  },

  {
    name      = "HR"
    remark    = "Recruiting and employee development"
    sub_nodes = [
      {
        name   = "Recruiting"
        remark = "Talent recruiting and interviews"
      },
      {
        name   = "Training"
        remark = "Employee training and career development"
      },
      {
        name   = "Compensation"
        remark = "Compensation and benefits"
      }
    ]
  }
]
```

### Multi-level structure configuration

```hcl
# Complex hierarchy department structure configuration
org_nodes = [
  {
    name      = "R&D Center"
    remark    = "Core technology R&D"
    sub_nodes = [
      {
        name   = "Platform R&D"
        remark = "Platform technology R&D"
      },
      {
        name   = "Application R&D"
        remark = "Business application R&D"
      },
      {
        name   = "Data R&D"
        remark = "Big data and AI R&D"
      },
      {
        name   = "QA"
        remark = "Software testing and QA"
      }
    ]
  },

  {
    name      = "Business Center"
    remark    = "Business operations"
    sub_nodes = [
      {
        name   = "E-commerce"
        remark = "E-commerce operations"
      },
      {
        name   = "Fintech"
        remark = "Fintech operations"
      },
      {
        name   = "Enterprise Services"
        remark = "Enterprise services"
      },
      {
        name   = "Overseas"
        remark = "Overseas market expansion"
      }
    ]
  },

  {
    name      = "Support Center"
    remark    = "Operations support"
    sub_nodes = [
      {
        name   = "Human Resources"
        remark = "Talent management and org development"
      },
      {
        name   = "Finance"
        remark = "Finance and treasury"
      },
      {
        name   = "Admin"
        remark = "Administration and office management"
      },
      {
        name   = "Legal"
        remark = "Legal and compliance"
      }
    ]
  },

  {
    name      = "Strategy"
    remark    = "Strategy and investment"
    sub_nodes = []
  },

  {
    name      = "Board Office"
    remark    = "Board affairs and governance"
    sub_nodes = []
  }
]
```

### Simple structure (small org)

```hcl
# Simple department structure (for small organizations)
org_nodes = [
  {
    name      = "Management"
    remark    = "Executive team"
    sub_nodes = []
  },

  {
    name      = "Engineering"
    remark    = "Development and operations"
    sub_nodes = [
      {
        name   = "Development"
        remark = "Software development"
      },
      {
        name   = "Operations"
        remark = "System operations"
      }
    ]
  },

  {
    name      = "Business"
    remark    = "Operations and customer service"
    sub_nodes = [
      {
        name   = "Sales"
        remark = "Product sales"
      },
      {
        name   = "Support"
        remark = "Customer service"
      }
    ]
  },

  {
    name      = "Back Office"
    remark    = "Admin and finance support"
    sub_nodes = [
      {
        name   = "Admin"
        remark = "Administration"
      },
      {
        name   = "Finance"
        remark = "Finance management"
      }
    ]
  }
]
```

### Internationalized structure

```hcl
# International department structure configuration
org_nodes = [
  {
    name      = "Headquarters"
    remark    = "Global headquarters management"
    sub_nodes = [
      {
        name   = "Executive Office"
        remark = "C-level management"
      },
      {
        name   = "Strategy Department"
        remark = "Corporate strategy planning"
      },
      {
        name   = "Finance Department"
        remark = "Global financial management"
      }
    ]
  },

  {
    name      = "Asia Pacific Region"
    remark    = "APAC business operations"
    sub_nodes = [
      {
        name   = "China Office"
        remark = "Mainland China operations"
      },
      {
        name   = "Japan Office"
        remark = "Japan market operations"
      },
      {
        name   = "Southeast Asia Office"
        remark = "SEA market operations"
      }
    ]
  },

  {
    name      = "Europe Region"
    remark    = "European business operations"
    sub_nodes = [
      {
        name   = "UK Office"
        remark = "United Kingdom operations"
      },
      {
        name   = "Germany Office"
        remark = "Germany market operations"
      },
      {
        name   = "France Office"
        remark = "France market operations"
      }
    ]
  },

  {
    name      = "North America Region"
    remark    = "NA business operations"
    sub_nodes = [
      {
        name   = "US Office"
        remark = "United States operations"
      },
      {
        name   = "Canada Office"
        remark = "Canada market operations"
      }
    ]
  }
]
```

### Using `parent_id` and `tags`

```hcl
# Create an L1 node under a specific parent (not the root), and tag nodes
org_nodes = [
  {
    name      = "Cloud Platform"
    remark    = "Cloud infrastructure department"
    tags = {
      "env"      = "production"
      "costcode" = "cloud-001"
    }
    sub_nodes = [
      {
        name   = "Networking"
        remark = "Network team"
        tags = {
          "team" = "netops"
        }
      },
      {
        name   = "Compute"
        remark = "Compute team"
      }
    ]
  },
  {
    # Place this node under an existing parent node by ID
    parent_id = 1000001234
    name      = "Security Sub-org"
    remark    = "Security org under a pre-existing parent"
    sub_nodes = [
      {
        name   = "Audit"
        remark = "Audit team"
      }
    ]
  }
]
```

---

## Usage Examples

### Example 1: Tech company structure

```hcl
# Typical tech company department structure
org_nodes = [
  {
    name      = "R&D Center"
    remark    = "Core R&D and innovation"
    sub_nodes = [
      {
        name   = "Infrastructure"
        remark = "Cloud-native and infra"
      },
      {
        name   = "Frontend"
        remark = "Web and mobile development"
      },
      {
        name   = "Backend"
        remark = "Server and API development"
      },
      {
        name   = "Data Intelligence"
        remark = "Big data and AI"
      },
      {
        name   = "QA"
        remark = "Quality assurance and testing"
      }
    ]
  },

  {
    name      = "Product Ops Center"
    remark    = "Product management and operations"
    sub_nodes = [
      {
        name   = "Product Management"
        remark = "Product planning and design"
      },
      {
        name   = "User Ops"
        remark = "User growth and operations"
      },
      {
        name   = "Data Ops"
        remark = "Data analytics and operations"
      },
      {
        name   = "Content Ops"
        remark = "Content creation and operations"
      }
    ]
  },

  {
    name      = "Business Development"
    remark    = "Business growth and partnerships"
    sub_nodes = [
      {
        name   = "Sales"
        remark = "Product sales and business"
      },
      {
        name   = "Channels"
        remark = "Channel management and partnerships"
      },
      {
        name   = "Key Accounts"
        remark = "Key account service"
      },
      {
        name   = "Partners"
        remark = "Ecosystem partners"
      }
    ]
  }
]
```

### Example 2: Financial institution structure

```hcl
# Financial institution department structure
org_nodes = [
  {
    name      = "Risk Committee"
    remark    = "Enterprise-wide risk management"
    sub_nodes = [
      {
        name   = "Credit Risk"
        remark = "Credit risk assessment"
      },
      {
        name   = "Market Risk"
        remark = "Market risk monitoring"
      },
      {
        name   = "Operational Risk"
        remark = "Operational risk control"
      },
      {
        name   = "Compliance"
        remark = "Compliance and audit"
      }
    ]
  },

  {
    name      = "Business Development"
    remark    = "Financial business expansion"
    sub_nodes = [
      {
        name   = "Retail"
        remark = "Personal finance"
      },
      {
        name   = "Corporate"
        remark = "Corporate finance"
      },
      {
        name   = "Investment Banking"
        remark = "IB business"
      },
      {
        name   = "Asset Management"
        remark = "Asset management and investment"
      }
    ]
  },

  {
    name      = "IT Department"
    remark    = "Fintech and IT"
    sub_nodes = [
      {
        name   = "System Dev"
        remark = "Financial system development"
      },
      {
        name   = "Data Center"
        remark = "Data management and analytics"
      },
      {
        name   = "Security"
        remark = "Information security"
      },
      {
        name   = "Ops Support"
        remark = "System ops support"
      }
    ]
  }
]
```

### Example 3: Education institution structure

```hcl
# Education institution department structure
org_nodes = [
  {
    name      = "Academic Affairs"
    remark    = "Teaching management and curriculum"
    sub_nodes = [
      {
        name   = "Curriculum Dev"
        remark = "Curriculum development"
      },
      {
        name   = "Teaching Quality"
        remark = "Teaching quality management"
      },
      {
        name   = "Faculty Dev"
        remark = "Faculty training and development"
      },
      {
        name   = "Research"
        remark = "Academic research and exchange"
      }
    ]
  },

  {
    name      = "Student Services"
    remark    = "Student service and management"
    sub_nodes = [
      {
        name   = "Admissions"
        remark = "Student admissions"
      },
      {
        name   = "Student Affairs"
        remark = "Daily student management"
      },
      {
        name   = "Career Center"
        remark = "Career guidance"
      },
      {
        name   = "Counseling"
        remark = "Mental health services"
      }
    ]
  },

  {
    name      = "Admin Support"
    remark    = "Admin and logistics support"
    sub_nodes = [
      {
        name   = "Finance Office"
        remark = "Finance management"
      },
      {
        name   = "HR Office"
        remark = "HR management"
      },
      {
        name   = "Logistics"
        remark = "Logistics services"
      },
      {
        name   = "IT Office"
        remark = "IT support"
      }
    ]
  }
]
```

---

## Configuration Notes

### Hierarchy

| Level | Description | Max depth | Note |
|-------|-------------|-----------|------|
| **Level-1 (L1)** | Top-level node directly under the root | Unlimited | Unlimited number of L1 nodes |
| **Level-2 (L2)** | Sub-node under an L1 node | Unlimited per L1 | Unlimited number of L2 nodes |

> With `parent_id` set, an L1 node can be created under a specific existing parent node instead of the root.

### Naming convention

| Item | Requirement | Example |
|------|-------------|---------|
| **Node name** | 2–64 characters; Chinese, English, digits, underscore supported | `Technology`, `R&D_Department` |
| **Node remark** | 0–128 characters; Chinese, English, digits, punctuation supported | `Responsible for R&D` |
| **Name uniqueness** | Node name must be unique within the same level | Two `Technology` nodes not allowed |

### Tags

Both L1 and L2 nodes accept a `tags` map (`map(string)`). Tags are useful for cost allocation, automation, and policy scoping.

### Outputs

The module outputs name → ID maps for both levels:

```hcl
# L1 node ID mapping
l1_nodes = {
  "Technology" = "org-node-12345678"
  "Product"    = "org-node-87654321"
  "Marketing"  = "org-node-abcdefgh"
}

# L2 node ID mapping (keyed by "L1/L2")
l2_nodes = {
  "Technology/Frontend Team" = "org-node-11111111"
  "Technology/Backend Team"  = "org-node-22222222"
  "Technology/Ops Team"      = "org-node-33333333"
  "Product/Product Design"   = "org-node-44444444"
  "Product/Product Planning" = "org-node-55555555"
}
```

### Dependency order

The module internally handles the following dependency order:
1. First create all Level-1 nodes.
2. Then create all Level-2 nodes.
3. Ensure L1 nodes are created before their L2 children.
4. Parent-child relationships are resolved automatically.

### Module architecture

```
Root
├── L1 Node 1
│   ├── L2 Node 1-1
│   ├── L2 Node 1-2
│   └── L2 Node 1-3
├── L1 Node 2
│   ├── L2 Node 2-1
│   └── L2 Node 2-2
└── L1 Node 3
    └── (no sub-nodes)
```

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Department planning**
   - Plan the department hierarchy in advance.
   - Define a naming convention.
   - Avoid duplicate node names.

2. **Dependency management**
   - The module handles creation order automatically.
   - Do not manually change the dependencies.
   - Ensure L1 nodes are created before L2 nodes.

3. **Naming convention**
   - Use meaningful node names.
   - Follow a consistent naming convention.
   - Avoid special characters.

4. **Hierarchy limit**
   - Currently a two-level (L1/L2) structure is supported.
   - More levels require custom extension.
   - Consider a flatter organization structure.

5. **ID management**
   - Node IDs are generated automatically by Tencent Cloud.
   - Retrieve them via the output variables.
   - Do not hard-code node IDs.

6. **Change management**
   - Renaming a node after creation is not recommended.
   - A node must be deleted before its children can be removed.
   - Define a department change process.

7. **Permission control**
   - Departments are used for permission grouping.
   - Combine with CAM policies for access control.
   - Follow the principle of least privilege.

8. **Monitoring & auditing**
   - Enable organization operation logs.
   - Periodically audit the department structure.
   - Monitor department change operations.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Duplicate node name

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Node name already exists
```

**Cause**: A duplicate node name exists at the same level.
**Solution**:
- Ensure node names are unique.
- Rename the duplicated node.
- Use a different name or add a suffix.

#### Error 2: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks Organization management permission.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check Organization management permission is included.
- Verify project permissions.

#### Error 3: Parent node not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Parent node not found
```

**Cause**: The parent of an L2 node does not exist.
**Solution**:
- Ensure the L1 node is configured correctly.
- Check the L1 node name spelling.
- Verify the dependency relationship.

#### Error 4: Invalid parameter format

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid parameter format
```

**Cause**: Node name or remark format is invalid.
**Solution**:
- Check node name length (2–64 chars).
- Check remark length (0–128 chars).
- Remove illegal characters.

#### Error 5: Quota exceeded

```
Error: [TencentCloudSDKError] Code=QuotaExceeded
Message=Node quota exceeded
```

**Cause**: The department/node quota limit has been reached.
**Solution**:
- Check the node quota limit.
- Request a quota increase or delete unused nodes.
- Merge similar departments.

#### Error 6: Dependency error

```
Error: [TencentCloudSDKError] Code=DependencyViolation
Message=Cannot create child node before parent
```

**Cause**: An L2 node was created before its L1 parent.
**Solution**:
- Ensure the dependency relationship is configured correctly.
- Check `depends_on` settings.
- Re-run `terraform apply`.

## License

See [LICENSE](../../../LICENSE) for full details.