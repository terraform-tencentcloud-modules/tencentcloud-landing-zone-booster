# Tencent Cloud CAM Role Management Component

Terraform component under `components/account-factory/baseline/cam-role` for creating and managing CAM (Cloud Access Management) roles in Tencent Cloud. It is part of the `account-factory` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates and manages custom CAM roles, with support for:

- **Role creation** – create custom CAM roles with console-login and temporary-key validity configuration.
- **Principal configuration** – support both account principals and service principals for the role trust relationship.
- **Policy management** – attach both preset policies and custom policies.
- **Batch attachment** – automatically attach policies to the created role.
- **Tag management** – attach tags to the role and to custom policies.

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
| `QcloudCamFullAccess` | Full access to CAM management |
| `QcloudOrganizationReadOnlyAccess` | Organization read-only access (to query member info) |

### Prerequisites

- The current account must have CAM management permissions.
- To use organization member info, the current account must be a member of the Tencent Cloud Organization.

---

## Inputs

### Required variables

| Name | Type | Description | Example |
|------|------|-------------|---------|
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | `string` | CAM role name (globally unique within the account). | `"readonly-role"` |
| <a name="input_principal"></a> [principal](#input\_principal) | `object` | Role trust principal configuration. See fields below. | see below |

### Optional variables

#### Role base configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_description"></a> [description](#input\_description) | `string` | `null` | Description of the CAM role. |
| <a name="input_console_login"></a> [console\_login](#input\_console\_login) | `bool` | `false` | Whether the CAM role is allowed to log in to the console. |
| <a name="input_session_duration"></a> [session\_duration](#input\_session\_duration) | `number` | `7200` | Maximum validity period of the temporary key (seconds). |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | `null` | Tag key/value pairs for the role. |

#### Principal configuration (`principal`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `type` | `number` | - (required) | Principal type: `1` = Account, `2` = Service. |
| `account_uin` | `string` | - | Account UIN. Used when `type = 1`. |
| `service_name` | `string` | - | Service name (required when `type = 2`). |

> When `type = 1` and both `account_uin` and the owner resolution are empty, the role uses the owner UIN of the current account.

#### Policy configuration (`cam_policy`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `preset_policies` | `list(string)` | `[]` | List of preset (predefined) policy names. |
| `custom_policies` | `list(object)` | `[]` | List of custom policy configurations. |
| `↳ name` | `string` | - | Custom policy name. |
| `↳ document` | `string` | - | Policy document (JSON format). |
| `↳ description` | `string` | - | Policy description. |
| `↳ tags` | `map(string)` | - | Policy tags. |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | CAM role ARN. |
| <a name="output_policy_ids"></a> [policy\_ids](#output\_policy\_ids) | Map of CAM policy name to policy ID, keyed by policy name. |

---

## Configuration Examples

### `terraform.tfvars` example

```hcl
# Required
role_name = "readonly-role"

# Principal - account type
principal = {
  type        = 1  # account type
  account_uin = "1000000000"  # use UIN
  # service_name is not used for account type
}

# Principal - service type
# principal = {
#   type         = 2  # service type
#   service_name = "cloudaudit"  # service name
# }

# Role base configuration
description      = "Read-only access role"
console_login    = false
session_duration = 3600
tags = {
  Environment = "Production"
  Team        = "Platform"
}

# Policy configuration
cam_policy = {
  # Preset policies
  preset_policies = [
    "QcloudCamReadOnlyAccess",
    "QcloudCVMReadOnlyAccess"
  ]

  # Custom policies
  custom_policies = [
    {
      name        = "custom-readonly-policy"
      document    = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "action": [
                "cvm:Describe*",
                "vpc:Describe*"
              ],
              "resource": "*",
              "effect": "allow"
            }
          ]
        }
      EOT
      description = "Custom read-only policy"
      tags = {
        Category = "Custom"
      }
    }
  ]
}
```

---

## Usage Examples

### Example 1: Basic read-only role

```hcl
module "cam_role_basic" {
  source = "./modules/cam-role"

  role_name = "basic-readonly-role"

  principal = {
    type        = 1
    account_uin = "1000000000"
  }

  description = "Basic read-only access role"

  cam_policy = {
    preset_policies = ["QcloudCamReadOnlyAccess"]
  }
}
```

### Example 2: Service role

```hcl
module "cam_role_service" {
  source = "./modules/cam-role"

  role_name = "cloudaudit-service-role"

  principal = {
    type         = 2
    service_name = "cloudaudit"
  }

  description = "CloudAudit service role"

  cam_policy = {
    preset_policies = ["QcloudAuditFullAccess"]
  }
}
```

### Example 3: Role with custom policy

```hcl
module "cam_role_custom" {
  source = "./modules/cam-role"

  role_name = "custom-database-role"

  principal = {
    type        = 1
    account_uin = "1000000000"
  }

  description = "Custom database admin role"

  cam_policy = {
    preset_policies = ["QcloudCamReadOnlyAccess"]

    custom_policies = [
      {
        name        = "database-admin-policy"
        document    = <<-EOT
          {
            "version": "2.0",
            "statement": [
              {
                "action": [
                  "cdb:*",
                  "mariadb:*",
                  "cynosdb:*"
                ],
                "resource": "*",
                "effect": "allow"
              }
            ]
          }
        EOT
        description = "Database full-access policy"
      }
    ]
  }
}
```

### Example 4: Console-login role

```hcl
module "cam_role_console" {
  source = "./modules/cam-role"

  role_name = "console-admin-role"

  principal = {
    type        = 1
    account_uin = "1000000000"
  }

  description      = "Console admin role"
  console_login    = true
  session_duration = 14400  # 4 hours

  cam_policy = {
    preset_policies = ["QcloudResourceFullAccess"]
  }
}
```

---

## Configuration Notes

### Principal resolution

```
Principal resolution:
┌─────────────────────────────────────────────┐
│  Check var.principal                         │
│         │                                     │
│  account_uin provided   → use the given UIN   │
│  type = 2               → use service_name    │
│  neither provided       → use owner UIN of    │
│                            the current account │
└─────────────────────────────────────────────┘
```

### Policy attachment logic

```hcl
# Policies include both preset and custom policies
user_policies = concat(
  [preset policy configs],
  [custom policy configs]
)

# Auto-create the attachments
resource "tencentcloud_cam_role_policy_attachment" "role_policy_attachment" {
  for_each = { for policy in local.user_policies : policy.policy_name => policy }

  role_id   = tencentcloud_cam_role.role.id
  policy_id = each.value.policy_id
}
```

### Resource dependencies

```
tencentcloud_cam_role.role (create role)
          │
tencentcloud_cam_policy.policies (create custom policies, optional)
          │
          │ depends_on
          ▼
tencentcloud_cam_role_policy_attachment.role_policy_attachment (attach policies)
```

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Role name uniqueness**
   - A CAM role name must be globally unique within the Tencent Cloud account.
   - Use a meaningful naming convention.

2. **Principal requirements**
   - When `type = 1` (account), provide `account_uin`.
   - When `type = 2` (service), provide `service_name`.
   - If neither is provided, the role uses the owner UIN of the current account.

3. **Console login limits**
   - With `console_login = true`, the role can log in to the console.
   - In production, prefer `false` for stronger security.

4. **Session duration**
   - `session_duration` sets the maximum validity period of the temporary key (seconds).
   - Default `7200` (2 hours); maximum `43200` (12 hours).

5. **Policy document format**
   - The custom policy `document` must be valid JSON.
   - It must comply with the Tencent Cloud CAM policy document specification.

6. **Permissions**
   - The module requires CAM management permissions.
   - Querying organization members requires organization read-only permissions.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks CAM management permissions.
**Solution**:
- Confirm the provider credentials have CAM management permissions.
- Check that the CAM policy includes the required permissions.

#### Error 2: Role already exists

```
Error: [TencentCloudSDKError] Code=ResourceInUse
Message=Role already exists
```

**Cause**: The role name is already in use.
**Solution**:
- Change `role_name` to a unique name.
- Delete the existing role with the same name.

#### Error 3: Policy not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Policy not found
```

**Cause**: The specified preset policy does not exist.
**Solution**:
```bash
# List available preset policies
terraform console
> data.tencentcloud_cam_policies.all.policy_list
```

#### Error 4: Account not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Account not found
```

**Cause**: The specified account UIN does not exist.
**Solution**:
- Confirm the account UIN is correct.
- Check that the account has joined the organization (if it is a member).

#### Error 5: Invalid policy document

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid policy document
```

**Cause**: The custom policy document format is incorrect.
**Solution**:
- Check that the JSON is well-formed.
- Validate the policy syntax against the Tencent Cloud specification.
- Use an online JSON validator to verify.

## License

See [LICENSE](../../../../LICENSE) for full details.
