# Tencent Cloud Organization CIC Role Component

Terraform component under `components/organization/cic-role` for creating, configuring, and assigning **Cloud Identity Center (CIC / Identity Center)** role configurations to organization member accounts, as part of the `organization` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component manages Identity Center **Role Configurations** (access configurations) and syncs them to member (or manager) accounts by creating role assignments. Main features:

- **Role configuration creation** – create multiple CIC role configurations (access configurations) in one batch.
- **Policy management** – attach both preset managed policies and custom (JSON document) policies to each role configuration.
- **Session control** – configure the session duration for assumed roles.
- **Role assignment** – sync a role configuration to target accounts by assigning it to a CIC user or group.
- **Flexible targeting** – identify the target account by either account name (resolved to UIN automatically) or UIN directly.
- **Deprovision strategy** – control what happens when the last role assignment on an account is removed.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.136 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.136 |

### IAM Permissions

The executing principal needs permissions to manage Identity Center, such as:

| Permission | Description |
|------------|-------------|
| `QcloudOrganizationFullAccess` | Full access to Organization management |
| `QcloudCamFullAccess` | Full access to CAM (access management) |
| Identity Center admin / `QcloudOrganizationReadOnlyAccess` | Identity Center management & Organization read-only |

### Prerequisites

- Identity Center must be **enabled** for the organization, and the `zone_id` (Zone ID) obtained in advance.
- Plan role configuration names and the preset/custom policies to attach.
- Collect the CIC **User IDs** (`u-******`) or **Group IDs** (`g-******`) to assign roles to.
- Collect the target account UINs (or account names) within the organization.

