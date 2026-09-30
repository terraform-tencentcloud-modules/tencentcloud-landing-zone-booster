# Tencent Cloud CAM User Management Component

Terraform component under `components/account-factory/baseline/cam-user` for creating and managing CAM (Cloud Access Management) users in Tencent Cloud. It is part of the `account-factory` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates and manages CAM users, with support for:

- **User creation** – create CAM users with full user profile configuration.
- **Password management** – auto-generate a strong password or use a custom password, with first-login reset support.
- **API key** – auto-generate an API access key (Access Key) when enabled.
- **Policy management** – attach both preset policies and custom policies.
- **Batch attachment** – automatically attach policies to the created user.
- **Tag management** – attach tags to the user and to custom policies.

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

The executing principal needs the following Tencent Cloud permission:

| Permission | Description |
|------------|-------------|
| `QcloudCamFullAccess` | Full access to CAM management |

### Prerequisites

- The current account must have CAM management permissions.
- Creating a user requires root-account permissions or a sub-account with CAM management permissions.

---

## Inputs

### Required variables

| Name | Type | Description | Example |
|------|------|-------------|---------|
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | `string` | CAM user name (globally unique within the account). | `"dev-user"` |

### Optional variables

#### User base configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_user_phone_number"></a> [user\_phone\_number](#input\_user\_phone\_number) | `string` | `null` | User phone number. |
| <a name="input_phone_country_code"></a> [phone\_country\_code](#input\_phone\_country\_code) | `string` | `null` | Phone country code (e.g. `86`). |
| <a name="input_user_email"></a> [user\_email](#input\_user\_email) | `string` | `null` | User email address. |
| <a name="input_user_remark"></a> [user\_remark](#input\_user\_remark) | `string` | `null` | User remark. |
| <a name="input_console_login"></a> [console\_login](#input\_console\_login) | `bool` | `false` | Whether the user can log in to the console. |
| <a name="input_use_api"></a> [use\_api](#input\_use\_api) | `bool` | `true` | Whether to generate an API secret key. |
| <a name="input_need_reset_password"></a> [need\_reset\_password](#input\_need\_reset\_password) | `bool` | `true` | Whether the user must reset the password on first login. |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | `string` | `null` | User password (**sensitive**). Only used when `console_login = true`. If not set, a random password is generated. |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | `bool` | `false` | Whether to force-delete the user even when an API key exists. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | `null` | Tag key/value pairs for the user. |

#### Policy configuration (`cam_policy`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `pre_policies` | `list(string)` | `[]` | List of preset (predefined) policy names. |
| `custom_policies` | `list(object)` | `[]` | List of custom policy configurations. |
| `↳ name` | `string` | - | Custom policy name. |
| `↳ document` | `string` | - | Policy document (JSON format). |
| `↳ description` | `string` | - | Policy description. |
| `↳ tags` | `map(string)` | - | Policy tags. |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_user_uin"></a> [user\_uin](#output\_user\_uin) | CAM user UIN. |
| <a name="output_user_passwords"></a> [user\_passwords](#output\_user\_passwords) | CAM user password (may be auto-generated). |
| <a name="output_policy_ids"></a> [policy\_ids](#output\_policy\_ids) | Map of CAM policy name to policy ID, keyed by policy name. |
| <a name="output_access_key"></a> [access\_key](#output\_access\_key) | Map containing `secret_id` and `secret_key` of the generated API access key. |

> Outputs `user_passwords` and `access_key.secret_key` contain sensitive values. Handle them carefully and avoid exposing them in logs or consoles.

---

## Configuration Examples

### `terraform.tfvars` example

```hcl
# Required
user_name = "dev-user"

# User base configuration
user_phone_number   = "13800138000"
phone_country_code  = "86"
user_email          = "dev-user@example.com"
user_remark         = "Development environment user"
console_login       = true
use_api             = true
need_reset_password = true
force_delete        = false

tags = {
  Environment = "Development"
  Team        = "Backend"
  Project     = "Microservice"
}

# Policy configuration
cam_policy = {
  # Preset policies
  pre_policies = [
    "QcloudCamReadOnlyAccess",
    "QcloudCVMReadOnlyAccess",
    "QcloudVPCReadOnlyAccess"
  ]

  # Custom policies
  custom_policies = [
    {
      name        = "custom-dev-access"
      document    = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "action": [
                "cvm:*",
                "vpc:*",
                "clb:*"
              ],
              "resource": "*",
              "effect": "allow"
            }
          ]
        }
      EOT
      description = "Development full-access policy"
      tags = {
        Category = "Development"
      }
    }
  ]
}
```

### Password configuration

```hcl
# Auto-generated password (recommended)
user_password = null  # no password set, a strong password is generated automatically

# Custom password
user_password = "P@ssw0rd123!"  # 8-32 chars, with upper/lower case, digits and special chars
```

---

## Usage Examples

### Example 1: Basic developer user

```hcl
module "cam_user_basic" {
  source = "./modules/cam-user"

  user_name = "dev-basic-user"

  user_email    = "dev@example.com"
  console_login = true
  use_api       = true

  cam_policy = {
    pre_policies = ["QcloudCamReadOnlyAccess"]
  }
}
```

### Example 2: API-only user

```hcl
module "cam_user_api" {
  source = "./modules/cam-user"

  user_name = "api-service-user"

  user_remark        = "API service account"
  console_login       = false # disable console login
  use_api             = true  # enable API access
  need_reset_password = false # no password reset needed

  cam_policy = {
    pre_policies = ["QcloudResourceFullAccess"]
  }
}
```

### Example 3: User with custom policy

```hcl
module "cam_user_custom" {
  source = "./modules/cam-user"

  user_name = "custom-policy-user"

  user_phone_number   = "13900139000"
  phone_country_code  = "86"
  console_login       = true

  cam_policy = {
    pre_policies = ["QcloudCamReadOnlyAccess"]

    custom_policies = [
      {
        name        = "database-access-policy"
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

### Example 4: Read-only monitoring user

```hcl
module "cam_user_monitor" {
  source = "./modules/cam-user"

  user_name = "monitor-readonly-user"

  user_email    = "monitor@example.com"
  console_login = true

  cam_policy = {
    pre_policies = [
      "QcloudCamReadOnlyAccess",
      "QcloudMonitorReadOnlyAccess",
      "QcloudCLSReadOnlyAccess"
    ]
  }
}
```

---

## Configuration Notes

### Password generation logic

```
Password generation:
┌──────────────────────────────────────────┐
│  Check console_login = true               │
│         │                                  │
│  user_password provided   → use it        │
│  user_password = null     → auto-generate  │
│  console_login = false     → no password   │
└──────────────────────────────────────────┘
```

### API key generation logic

```hcl
# API key is generated only when use_api = true
resource "tencentcloud_cam_access_key" "aksk" {
  count = var.use_api ? 1 : 0

  target_uin = tencentcloud_cam_user.user.uin
  status     = "Active"
}
```

### Policy attachment logic

```hcl
# Policies include both preset and custom policies
user_policies = concat(
  [preset policy configs],
  [custom policy configs]
)

# Auto-create the attachments
resource "tencentcloud_cam_user_policy_attachment" "user_policy_attachment" {
  for_each = { for policy in local.user_policies : policy.policy_name => policy }

  user_name = tencentcloud_cam_user.user.name
  policy_id = each.value.policy_id
}
```

### Resource dependencies

```
random_password.pwd (generate password, optional)
          │
tencentcloud_cam_user.user (create user)
          │
          ├─ tencentcloud_cam_access_key.aksk (generate API key, optional)
          │
tencentcloud_cam_policy.policies (create custom policies, optional)
          │
          │ depends_on
          ▼
tencentcloud_cam_user_policy_attachment.user_policy_attachment (attach policies)
```

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **User name uniqueness**
   - A CAM user name must be globally unique within the Tencent Cloud account.
   - Use a meaningful naming convention.

2. **Password complexity**
   - Password length 8-32 characters.
   - Must include uppercase letters, lowercase letters, digits and special characters.
   - Supported special characters: `!#$%&*()-_=+[]{}<>:?`

3. **Console login limits**
   - With `console_login = true`, the user can log in via the console.
   - For service accounts in production, prefer `false`.

4. **API key security**
   - When `use_api = true`, an API key is generated automatically.
   - Store API keys securely, e.g. using a secrets manager.

5. **Password reset**
   - With `need_reset_password = true`, the user must reset the password on first login.
   - Recommended for stronger security.

6. **Force delete**
   - With `force_delete = false`, deletion fails if the user has an API key.
   - With `force_delete = true`, the user (including its API keys) is deleted directly.

7. **Sensitive outputs**
   - The password and API key are marked as sensitive in the Terraform outputs.
   - Handle these values carefully in practice.

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
- Check that the CAM policy includes `QcloudCamFullAccess`.

#### Error 2: User already exists

```
Error: [TencentCloudSDKError] Code=ResourceInUse
Message=User already exists
```

**Cause**: The user name is already in use.
**Solution**:
- Change `user_name` to a unique name.
- Delete the existing user with the same name.

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

#### Error 4: Insufficient password complexity

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Password does not meet complexity requirements
```

**Cause**: The custom password does not meet the complexity requirements.
**Solution**:
- Ensure the password includes upper/lower case letters, digits and special characters.
- Keep the length between 8 and 32 characters.
- Use the auto-generated password (do not set `user_password`).

#### Error 5: Access key exists

```
Error: [TencentCloudSDKError] Code=ResourceInUse
Message=Access key exists
```

**Cause**: The user has an API key and cannot be deleted directly.
**Solution**:
- Set `force_delete = true` to force deletion.
- Or delete the API key first, then delete the user.

#### Error 6: Invalid policy document

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