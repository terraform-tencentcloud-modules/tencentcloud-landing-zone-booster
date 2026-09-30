# Tencent Cloud Organization Preventive Compliance Control Component

Terraform component under `components/compliance/preventive` for creating and managing Service Control Policies (SCP) in Tencent Cloud Organization (TCO). It implements organization-level preventive compliance controls as part of the `compliance` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates and manages Service Control Policies in the Tencent Cloud Organization, providing organization-level preventive compliance control. Main features:

- **Policy configuration management** – enable and configure organization-level Service Control Policies.
- **Policy file management** – create Service Control Policies based on JSON policy files.
- **Multi-target binding** – bind policies to organization nodes (departments) and members.
- **Auto-discovery** – automatically discover organization structure and member information.
- **Dependency management** – automatically handle the dependencies between policy configuration, creation and binding.

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
| `QcloudCamFullAccess` | Full access to CAM management |

### Prerequisites

- A Tencent Cloud Organization (TCO) must be created in advance.
- The organization ID (`organization_id`) must be obtained.
- The Service Control Policy JSON files must be prepared.
- The organization structure and member information must be understood.

---

## Inputs

### Main configuration

| Name | Type | Required | Description |
|------|------|----------|-------------|
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | `string` | yes | Organization ID. |

### Service Control Policy configuration

