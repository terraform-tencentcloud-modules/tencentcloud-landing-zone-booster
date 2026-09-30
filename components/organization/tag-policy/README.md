# Tencent Cloud Organization Tag Policy Component

Terraform component under `components/organization/tag-policy` for centrally managing Organization-level tag policies — creating unified tag governance policies and enforcing them across the Organization — as part of the `organization` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates and manages Organization-level tag policies, enabling automated governance and enforcement of tag conventions. Main features:

- **Tag policy creation** – create unified tag management policies.
- **Multi-target binding** – bind policies at department (node) and member level.
- **Automatic mapping** – automatically resolve name → ID mapping.
- **Policy enablement** – automatically enable the tag policy feature.
- **Batch management** – create and manage multiple policies in one batch.
- **Flexible configuration** – multiple configuration styles for different scenarios.
- **Dependency handling** – policy dependencies are handled automatically.
- **Unified governance** – centrally govern tag conventions across the Organization.

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
| `QcloudOrganizationFullAccess` | Full access to Organization management |
| `QcloudCamFullAccess` | Full access to CAM (access management) |
| `QcloudTagFullAccess` | Full access to Tag management |
| `QcloudFinanceFullAccess` | Full access to finance management |

### Prerequisites

- Understand the Organization structure and tag policy conventions.
- Plan the governance scope of tag policies.
- Decide the binding targets and levels (node/member).
- Prepare the tag policy file contents.
- Understand how policies take effect.
- Collect target IDs or exact names.

