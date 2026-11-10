# Tencent Cloud Organization Assume-Role Component

Terraform component under `components/organization/assume-role` for creating and managing Organization Identities (Org Identity) and granting those identities to organization members, implementing role-based access control (RBAC) for Tencent Cloud Organization, as part of the `organization` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates Organization Identities and authorizes members to assume them. Main features:

- **Org identity creation** – create multiple Organization Identities (Org Identity) in one batch.
- **Policy management** – support both preset policies and custom (JSON document) policies.
- **Member authorization** – grant identity permissions to organization members.
- **Automatic member resolution** – identify members by either UIN or member name.
- **Identity ID mapping** – output a map of identity name → identity ID.
- **Dependency management** – the module internally handles creation/authorization ordering.
- **Batch operations** – configure multiple identities and their policies at once.

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
| `QcloudOrganizationReadOnlyAccess` | Read-only access to Organization |

### Prerequisites

- Understand the Tencent Cloud Organization structure.
- Plan an identity naming convention.
- Decide member access-control policies.
- Understand the difference between preset and custom policies.
- Collect member UINs or member names.

---

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_assume_role_policies"></a> [assume\_role\_policies](#input\_assume\_role\_policies) | `list(object)` | yes | – | List of identity policy configurations. |

### `assume_role_policies` object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `assume_role_name` | `string` | yes | – | Identity alias name. |
| `description` | `string` | no | – | Identity description. |
| `policies` | `list(object)` | yes | – | List of policy configurations. |
| `members` | `list(object)` | yes | – | List of member configurations. |

### `policies` object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `policy_id` | `number` | conditional | – | CAM preset policy ID. Required when `policy_type = 2`. |
| `policy_name` | `string` | conditional | – | CAM preset policy name. Required when `policy_type = 2`. |
| `policy_type` | `number` | no | `2` | Policy type: `1` (custom policy), `2` (preset policy). |
| `policy_document` | `string` | conditional | – | Custom policy content (CAM policy JSON). Required when `policy_type = 1`. |

### `members` object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `member_uin` | `number` | conditional | – | Member UIN. Provide either this or `member_name`. |
| `member_name` | `string` | conditional | – | Member name. The module resolves it to the corresponding UIN automatically. Provide either this or `member_uin`. |

> **Note**: Within a single `members` entry, use **either** `member_uin` **or** `member_name` — do not set both.

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_identity_ids"></a> [identity\_ids](#output\_identity\_ids) | A map of identity name → identity ID. |

---

## Configuration Examples

### `terraform.tfvars` – basic identities

```hcl
# Basic identity policy configuration
assume_role_policies = [
  {
    assume_role_name = "admin-role"
    description      = "Administrator role with full access"

    # Policies - using preset policies
    policies = [
      {
        policy_type = 2 # preset policy
        policy_name = "QcloudCamFullAccess" # full CAM access
      },
      {
        policy_type = 2 # preset policy
        policy_name = "QcloudOrganizationFullAccess" # full Organization access
      }
    ]

    # Members - using member UIN
    members = [
      {
        member_uin = 100000000001 # admin user UIN
      },
      {
        member_uin = 100000000002 # backup admin UIN
      }
    ]
  },

  {
    assume_role_name = "developer-role"
    description      = "Developer role with limited access"

    # Policies - mixing preset and custom policies
    policies = [
      {
        policy_type = 2 # preset policy
        policy_name = "QcloudCamReadOnlyAccess" # CAM read-only
      },
      {
        policy_type = 1 # custom policy
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

    # Members - using member name
    members = [
      {
        member_name = "developer-user1"
      },
      {
        member_name = "developer-user2"
      }
    ]
  },

  {
    assume_role_name = "audit-role"
    description      = "Audit role with read-only access"

    # Policies - read-only permissions
    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudOrganizationReadOnlyAccess"
      }
    ]

    # Members - mixing UIN and name
    members = [
      {
        member_uin = 100000000003 # auditor UIN
      },
      {
        member_name = "audit-user"
      }
    ]
  }
]
```