---

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | `string` | yes | – | Identity Center Zone ID. |
| <a name="input_role_config"></a> [role\_config](#input\_role\_config) | `list(object)` | no | `[]` | Identity Center role configuration list. |
| <a name="input_session_duration"></a> [session\_duration](#input\_session\_duration) | `number` | no | `7200` | Session duration in seconds (range 900–43200). Default 7200 (2 hours). |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | `list(object)` | no | `[]` | Role assignments that sync roles to member accounts. |

### `role_config` object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `role_name` | `string` | yes | – | Access configuration (role) name. |
| `description` | `string` | no | – | Access configuration description. |
| `relay_state` | `string` | no | – | Initial access page (relay state). |
| `preset_policy_names` | `list(string)` | no | – | List of preset (managed) policy names to attach. |
| `custom_policies` | `list(object)` | no | – | List of custom policies to attach. Each item has `name` (string) and `policy_document` (string, CAM JSON). |

### `role_assignments` object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `role_name` | `string` | yes | – | Role configuration name. Must match a `role_config.role_name`. |
| `principal_id` | `string` | yes | – | CIC user ID (`u-******`) or group ID (`g-******`). |
| `principal_type` | `string` | yes | – | Principal type: `User` or `Group`. |
| `target_name` | `string` | conditional | – | Target account name (the module looks up the UIN from organization members). Use this or `target_uin`. |
| `target_uin` | `number` | conditional | – | Target account UIN. Required if `target_name` is not provided. |
| `target_type` | `string` | yes | – | Target type: `ManagerUin` or `MemberUin`. |
| `deprovision_strategy` | `string` | no | `None` | `DeprovisionForLastRoleAssignmentOnAccount` or `None` (default). |

> **Note**: Within a single `role_assignments` entry, provide **either** `target_name` **or** `target_uin` (the module resolves the account UIN automatically when `target_name` is given).

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cic_roles"></a> [cic\_roles](#output\_cic\_roles) | Map of role configuration name → role configuration ID. |
| <a name="output_preset_policy_attachments"></a> [preset\_policy\_attachments](#output\_preset\_policy\_attachments) | Map of preset policy attachment keys → attachment IDs. |
| <a name="output_custom_policy_attachments"></a> [custom\_policy\_attachments](#output\_custom\_policy\_attachments) | Map of custom policy attachment keys → attachment IDs. |

---

## Configuration Examples

### `terraform.tfvars` – basic role configurations

```hcl
# Identity Center Zone ID (from the enabled Identity Center)
zone_id = "z-xxxxxx1234567890"

# Session duration: 1 hour (3600s), valid range 900-43200
session_duration = 3600

# Define role configurations (access configurations)
role_config = [
  {
    role_name   = "admin-role"
    description = "Administrator role with full access"
    relay_state = "https://console.cloud.tencent.com/"

    # Attach preset managed policies
    preset_policy_names = [
      "QcloudCamFullAccess",
      "QcloudOrganizationFullAccess"
    ]
  },
  {
    role_name   = "developer-role"
    description = "Developer role with limited access"

    # Mix preset and custom policies
    preset_policy_names = [
      "QcloudCamReadOnlyAccess"
    ]
    custom_policies = [
      {
        name            = "developer-custom-policy"
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cvm:DescribeInstances",
                "cvm:RunInstances",
                "cvm:TerminateInstances"
              ],
              "resource": "*"
            }
          ]
        }
        EOT
      }
    ]
  },
  {
    role_name   = "audit-role"
    description = "Audit role with read-only access"

    preset_policy_names = [
      "QcloudCamReadOnlyAccess",
      "QcloudOrganizationReadOnlyAccess"
    ]
  }
]

# Sync roles to target accounts
role_assignments = [
  {
    role_name      = "admin-role"
    principal_id   = "u-admin1234567" # CIC user ID
    principal_type = "User"
    target_uin     = 100000000001    # target account UIN
    target_type    = "MemberUin"
  },
  {
    role_name      = "developer-role"
    principal_id   = "g-devteam98765" # CIC group ID
    principal_type = "Group"
    target_name    = "dev-account"   # resolved to UIN automatically
    target_type    = "MemberUin"
  },
  {
    role_name             = "audit-role"
    principal_id          = "u-audit1234567"
    principal_type        = "User"
    target_name           = "audit-account"
    target_type           = "MemberUin"
    deprovision_strategy  = "DeprovisionForLastRoleAssignmentOnAccount"
  }
]
```

### Multi-environment configuration

```hcl
zone_id = "z-xxxxxx1234567890"

role_config = [
  # Development environment role
  {
    role_name   = "dev-developer"
    description = "Developer role for development environment"

    preset_policy_names = ["QcloudCamReadOnlyAccess"]
    custom_policies = [
      {
        name            = "dev-custom-policy"
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": ["cvm:*", "vpc:*", "clb:*"],
              "resource": [
                "qcs::cvm:ap-guangzhou::instance/*",
                "qcs::vpc:ap-guangzhou::vpc/*",
                "qcs::clb:ap-guangzhou::clb/*"
              ]
            }
          ]
        }
        EOT
      }
    ]
  },

  # Production environment role
  {
    role_name   = "prod-operator"
    description = "Operator role for production environment"

    preset_policy_names = ["QcloudCamReadOnlyAccess"]
    custom_policies = [
      {
        name            = "prod-custom-policy"
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": ["cvm:Describe*", "vpc:Describe*", "clb:Describe*"],
              "resource": "*"
            },
            {
              "effect": "allow",
              "action": ["cvm:RunInstances", "cvm:StopInstances", "cvm:StartInstances"],
              "resource": "qcs::cvm:ap-beijing::instance/*",
              "condition": {
                "string_equal": {
                  "cvm:ResourceTag/Environment": "production"
                }
              }
            }
          ]
        }
        EOT
      }
    ]
  }
]

role_assignments = [
  {
    role_name      = "dev-developer"
    principal_id   = "u-devuser12345"
    principal_type = "User"
    target_name    = "dev-account"
    target_type    = "MemberUin"
  },
  {
    role_name      = "prod-operator"
    principal_id   = "u-produser6789"
    principal_type = "User"
    target_uin     = 100000000004
    target_type    = "MemberUin"
  }
]
```

### Fine-grained permission configuration

```hcl
zone_id = "z-xxxxxx1234567890"

role_config = [
  {
    role_name   = "network-admin"
    description = "Network administrator role"

    preset_policy_names = [
      "QcloudVPCFullAccess",
      "QcloudEIPFullAccess",
      "QcloudCLBFullAccess"
    ]
  },
  {
    role_name   = "database-admin"
    description = "Database administrator role"

    preset_policy_names = [
      "QcloudCDBFullAccess",
      "QcloudRedisFullAccess",
      "QcloudMongoDBFullAccess"
    ]
  },
  {
    role_name   = "security-auditor"
    description = "Security auditor role"

    preset_policy_names = [
      "QcloudCamReadOnlyAccess",
      "QcloudOrganizationReadOnlyAccess"
    ]
    custom_policies = [
      {
        name            = "security-audit-policy"
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": ["cam:Get*", "cam:List*", "organization:Get*", "organization:List*"],
              "resource": "*"
            }
          ]
        }
        EOT
      }
    ]
  }
]

role_assignments = [
  {
    role_name      = "network-admin"
    principal_id   = "u-netadmin1234"
    principal_type = "User"
    target_name    = "network-account"
    target_type    = "MemberUin"
  },
  {
    role_name      = "database-admin"
    principal_id   = "u-dbadmin12345"
    principal_type = "User"
    target_uin     = 100000000002
    target_type    = "MemberUin"
  },
  {
    role_name      = "security-auditor"
    principal_id   = "g-secgroup6789"
    principal_type = "Group"
    target_name    = "security-account"
    target_type    = "MemberUin"
  }
]
```

---

## Usage Examples

### Example 1: Basic administrator role

```hcl
zone_id = "z-xxxxxx1234567890"

role_config = [
  {
    role_name   = "system-administrator"
    description = "System administrator with full organization access"

    preset_policy_names = [
      "QcloudOrganizationFullAccess",
      "QcloudCamFullAccess",
      "QcloudFinanceFullAccess"
    ]
  }
]

role_assignments = [
  {
    role_name      = "system-administrator"
    principal_id   = "u-sysadmin1234"
    principal_type = "User"
    target_uin     = 100000000001
    target_type    = "MemberUin"
  }
]
```

### Example 2: Project developer role

```hcl
zone_id = "z-xxxxxx1234567890"

role_config = [
  {
    role_name   = "project-developer"
    description = "Developer role for specific project access"

    preset_policy_names = ["QcloudCamReadOnlyAccess"]
    custom_policies = [
      {
        name            = "project-dev-policy"
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": ["cvm:*", "vpc:*", "clb:*"],
              "resource": [
                "qcs::cvm:ap-guangzhou::instance/*",
                "qcs::vpc:ap-guangzhou::vpc/*",
                "qcs::clb:ap-guangzhou::clb/*"
              ],
              "condition": {
                "string_equal": {
                  "cvm:ResourceTag/Project": "my-project"
                }
              }
            }
          ]
        }
        EOT
      }
    ]
  }
]

role_assignments = [
  {
    role_name      = "project-developer"
    principal_id   = "u-devjohn1234"
    principal_type = "User"
    target_name    = "dev-account"
    target_type    = "MemberUin"
  },
  {
    role_name      = "project-developer"
    principal_id   = "u-devjane5678"
    principal_type = "User"
    target_name    = "dev-account"
    target_type    = "MemberUin"
  }
]
```

### Example 3: Finance auditor role

```hcl
zone_id = "z-xxxxxx1234567890"

role_config = [
  {
    role_name   = "finance-auditor"
    description = "Finance auditor with billing and cost access"

    preset_policy_names = [
      "QcloudFinanceReadOnlyAccess",
      "QcloudCamReadOnlyAccess"
    ]
    custom_policies = [
      {
        name            = "finance-audit-policy"
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": ["finance:Describe*", "finance:Get*"],
              "resource": "*"
            }
          ]
        }
        EOT
      }
    ]
  }
]

role_assignments = [
  {
    role_name      = "finance-auditor"
    principal_id   = "u-financeaudit1"
    principal_type = "User"
    target_uin     = 100000000005
    target_type    = "MemberUin"
  }
]
```

---

## Configuration Notes

### Policy types

| Policy type | Attachment | Description | Field |
|-------------|-----------|-------------|-------|
| **Preset (managed) policy** | `tencentcloud_identity_center_role_configuration_permission_policy_attachment` | Tencent Cloud predefined policy template | `preset_policy_names` (list of policy names) |
| **Custom policy** | `tencentcloud_identity_center_role_configuration_permission_custom_policy_attachment` | User-defined JSON policy document | `custom_policies` (list of `{ name, policy_document }`) |

### Session duration

- `session_duration` is expressed in **seconds**, valid range **900 (15 min) – 43200 (12 hours)**.
- Default is **7200 (2 hours)**. The module validates the range and errors out otherwise.

### Target identification

A role assignment can target an account in two ways:
- **`target_uin`** – the target account UIN directly.
- **`target_name`** – the target account name; the module resolves the UIN automatically from organization members.

**Note**: Provide only one of `target_uin` / `target_name` per assignment.

### `target_type`

- `ManagerUin` – assign the role to the organization manager (management) account.
- `MemberUin` – assign the role to a member account.

### `deprovision_strategy`

- `None` (default) – do nothing when the last role assignment on an account is removed.
- `DeprovisionForLastRoleAssignmentOnAccount` – deprovision the role configuration on the account when its last assignment is removed.

### Preset policy reference

Common preset policy names:
- `QcloudOrganizationFullAccess` – full Organization management access.
- `QcloudOrganizationReadOnlyAccess` – Organization read-only access.
- `QcloudCamFullAccess` – full CAM access.
- `QcloudCamReadOnlyAccess` – CAM read-only access.
- `QcloudVPCFullAccess` – full VPC access.
- `QcloudCVMFullAccess` – full CVM access.
- `QcloudCDBFullAccess` – full TencentDB (MySQL) access.
- `QcloudFinanceFullAccess` – full finance management access.
- `QcloudFinanceReadOnlyAccess` – finance read-only access.

### Outputs

```hcl
cic_roles = {
  "admin-role"     = "rc-xxxxxxxx"
  "developer-role" = "rc-yyyyyyyy"
  "audit-role"     = "rc-zzzzzzzz"
}

preset_policy_attachments = {
  "admin-role|QcloudCamFullAccess" = "rc-xxx|policy/yyyy"
  # ...
}

custom_policy_attachments = {
  "developer-role|developer-custom-policy" = "rc-xxx|cppp/zzzz"
  # ...
}
```

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Identity Center enabled**
   - Identity Center must be enabled and a valid `zone_id` provided before applying.
   - Role assignments reference user/group IDs (`u-*` / `g-*`) that exist in Identity Center.

2. **Permission planning**
   - Follow the principle of least privilege.
   - Plan role configurations and policies carefully; avoid over-granting.

3. **Policy configuration**
   - Preset and custom policies can both be attached to the same role configuration.
   - Custom policy documents must comply with CAM policy syntax (validate JSON).

4. **Target accounts**
   - Ensure the target account name/UIN exists in the organization.
   - Prefer `target_uin` for precise identification; use `target_name` for readability.

5. **Session duration**
   - Keep session duration within 900–43200 seconds.
   - Shorter sessions improve security; longer sessions improve usability.

6. **Deprovision strategy**
   - `DeprovisionForLastRoleAssignmentOnAccount` removes the role configuration from the account when the last assignment is gone; choose carefully to avoid unintended removal.

7. **Naming convention**
   - Use meaningful role configuration names.
   - Follow a consistent naming convention; avoid special characters.

8. **Change management & auditing**
   - Record all role/policy/assignment changes and prepare a rollback plan.
   - Enable organization operation logs and periodically audit role usage.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Zone not found / Identity Center not enabled

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Zone not found
```

**Cause**: `zone_id` is missing, invalid, or Identity Center is not enabled.
**Solution**:
- Enable Identity Center for the organization first.
- Confirm `zone_id` is the correct Zone ID.

#### Error 2: Principal (user/group) not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Principal not found
```

**Cause**: The `principal_id` does not exist in Identity Center or `principal_type` is wrong.
**Solution**:
- Confirm the CIC user ID (`u-*`) or group ID (`g-*`).
- Verify `principal_type` matches (`User` / `Group`).

#### Error 3: Policy not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy not found
```

**Cause**: A `preset_policy_names` entry does not exist.
**Solution**:
- Confirm the preset policy name is correct and available.

#### Error 4: Custom policy syntax error

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid policy document
```

**Cause**: The `policy_document` JSON is malformed or violates CAM syntax.
**Solution**:
- Validate the JSON format.
- Use a JSON/CAM policy validator.

#### Error 5: Target account not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Target account not found
```

**Cause**: `target_uin`/`target_name` does not exist in the organization.
**Solution**:
- Confirm the account UIN or name.
- Verify the account is part of the organization.

#### Error 6: Session duration out of range

```
Error: Invalid value for variable "session_duration": Session duration must be between 900 (15 minutes) and 43200 (12 hours) seconds.
```

**Cause**: `session_duration` is outside 900–43200.
**Solution**:
- Set a value within the valid range.

#### Error 7: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks Identity Center / Organization permissions.
**Solution**:
- Confirm provider credentials have the required permissions.
- Attach `QcloudOrganizationFullAccess` / `QcloudCamFullAccess` as needed.

## License

See [LICENSE](../../../LICENSE) for full details.