---

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | `string` | yes | – | Organization ID. |
| <a name="input_org_tag_policies"></a> [org\_tag\_policies](#input\_org\_tag\_policies) | `list(object)` | yes | – | Organization tag policy configuration list. |

### `org_tag_policies` object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Policy name (1–128 chars, supports Chinese, English, digits, and underscores). |
| `path` | `string` | yes | – | Policy file path. |
| `description` | `string` | no | `null` | Policy description. |
| `targets` | `list(object)` | yes | – | Policy binding target list. |

### `targets` object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `target_id` | `number` | conditional | `null` | Binding target ID (department ID or member UIN). Set one of `target_id` / `target_name`. |
| `target_name` | `string` | conditional | `null` | Binding target name (department name or member name). Set one of `target_id` / `target_name`. |
| `target_type` | `string` | yes | – | Target type. `NODE` = department; `MEMBER` = member. |

> Exactly one of `target_id` and `target_name` must be provided; do not set both or neither.

### Target types

| Target type | Description | Scenario | Management scope |
|-------------|-------------|----------|------------------|
| **NODE** | Department level | Unified tag convention for an entire department | All members and resources under the department |
| **MEMBER** | Member level | Tag convention for a specific member | All resources of the specified member |

### Outputs

This component declares **no outputs** (the policies and bindings are managed entirely via the inputs above).

---

## Configuration Examples

### `terraform.tfvars` – basic

```hcl
# Organization ID configuration
organization_id = "org-123456789"

# Department-level tag policy configuration
org_tag_policies = [
  # Development department tag policy
  {
    name        = "dev-department-tag-policy"
    path        = "./policies/dev-tags.json"
    description = "Unified tag convention for the development department"
    targets = [
      {
        target_name = "Development"  # department name
        target_type = "NODE"         # department level
      },
      {
        target_name = "QA"           # department name
        target_type = "NODE"         # department level
      }
    ]
  },

  # Production environment tag policy
  {
    name        = "prod-environment-tag-policy"
    path        = "./policies/prod-tags.json"
    description = "Resource tag convention for the production environment"
    targets = [
      {
        target_name = "Production"   # department name
        target_type = "NODE"         # department level
      },
      {
        target_name = "Ops"          # department name
        target_type = "NODE"         # department level
      }
    ]
  },

  # Finance-related tag policy
  {
    name        = "finance-tag-policy"
    path        = "./policies/finance-tags.json"
    description = "Cost-center tag convention for finance"
    targets = [
      {
        target_name = "Finance"      # department name
        target_type = "NODE"         # department level
      },
      {
        target_name = "Procurement"  # department name
        target_type = "NODE"         # department level
      }
    ]
  }
]
```

### Mixed target types

```hcl
# Organization ID configuration
organization_id = "org-987654321"

# Mix department- and member-level tag policies
org_tag_policies = [
  # Tech team unified tag policy
  {
    name        = "tech-team-tag-policy"
    path        = "./policies/tech-tags.json"
    description = "Resource tag convention for the tech team"
    targets = [
      {
        target_name = "Tech Center"      # department name
        target_type = "NODE"             # department level
      },
      {
        target_name = "R&D"              # department name
        target_type = "NODE"             # department level
      },
      {
        target_name = "Architecture"     # department name
        target_type = "NODE"             # department level
      }
    ]
  },

  # Key personnel special tag policy
  {
    name        = "key-personnel-tag-policy"
    path        = "./policies/key-personnel-tags.json"
    description = "Resource tag convention for key personnel"
    targets = [
      {
        target_name = "Tech Director"    # member name
        target_type = "MEMBER"           # member level
      },
      {
        target_name = "Security Lead"     # member name
        target_type = "MEMBER"           # member level
      },
      {
        target_name = "Finance Director" # member name
        target_type = "MEMBER"           # member level
      }
    ]
  },

  # Compliance & audit tag policy
  {
    name        = "compliance-tag-policy"
    path        = "./policies/compliance-tags.json"
    description = "Compliance & audit tag convention"
    targets = [
      {
        target_name = "Compliance"       # department name
        target_type = "NODE"             # department level
      },
      {
        target_name = "Audit Specialist" # member name
        target_type = "MEMBER"           # member level
      },
      {
        target_name = "Risk Control"     # department name
        target_type = "NODE"             # department level
      }
    ]
  }
]
```

### Using target IDs

```hcl
# Organization ID configuration
organization_id = "org-555555555"

# Use target IDs for precise configuration
org_tag_policies = [
  # Development environment tag policy
  {
    name        = "dev-env-tag-policy"
    path        = "./policies/dev-env-tags.json"
    description = "Resource tag convention for the dev environment"
    targets = [
      {
        target_id   = 1001   # development dept ID
        target_type = "NODE" # department level
      },
      {
        target_id   = 1002   # test dept ID
        target_type = "NODE" # department level
      },
      {
        target_id   = 1003   # pre-release dept ID
        target_type = "NODE" # department level
      }
    ]
  },

  # Production environment tag policy
  {
    name        = "prod-env-tag-policy"
    path        = "./policies/prod-env-tags.json"
    description = "Resource tag convention for production"
    targets = [
      {
        target_id   = 2001   # production dept ID
        target_type = "NODE" # department level
      },
      {
        target_id   = 2002   # ops dept ID
        target_type = "NODE" # department level
      },
      {
        target_id   = 2003   # monitoring dept ID
        target_type = "NODE" # department level
      }
    ]
  },

  # Management tag policy
  {
    name        = "management-tag-policy"
    path        = "./policies/management-tags.json"
    description = "Resource tag convention for management"
    targets = [
      {
        target_id   = 3001   # tech director UIN
        target_type = "MEMBER" # member level
      },
      {
        target_id   = 3002   # product director UIN
        target_type = "MEMBER" # member level
      },
      {
        target_id   = 3003   # operations director UIN
        target_type = "MEMBER" # member level
      }
    ]
  }
]
```

### Enterprise-grade tag policy

```hcl
# Organization ID configuration
organization_id = "org-999999999"

# Enterprise-grade fine-grained tag policy management
org_tag_policies = [
  # Cost-center tag policy
  {
    name        = "cost-center-tag-policy"
    path        = "./policies/cost-center-tags.json"
    description = "Cost-center resource tag convention"
    targets = [
      {
        target_name = "Finance Center"   # department name
        target_type = "NODE"             # department level
      },
      {
        target_name = "Procurement Center" # department name
        target_type = "NODE"             # department level
      },
      {
        target_name = "Budget Management" # department name
        target_type = "NODE"             # department level
      }
    ]
  },

  # Project team tag policy
  {
    name        = "project-team-tag-policy"
    path        = "./policies/project-team-tags.json"
    description = "Project team resource tag convention"
    targets = [
      {
        target_name = "Project A"     # department name
        target_type = "NODE"          # department level
      },
      {
        target_name = "Project B"     # department name
        target_type = "NODE"          # department level
      },
      {
        target_name = "Project C"     # department name
        target_type = "NODE"          # department level
      }
    ]
  },

  # Environment tag policy
  {
    name        = "environment-tag-policy"
    path        = "./policies/environment-tags.json"
    description = "Environment resource tag convention"
    targets = [
      {
        target_name = "Dev Environment"   # department name
        target_type = "NODE"              # department level
      },
      {
        target_name = "Test Environment"  # department name
        target_type = "NODE"              # department level
      },
      {
        target_name = "Prod Environment"  # department name
        target_type = "NODE"              # department level
      }
    ]
  },

  # Compliance & audit tag policy
  {
    name        = "compliance-audit-tag-policy"
    path        = "./policies/compliance-audit-tags.json"
    description = "Compliance & audit tag convention"
    targets = [
      {
        target_name = "Compliance"    # department name
        target_type = "NODE"          # department level
      },
      {
        target_name = "Audit"         # department name
        target_type = "NODE"          # department level
      },
      {
        target_name = "Risk Control"  # department name
        target_type = "NODE"          # department level
      }
    ]
  },

  # Executive tag policy
  {
    name        = "executive-tag-policy"
    path        = "./policies/executive-tags.json"
    description = "Executive resource tag convention"
    targets = [
      {
        target_name = "CEO"   # member name
        target_type = "MEMBER" # member level
      },
      {
        target_name = "CTO"   # member name
        target_type = "MEMBER" # member level
      },
      {
        target_name = "CFO"   # member name
        target_type = "MEMBER" # member level
      }
    ]
  }
]
```

---

## Usage Examples

### Example 1: Department-level tag policy

```hcl
# Department-wide tag policy configuration
org_tag_policies = [
  # Technology department tag convention
  {
    name        = "technology-department-tags"
    path        = "./policies/tech-dept-tags.json"
    description = "Unified resource tag convention for the technology department"
    targets = [
      {
        target_name = "R&D Center"   # R&D department
        target_type = "NODE"         # department level
      },
      {
        target_name = "QA"           # test department
        target_type = "NODE"         # department level
      },
      {
        target_name = "Tech Support" # ops department
        target_type = "NODE"         # department level
      }
    ]
  },

  # Business department tag convention
  {
    name        = "business-department-tags"
    path        = "./policies/business-dept-tags.json"
    description = "Unified resource tag convention for business departments"
    targets = [
      {
        target_name = "Sales"        # sales department
        target_type = "NODE"         # department level
      },
      {
        target_name = "Marketing"    # marketing department
        target_type = "NODE"         # department level
      },
      {
        target_name = "Customer Success" # customer service department
        target_type = "NODE"         # department level
      }
    ]
  },

  # Support department tag convention
  {
    name        = "support-department-tags"
    path        = "./policies/support-dept-tags.json"
    description = "Unified resource tag convention for support departments"
    targets = [
      {
        target_name = "HR"           # HR department
        target_type = "NODE"         # department level
      },
      {
        target_name = "Admin"        # admin department
        target_type = "NODE"         # department level
      },
      {
        target_name = "IT Support"   # IT support department
        target_type = "NODE"         # department level
      }
    ]
  }
]
```

### Example 2: Member-level tag policy

```hcl
# Per-member tag policy configuration
org_tag_policies = [
  # Developer tag convention
  {
    name        = "developer-tags"
    path        = "./policies/developer-tags.json"
    description = "Resource tag convention for developers"
    targets = [
      {
        target_name = "Zhang San"    # backend developer
        target_type = "MEMBER"       # member level
      },
      {
        target_name = "Li Si"        # frontend developer
        target_type = "MEMBER"       # member level
      },
      {
        target_name = "Wang Wu"      # full-stack developer
        target_type = "MEMBER"       # member level
      }
    ]
  },

  # Operations tag convention
  {
    name        = "operations-tags"
    path        = "./policies/operations-tags.json"
    description = "Resource tag convention for operations staff"
    targets = [
      {
        target_name = "Zhao Liu"     # systems ops
        target_type = "MEMBER"       # member level
      },
      {
        target_name = "Qian Qi"      # network ops
        target_type = "MEMBER"       # member level
      },
      {
        target_name = "Sun Ba"       # security ops
        target_type = "MEMBER"       # member level
      }
    ]
  },

  # Management tag convention
  {
    name        = "management-tags"
    path        = "./policies/management-tags.json"
    description = "Resource tag convention for management"
    targets = [
      {
        target_name = "Zhou Jiu"     # tech director
        target_type = "MEMBER"       # member level
      },
      {
        target_name = "Wu Shi"       # product director
        target_type = "MEMBER"       # member level
      },
      {
        target_name = "Zheng Shiyi"  # operations director
        target_type = "MEMBER"       # member level
      }
    ]
  }
]
```

### Example 3: Mixed-level tag policy

```hcl
# Mix department- and member-level tag policies
org_tag_policies = [
  # Project group tag convention
  {
    name        = "project-group-tags"
    path        = "./policies/project-group-tags.json"
    description = "Resource tag convention for project groups"
    targets = [
      {
        target_name = "E-commerce Project"  # project department
        target_type = "NODE"                # department level
      },
      {
        target_name = "Finance Project"     # project department
        target_type = "NODE"                # department level
      },
      {
        target_name = "Education Project"   # project department
        target_type = "NODE"                # department level
      }
    ]
  },

  # Environment tag convention
  {
    name        = "environment-tags"
    path        = "./policies/environment-tags.json"
    description = "Resource tag convention for environments"
    targets = [
      {
        target_name = "Dev Environment Group"  # environment department
        target_type = "NODE"                   # department level
      },
      {
        target_name = "Test Environment Group" # environment department
        target_type = "NODE"                   # department level
      },
      {
        target_name = "Prod Environment Group" # environment department
        target_type = "NODE"                   # department level
      }
    ]
  },

  # Key personnel tag convention
  {
    name        = "key-personnel-tags"
    path        = "./policies/key-personnel-tags.json"
    description = "Resource tag convention for key personnel"
    targets = [
      {
        target_name = "Architecture Team"  # architecture department
        target_type = "NODE"               # department level
      },
      {
        target_name = "Chief Architect"    # key person
        target_type = "MEMBER"            # member level
      },
      {
        target_name = "Security Expert"    # key person
        target_type = "MEMBER"            # member level
      }
    ]
  }
]
```

---

## Configuration Notes

### Target identification

The module supports two identification methods:

1. **By target name**
   - Use `target_name` to specify the target name.
   - The module queries and maps it to the corresponding target ID automatically.
   - Suitable when the name is known but the ID is not.
   - The target name must be unique in the Organization.

2. **By target ID**
   - Use `target_id` to specify the target ID.
   - The given ID is used directly for binding.
   - Suitable when the ID is known and precise control is required.
   - The ID must be correct and the target must exist.

### Policy levels

| Policy level | Management scope | Scenario | Advantage |
|--------------|------------------|----------|-----------|
| **Department level** | Entire department | Unified department tag convention | Batch management, high consistency |
| **Member level** | Single member | Personalized tag requirements | Fine-grained control, high flexibility |

### Automatic mapping

The module has a built-in automatic mapping:
- Queries all department information in the Organization.
- Queries all member information in the Organization.
- Builds a name → ID mapping table.
- Dynamically resolves target names.
- Handles the case where a target does not exist.
- Ensures accurate policy binding.

### Policy file format

The policy file must be valid JSON containing a complete tag policy definition:

```json
{
  "version": "1.0",
  "statement": [
    {
      "effect": "allow",
      "action": "tag:*",
      "resource": "*",
      "condition": {
        "for_all_value": {
          "tag:required": ["project", "environment", "owner"]
        }
      }
    }
  ]
}
```

### Best practices

1. **Tiered management**
   - Define policies by organization tier.
   - Avoid overly strict policies.
   - Periodically audit policy effectiveness.

2. **Naming convention**
   - Define a consistent policy naming convention.
   - Ensure policy name uniqueness.
   - Facilitate policy management and auditing.

3. **Policy grouping**
   - Group policies by function.
   - Manage similar policies centrally.
   - Avoid policy conflicts.

4. **Monitoring & audit**
   - Enable policy enforcement logs.
   - Periodically check policy compliance.
   - Revoke inappropriate policies promptly.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Target identification**
   - `target_id` and `target_name` are mutually exclusive (set exactly one).
   - Do not leave both empty or set both at once.
   - Ensure the identified target exists.

2. **Policy file**
   - Ensure the policy file path is correct.
   - Check that the policy file format is valid.
   - Confirm the policy content is effective.

3. **Permission verification**
   - Verify the target permissions before binding.
   - Ensure no permission conflicts are introduced.
   - Test that the policy takes effect.

4. **Name accuracy**
   - The target name must match exactly.
   - Name matching is case-sensitive.
   - Avoid ambiguous names.

5. **ID accuracy**
   - The target ID must be accurate.
   - Avoid using wrong IDs.
   - Periodically verify ID information.

6. **Policy limits**
   - Understand the policy count limits.
   - Note dependencies between policies.
   - Avoid conflicting configuration.

7. **Operation order**
   - Create the department/member before binding the policy.
   - Operate following dependency order.
   - Avoid circular dependencies.

8. **Backup & recovery**
   - Periodically back up policy configuration.
   - Prepare a recovery plan.
   - Test the recovery process.

9. **Change management**
   - Record all policy changes.
   - Notify affected parties.
   - Evaluate change impact.

10. **Compliance**
    - Comply with internal compliance requirements.
    - Meet industry regulatory requirements.
    - Perform periodic compliance checks.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Target not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Target not found
```

**Cause**: The specified target name or ID does not exist.
**Solution**:
- Check the target name spelling.
- Confirm the target ID is correct.
- Ensure the target is created in the Organization.

#### Error 2: Policy file not found

```
Error: [TerraformError] Code=FileNotFound
Message=Policy file not found
```

**Cause**: The specified policy file path does not exist.
**Solution**:
- Check the policy file path is correct.
- Confirm the file has been created.
- Ensure the file is readable.

#### Error 3: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=PermissionDenied
Message=Insufficient permissions
```

**Cause**: The current account lacks sufficient permissions.
**Solution**:
- Check the current account's permissions.
- Confirm it has policy management permission.
- Request the necessary permissions.

#### Error 4: Duplicate binding

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy already bound
```

**Cause**: The same policy is already bound to that target.
**Solution**:
- Check for duplicate configuration.
- Remove the duplicate binding entry.
- Confirm whether re-binding is needed.

#### Error 5: Parameter conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Parameter conflict
```

**Cause**: Both `target_id` and `target_name` are set.
**Solution**:
- Use only one identification method.
- Remove the conflicting parameter.
- Choose the preferred method.

#### Error 6: Policy limit exceeded

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Policy limit exceeded
```

**Cause**: The policy count limit has been reached.
**Solution**:
- Check the policy count limit.
- Reduce the policy count.
- Request a quota increase.

## License

See [LICENSE](../../../LICENSE) for full details.