### Multi-environment configuration

```hcl
# Multi-environment identity policy configuration
assume_role_policies = [
  # Development environment role
  {
    assume_role_name = "dev-developer"
    description      = "Developer role for development environment"

    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cvm:*",
                "vpc:*",
                "clb:*"
              ],
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

    members = [
      {
        member_name = "dev-user1"
      },
      {
        member_name = "dev-user2"
      }
    ]
  },

  # Testing environment role
  {
    assume_role_name = "test-tester"
    description      = "Tester role for testing environment"

    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cvm:Describe*",
                "vpc:Describe*",
                "clb:Describe*"
              ],
              "resource": "*"
            },
            {
              "effect": "allow",
              "action": [
                "cvm:RunInstances",
                "cvm:TerminateInstances"
              ],
              "resource": "qcs::cvm:ap-shanghai::instance/*"
            }
          ]
        }
        EOT
      }
    ]

    members = [
      {
        member_name = "test-user1"
      },
      {
        member_name = "test-user2"
      }
    ]
  },

  # Production environment role
  {
    assume_role_name = "prod-operator"
    description      = "Operator role for production environment"

    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cvm:Describe*",
                "vpc:Describe*",
                "clb:Describe*"
              ],
              "resource": "*"
            },
            {
              "effect": "allow",
              "action": [
                "cvm:RunInstances",
                "cvm:StopInstances",
                "cvm:StartInstances"
              ],
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

    members = [
      {
        member_uin = 100000000004 # production operator UIN
      },
      {
        member_name = "prod-backup" # production backup user
      }
    ]
  }
]
```

### Fine-grained permission configuration

```hcl
# Fine-grained identity policy configuration
assume_role_policies = [
  {
    assume_role_name = "network-admin"
    description      = "Network administrator role"

    policies = [
      {
        policy_type = 2
        policy_name = "QcloudVPCFullAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudEIPFullAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudCLBFullAccess"
      }
    ]

    members = [
      {
        member_name = "network-admin1"
      }
    ]
  },

  {
    assume_role_name = "database-admin"
    description      = "Database administrator role"

    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCDBFullAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudRedisFullAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudMongoDBFullAccess"
      }
    ]

    members = [
      {
        member_name = "db-admin1"
      }
    ]
  },

  {
    assume_role_name = "security-auditor"
    description      = "Security auditor role"

    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudOrganizationReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cam:Get*",
                "cam:List*",
                "organization:Get*",
                "organization:List*"
              ],
              "resource": "*"
            }
          ]
        }
        EOT
      }
    ]

    members = [
      {
        member_name = "security-auditor1"
      }
    ]
  }
]
```

---

## Usage Examples

### Example 1: Basic administrator role

```hcl
assume_role_policies = [
  {
    assume_role_name = "system-administrator"
    description      = "System administrator with full organization access"

    policies = [
      {
        policy_type = 2
        policy_name = "QcloudOrganizationFullAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudCamFullAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudFinanceFullAccess"
      }
    ]

    members = [
      {
        member_uin = 100000000001 # system administrator
      }
    ]
  }
]
```

### Example 2: Project developer role

```hcl
assume_role_policies = [
  {
    assume_role_name = "project-developer"
    description      = "Developer role for specific project access"

    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cvm:*",
                "vpc:*",
                "clb:*"
              ],
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

    members = [
      {
        member_name = "dev-john"
      },
      {
        member_name = "dev-jane"
      }
    ]
  }
]
```

### Example 3: Finance auditor role

```hcl
assume_role_policies = [
  {
    assume_role_name = "finance-auditor"
    description      = "Finance auditor with billing and cost access"

    policies = [
      {
        policy_type = 2
        policy_name = "QcloudFinanceReadOnlyAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "finance:Describe*",
                "finance:Get*"
              ],
              "resource": "*"
            }
          ]
        }
        EOT
      }
    ]

    members = [
      {
        member_uin = 100000000005 # finance auditor
      }
    ]
  }
]
```