| Name | Type | Required | Description |
|------|------|----------|-------------|
| <a name="input_org_service_policies"></a> [org\_service\_policies](#input\_org\_service\_policies) | `list(object)` | yes | Organization management policy configuration list. |
| `↳ name` | `string` | yes | Policy name (1-128 characters, supports Chinese, English, digits and underscores). |
| `↳ content` | `string` | yes | Policy file path (the JSON policy file to load). |
| `↳ description` | `string` | no | Policy description. |
| `↳ targets` | `list(object)` | yes | Policy binding target list. At least `target_name` or `target_id` must be provided for each target. |
| `↳↳ target_id` | `number` | no | Binding target ID (member Uin or department ID). |
| `↳↳ target_name` | `string` | no | Binding target name (member name or department name). |
| `↳↳ target_type` | `string` | yes | Target type: `NODE` (department) or `MEMBER` (member). |

> **Note**: `target_id` and `target_name` cannot both be empty. If both are provided, `target_id` takes precedence.

---

## Configuration Examples

### `terraform.tfvars` example

```hcl
# Organization ID configuration
organization_id = "org-xxxxxx"

# Service Control Policy configuration
org_service_policies = [
  {
    name        = "deny-high-risk-services"
    content     = "./policies/deny-high-risk-services.json"
    description = "Disallow high-risk cloud services"

    targets = [
      {
        target_name = "R&D Department"
        target_type = "NODE"
      },
      {
        target_name = "QA Department"
        target_type = "NODE"
      }
    ]
  },
  {
    name        = "require-mfa"
    content     = "./policies/require-mfa.json"
    description = "Require MFA for all operations"

    targets = [
      {
        target_name = "All Members"
        target_type = "MEMBER"
      }
    ]
  },
  {
    name        = "region-restriction"
    content     = "./policies/region-restriction.json"
    description = "Restrict resource creation regions"

    targets = [
      {
        target_id   = 100000000001 # department ID
        target_type = "NODE"
      },
      {
        target_id   = 200000000001 # member Uin
        target_type = "MEMBER"
      }
    ]
  }
]
```

### Simple configuration example

```hcl
# Basic configuration example
organization_id = "your-organization-id"

org_service_policies = [
  {
    name        = "basic-compliance"
    content     = "./compliance-policy.json"
    description = "Basic compliance policy"

    targets = [
      {
        target_name = "All Departments"
        target_type = "NODE"
      }
    ]
  }
]
```

---

## Usage Examples

### Example 1: Deny high-risk services

```hcl
# Deny high-risk services for the R&D department
org_service_policies = [
  {
    name        = "deny-high-risk-services"
    content     = "./policies/deny-high-risk.json"
    description = "Disallow cryptocurrency mining, DDoS attacks and other high-risk services"

    targets = [
      {
        target_name = "R&D Department"
        target_type = "NODE"
      },
      {
        target_name = "QA Department"
        target_type = "NODE"
      }
    ]
  }
]
```

**Policy file example (deny-high-risk.json):**
```json
{
  "version": "2.0",
  "statement": [
    {
      "effect": "deny",
      "action": [
        "cvm:RunInstances",
        "vpc:CreateNatGateway",
        "vpc:CreateDirectConnectGateway"
      ],
      "resource": "*",
      "condition": {
        "string_equal": {
          "cvm:InstanceType": ["cryptocurrency-mining", "ddos-attack"]
        }
      }
    }
  ]
}
```

### Example 2: Enforce MFA

```hcl
# Require all members to enable MFA
org_service_policies = [
  {
    name        = "require-mfa-global"
    content     = "./policies/require-mfa.json"
    description = "Global MFA requirement policy"

    targets = [
      {
        target_name = "All Members"
        target_type = "MEMBER"
      }
    ]
  }
]
```

**Policy file example (require-mfa.json):**
```json
{
  "version": "2.0",
  "statement": [
    {
      "effect": "deny",
      "action": "*",
      "resource": "*",
      "condition": {
        "null": {
          "mfa": "true"
        }
      }
    }
  ]
}
```

### Example 3: Region restriction

```hcl
# Restrict the finance department to create resources only in specific regions
org_service_policies = [
  {
    name        = "region-restriction-finance"
    content     = "./policies/region-restriction.json"
    description = "Finance department region restriction policy"

    targets = [
      {
        target_name = "Finance Department"
        target_type = "NODE"
      }
    ]
  }
]
```

**Policy file example (region-restriction.json):**
```json
{
  "version": "2.0",
  "statement": [
    {
      "effect": "deny",
      "action": [
        "cvm:RunInstances",
        "vpc:CreateVpc",
        "cos:PutBucket"
      ],
      "resource": "*",
      "condition": {
        "string_not_equal": {
          "cvm:Region": ["ap-beijing", "ap-shanghai"]
        }
      }
    }
  ]
}
```

### Example 4: Combined multi-policy configuration

```hcl
# Combine multiple compliance policies
org_service_policies = [
  {
    name        = "security-baseline"
    content     = "./policies/security-baseline.json"
    description = "Security baseline policy"

    targets = [
      {
        target_name = "All Departments"
        target_type = "NODE"
      }
    ]
  },
  {
    name        = "data-protection"
    content     = "./policies/data-protection.json"
    description = "Data protection policy"

    targets = [
      {
        target_name = "Data Department"
        target_type = "NODE"
      },
      {
        target_name = "R&D Department"
        target_type = "NODE"
      }
    ]
  },
  {
    name        = "compliance-audit"
    content     = "./policies/compliance-audit.json"
    description = "Compliance audit policy"

    targets = [
      {
        target_name = "Audit Department"
        target_type = "NODE"
      }
    ]
  }
]
```

---

## Configuration Notes

### Policy execution flow

```
Policy execution flow:
┌─────────────────────────────────────┐
│  1. Enable Service Control Policy    │
│         │                           │
│  2. Create Service Control Policy    │
│         │                           │
│  3. Bind policy to targets (node/    │
│     member)                          │
│         │                           │
│  4. Policy takes effect, access     │
│     control starts                   │
└─────────────────────────────────────┘
```

### Target type description

| Target type | Description | Identifier |
|-------------|-------------|------------|
| **NODE** | Organization node (department) | Department ID or department name |
| **MEMBER** | Organization member | Member Uin or member name |

### Policy file format requirements

- **version**: must be `"2.0"`.
- **effect**: `allow` or `deny`.
- **action**: specific actions or wildcard.
- **resource**: specific resources or wildcard.
- **condition**: various condition expressions.

### Auto-discovery mechanism

The component automatically discovers:

- Organization node structure and corresponding IDs.
- Organization member list and corresponding Uins.
- Supports resolving names to IDs automatically.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Permissions**
   - Ensure the executing account has Organization management permissions.
   - `QcloudOrganizationFullAccess` is required.

2. **Organization ID**
   - A Tencent Cloud Organization must be created in advance.
   - The organization ID can be obtained via the console or API.

3. **Policy file validation**
   - The policy JSON file must comply with the TCO policy syntax.
   - It is recommended to test the policy effect in the console first.

4. **Target binding**
   - Targets can be specified by name or ID.
   - `target_name` and `target_id` cannot both be empty.
   - If both are provided, `target_id` takes precedence.

5. **Dependency**
   - Policy configuration → policy creation → policy binding.
   - The component handles dependencies automatically.

6. **Policy limits**
   - Up to 1000 policies per organization.
   - Policy names must be unique.
   - Policy content has a size limit.

7. **Effective time**
   - Policies take time to take effect after creation.
   - It is recommended to test in a small scope first.

8. **Rollback strategy**
   - Keep historical versions of policies.
   - Back up before major changes.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks Organization management permissions.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check `QcloudOrganizationFullAccess` is included.

#### Error 2: Organization not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Organization not found
```

**Cause**: The specified organization ID does not exist.
**Solution**:
- Confirm the organization ID is correct.
- Check whether the organization has been deleted.

#### Error 3: Invalid policy file

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid policy content
```

**Cause**: The policy file format or syntax is incorrect.
**Solution**:
- Check the policy JSON format.
- Verify the policy syntax against TCO requirements.
- Use the console policy editor to validate.

#### Error 4: Target not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Target not found
```

**Cause**: The specified target (department or member) does not exist.
**Solution**:
- Confirm the target name or ID is correct.
- Check whether the target has been deleted.
- Use the auto-discovery feature to verify the target exists.

#### Error 5: Policy count exceeded

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Policy count exceeds limit
```

**Cause**: The number of policies exceeds the organization limit.
**Solution**:
- Delete unused policies.
- Merge similar policies.
- Contact Tencent Cloud to raise the quota.

#### Error 6: Duplicate policy name

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy name already exists
```

**Cause**: The policy name already exists.
**Solution**:
- Use a unique policy name.
- Check for an existing policy with the same name.
- Add a prefix or suffix to differentiate.

## License

See [LICENSE](../../../LICENSE) for full details.