---

## Configuration Notes

### Policy type reference

| Policy type | Value | Description | Required fields |
|-------------|-------|-------------|-----------------|
| **Preset policy** | `2` | Tencent Cloud predefined policy template | `policy_name` or `policy_id` |
| **Custom policy** | `1` | User-defined JSON policy document | `policy_document` |

### Member identification

Members can be identified in two ways:
- **`member_uin`** – the member's unique UIN.
- **`member_name`** – the member's name (the module resolves the corresponding UIN automatically).

**Note**: Only one of the two methods may be used per member entry; do not set both.

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

### Output

The module outputs the identity name → ID mapping:

```hcl
identity_ids = {
  "admin-role"       = "org-identity-12345678"
  "developer-role"   = "org-identity-87654321"
  "audit-role"       = "org-identity-abcdefgh"
}
```

### Internal dependency order

The module internally handles the following dependency order:
1. First query organization member information.
2. Then create the Organization Identities.
3. Finally authorize members to the identities.
4. Ensure identities are fully created before authorization is applied.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Permission planning**
   - Follow the principle of least privilege.
   - Plan identity and policy configuration carefully.
   - Avoid over-granting permissions.

2. **Member identification**
   - Ensure the member UIN or name is correct.
   - The member must exist in the Organization.
   - Prefer UIN for precise identification.

3. **Policy configuration**
   - Preset and custom policies cannot be mixed within a single policy object.
   - Custom policies must comply with CAM policy syntax.
   - Validate the JSON format of the policy document.

4. **Dependency management**
   - The module auto-handles creation/authorization dependencies.
   - Ensure organization member data is retrievable.
   - Monitor dependency errors during creation.

5. **Naming convention**
   - Use meaningful identity names.
   - Follow a consistent naming convention.
   - Avoid special characters.

6. **Testing & verification**
   - Test the configuration in a non-production environment.
   - Verify permissions work as expected.
   - Test that members can assume the identity.

7. **Change management**
   - Record all identity/policy changes.
   - Prepare a rollback plan.
   - Notify affected members.

8. **Monitoring & auditing**
   - Enable Organization operation logs.
   - Periodically audit identity usage.
   - Monitor for abnormal permission usage.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Member not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Member not found
```

**Cause**: The specified member UIN or name does not exist.
**Solution**:
- Confirm the member UIN is correct.
- Check the spelling of the member name.
- Verify the member belongs to the Organization.

#### Error 2: Policy not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy not found
```

**Cause**: The specified preset policy does not exist.
**Solution**:
- Confirm the policy name is correct.
- Check the policy is available.
- Verify the permission includes policy access.

#### Error 3: Policy syntax error

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid policy document
```

**Cause**: The custom policy document format is wrong.
**Solution**:
- Validate the JSON format.
- Check the syntax complies with CAM requirements.
- Use an online JSON validator.

#### Error 4: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks Organization management permission.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check Organization management permission is included.
- Verify project permissions.

#### Error 5: Quota exceeded

```
Error: [TencentCloudSDKError] Code=QuotaExceeded
Message=Identity quota exceeded
```

**Cause**: An identity or policy quota limit has been reached.
**Solution**:
- Check identity and policy quotas.
- Request a quota increase or delete unused resources.
- Merge similar identity configurations.

#### Error 6: Dependency error

```
Error: [TencentCloudSDKError] Code=DependencyViolation
Message=Cannot authorize before identity creation
```

**Cause**: The authorization operation ran before the identity was created.
**Solution**:
- Ensure the dependency relationships are correctly configured.
- Check `depends_on` settings.
- Re-run `terraform apply`.

## License

See [LICENSE](../../../LICENSE) for full details.
