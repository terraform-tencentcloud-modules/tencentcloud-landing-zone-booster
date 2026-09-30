# Tencent Cloud Account Baselines Deployment Component

Terraform component under `components/account-factory/baseline/account-baselines` for configuring and managing security baselines for member accounts in a Tencent Cloud Organization (TCO) in bulk. It is part of the `account-factory` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component configures and applies account-level security baselines to one or more member accounts of a Tencent Cloud Organization. Core features:

- **CAM password policy** – password complexity, length, reuse limits, etc.
- **CAM security policy** – multi-factor authentication (MFA), session timeout, etc.
- **Account contacts** – configure emergency contact information for the account.
- **Account messages** – configure account message notification subscriptions.
- **Preset tags** – bulk create and manage resource tags.
- **Security group** – create standardized security group rules.
- **VPC network** – create standardized VPC and subnet configurations.
- **Shared images** – share custom images to member accounts.
- **Batch apply** – apply a baseline configuration to multiple member accounts at once.

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
| `QcloudOrganizationFullAccess` | Full read/write access to Organization management |
| `QcloudCamFullAccess` | Full access to CAM management |
| `QcloudVPCFullAccess` | Full access to VPC networking |
| `QcloudCVMFullAccess` | Full access to CVM |

### Prerequisites

- The current account must be the **organization administrator (root account)**.
- Tencent Cloud Organization initialization must be completed.
- Target member accounts must already be created and joined the organization.

---

## Inputs

### Required variables

| Name | Type | Description | Example |
|------|------|-------------|---------|
| <a name="input_baseline_name"></a> [baseline\_name](#input\_baseline\_name) | `string` | Baseline name, used to identify the baseline policy. | `"prod-security-baseline"` |
| <a name="input_member_list"></a> [member\_list](#input\_member\_list) | `list(object)` | List of member accounts (provide UIN or name). At least one of `member_uin` / `member_name` is required. | `[{member_uin = 1000001}]` |

### Optional variables (grouped by feature)

#### General

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_create_cam_strategy"></a> [create\_cam\_strategy](#input\_create\_cam\_strategy) | `bool` | `false` | Whether to create the CAM role and the relative TKE essential policy. Set to `false` if already enabled via the Tencent Cloud Console. |

#### CAM password policy (`cam_password`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enabled` | `bool` | `false` | Whether to enable the password policy. |
| `password_must_contain` | `string` | `"1!aA"` | Character types the password must contain. |
| `password_minimum_length` | `number` | `8` | Minimum password length (1-32). |
| `password_force_change` | `number` | `0` | Forced password change period in days (0-365, `0` = no limit). |
| `password_reuse_limit` | `number` | `1` | Password reuse limit count (0-24, `0` = no limit). |
| `password_retry_limit` | `number` | `10` | Password retry limit count (≥1 per hour). |

#### CAM security policy (`cam_security`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enabled` | `bool` | `false` | Whether to enable the security policy. |
| `security_mfa_devices` | `list(string)` | `["Stoken", "U2FToken", "Phone", "Mail"]` | Supported MFA device types. |
| `security_mfa_login_strategy` | `number` | `1` | Login MFA strategy (`1` = enforced, `2` = choose by user). |
| `security_mfa_action_strategy` | `number` | `2` | Action MFA strategy (`2` = choose by user). |
| `security_login_idle_timeout` | `number` | `900` | Session idle timeout (seconds). |
| `security_login_max_timeout` | `number` | `3600` | Session max timeout (seconds). |

#### Account contacts (`account_contact`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enabled` | `bool` | `false` | Whether to enable contact configuration. |
| `contacts` | `list(object)` | `[]` | List of contacts. |
| `↳ name` | `string` | - | Contact name. |
| `↳ phone_num` | `string` | - | Contact phone number. |
| `↳ email` | `string` | - | Contact email. |
| `↳ remark` | `string` | - | Remark. |
| `↳ country_code` | `string` | - | Country code. |

#### Account messages (`account_message`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enabled` | `bool` | `false` | Whether to enable message configuration. |
| `messages` | `list(object)` | `[]` | List of message subscriptions. |
| `↳ msg_type` | `string` | - | Message type. |
| `↳ channel` | `string` | - | Notification channel. |
| `↳ names` | `list(string)` | - | Recipient names. |

#### Preset tags (`tag_info`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enabled` | `bool` | `false` | Whether to enable tag configuration. |
| `tags` | `list(object)` | `[]` | List of tag key/value pairs. |
| `↳ Key` | `string` | - | Tag key. |
| `↳ Values` | `list(string)` | - | Tag value list. |

#### Security group (`security_group`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enabled` | `bool` | `false` | Whether to enable security group configuration. |
| `name` | `string` | - | Security group name. |
| `region` | `string` | - | Region of the security group. |
| `remark` | `string` | `""` | Security group remark. |
| `ingress_rules` | `list(object)` | `[]` | Ingress rule list. |
| `egress_rules` | `list(object)` | `[]` | Egress rule list. |

Each rule object:

| Field | Type | Description |
|-------|------|-------------|
| `cidr` | `string` | IP CIDR block. |
| `protocol` | `string` | Protocol (e.g. `TCP`, `UDP`, `ALL`). |
| `port` | `string` | Port (e.g. `80`, `ALL`). |
| `remark` | `string` | Rule remark. |
| `action` | `string` | Rule action (e.g. `ACCEPT`, `DROP`). |
| `type` | `string` | Rule type (e.g. `CUSTOM`). |

#### VPC network (`vpc_info`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enabled` | `bool` | `false` | Whether to enable VPC configuration. |
| `name` | `string` | - | VPC name. |
| `cidr` | `string` | - | VPC CIDR block. |
| `region` | `string` | - | VPC region. |
| `subnets` | `list(object)` | - | Subnet configuration list. |
| `↳ subnet_name` | `string` | - | Subnet name. |
| `↳ cidr_block` | `string` | - | Subnet CIDR block. |
| `↳ zone` | `string` | - | Subnet availability zone. |

#### Shared images (`share_image`)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enabled` | `bool` | `false` | Whether to enable image sharing. |
| `images` | `list(object)` | `[]` | List of images to share. |
| `↳ region` | `string` | - | Region of the image. |
| `↳ image_id` | `string` | - | Image ID. |
| `↳ image_name` | `string` | - | Image name. |

---

## Outputs

This component does not declare any outputs.

---

## Configuration Examples

### `terraform.tfvars` example

```hcl
# Required
baseline_name = "prod-security-baseline"

# Member accounts
member_list = [
  {
    member_uin  = 1000001
    member_name = "business-prod"
  },
  {
    member_uin  = 1000002
    member_name = "business-dev"
  }
]

# CAM password policy
cam_password = {
  enabled                  = true
  password_must_contain   = "1!aA"
  password_minimum_length = 12
  password_force_change   = 90
  password_reuse_limit    = 5
  password_retry_limit    = 5
}

# CAM security policy
cam_security = {
  enabled                      = true
  security_mfa_devices         = ["Stoken", "U2FToken", "Phone"]
  security_mfa_login_strategy  = 1 # enforced MFA
  security_mfa_action_strategy = 2 # choose by user
  security_login_idle_timeout  = 600
  security_login_max_timeout   = 7200
}

# Account contacts
account_contact = {
  enabled = true
  contacts = [
    {
      name         = "Zhang San"
      phone_num    = "13800138000"
      email        = "admin@example.com"
      remark       = "System administrator"
      country_code = "86"
    }
  ]
}

# Account messages
account_message = {
  enabled = true
  messages = [
    {
      msg_type = "Security"
      channel  = "Email"
      names    = ["Zhang San"]
    }
  ]
}

# Preset tags
tag_info = {
  enabled = true
  tags = [
    {
      Key    = "Environment"
      Values = ["Production", "Development"]
    },
    {
      Key    = "Team"
      Values = ["Platform", "Business"]
    }
  ]
}

# Security group
security_group = {
  enabled = true
  name    = "default-security-group"
  region  = "ap-guangzhou"
  remark  = "Default security group rules"

  ingress_rules = [
    {
      cidr     = "0.0.0.0/0"
      protocol = "TCP"
      port     = "80"
      remark   = "HTTP access"
      action   = "ACCEPT"
      type     = "CUSTOM"
    },
    {
      cidr     = "0.0.0.0/0"
      protocol = "TCP"
      port     = "443"
      remark   = "HTTPS access"
      action   = "ACCEPT"
      type     = "CUSTOM"
    }
  ]

  egress_rules = [
    {
      cidr     = "0.0.0.0/0"
      protocol = "ALL"
      port     = "ALL"
      remark   = "Allow all outbound"
      action   = "ACCEPT"
      type     = "CUSTOM"
    }
  ]
}

# VPC network
vpc_info = {
  enabled = true
  name    = "main-vpc"
  cidr    = "10.0.0.0/16"
  region  = "ap-guangzhou"

  subnets = [
    {
      subnet_name = "subnet-a"
      cidr_block  = "10.0.1.0/24"
      zone        = "ap-guangzhou-3"
    },
    {
      subnet_name = "subnet-b"
      cidr_block  = "10.0.2.0/24"
      zone        = "ap-guangzhou-4"
    }
  ]
}

# Shared images
share_image = {
  enabled = true
  images = [
    {
      region     = "ap-guangzhou"
      image_id   = "img-xxxxxxxx"
      image_name = "standard-image"
    }
  ]
}
```

---

## Usage Examples

### Example 1: Basic security baseline

```hcl
module "account_baselines_basic" {
  source = "./modules/account-baselines"

  baseline_name = "basic-security-baseline"

  member_list = [
    { member_uin = 1000001 },
    { member_uin = 1000002 }
  ]

  # Enable password policy
  cam_password = {
    enabled                  = true
    password_minimum_length = 10
    password_reuse_limit    = 3
  }

  # Enable security policy
  cam_security = {
    enabled = true
  }
}
```

### Example 2: Full production baseline

```hcl
module "account_baselines_prod" {
  source = "./modules/account-baselines"

  baseline_name = "production-full-baseline"

  member_list = [
    { member_name = "business-prod" },
    { member_name = "business-staging" }
  ]

  # Full security policy
  cam_password = {
    enabled                  = true
    password_must_contain   = "1!aA@"
    password_minimum_length = 12
    password_force_change   = 90
    password_reuse_limit    = 5
    password_retry_limit    = 3
  }

  cam_security = {
    enabled                      = true
    security_mfa_devices         = ["Stoken", "U2FToken"]
    security_mfa_login_strategy  = 1
    security_login_idle_timeout  = 300
    security_login_max_timeout   = 3600
  }

  # Network infrastructure
  security_group = {
    enabled = true
    name    = "prod-security-group"
    region  = "ap-guangzhou"

    ingress_rules = [
      {
        cidr     = "10.0.0.0/8"
        protocol = "ALL"
        port     = "ALL"
        remark   = "Internal network access"
        action   = "ACCEPT"
        type     = "CUSTOM"
      }
    ]
  }

  vpc_info = {
    enabled = true
    name    = "prod-vpc"
    cidr    = "172.16.0.0/16"
    region  = "ap-guangzhou"

    subnets = [
      {
        subnet_name = "prod-subnet-1"
        cidr_block  = "172.16.1.0/24"
        zone        = "ap-guangzhou-3"
      }
    ]
  }
}
```

### Example 3: Tags and contacts only

```hcl
module "account_baselines_tags" {
  source = "./modules/account-baselines"

  baseline_name = "tagging-baseline"

  member_list = [
    { member_uin = 1000001 }
  ]

  # Preset tags
  tag_info = {
    enabled = true
    tags = [
      {
        Key    = "Environment"
        Values = ["Production"]
      },
      {
        Key    = "CostCenter"
        Values = ["IT", "Platform"]
      }
    ]
  }

  # Account contacts
  account_contact = {
    enabled = true
    contacts = [
      {
        name         = "Li Si"
        phone_num    = "13900139000"
        email        = "ops@example.com"
        remark       = "Ops owner"
        country_code = "86"
      }
    ]
  }
}
```

---

## Configuration Notes

### Member account identification

```
Member account resolution:
┌─────────────────────────────────────────────┐
│  Check var.member_list                       │
│         │                                    │
│  UIN and name both set  → UIN takes priority │
│  Only UIN set           → use UIN            │
│  Only name set          → query org for UIN  │
└─────────────────────────────────────────────┘
```

At least one of `member_uin` / `member_name` must be provided for each member.

### Baseline enablement logic

```hcl
# Each baseline item carries an `enabled` flag
baseline_items = concat(
  var.cam_password.enabled ? [item] : [],
  var.cam_security.enabled ? [item] : [],
  # ... other items
)
```

> A baseline configuration is created and applied only when its `enabled = true`.

### Resource dependencies

```
tencentcloud_account_baseline_config    (create baseline config)
          │
          │ depends_on
          ▼
tencentcloud_account_baseline_batch_apply (apply to member accounts)
          │
          │ count = length(member_list) > 0 ? 1 : 0
          ▼
     created when members exist, skipped otherwise
```

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Permissions**
   - Requires **organization administrator** permissions plus the relevant product permissions.
   - Ensure the provider credentials have sufficient privileges.

2. **Member accounts**
   - Target member accounts must already be created and joined the organization.
   - Provide at least one of `member_uin` / `member_name` per member.

3. **Propagation time**
   - After a baseline is created, it takes time to propagate to all member accounts.
   - Batch apply runs asynchronously.

4. **MFA strategy limits**
   - `security_mfa_action_strategy` currently supports only `2` (choose by user).
   - `security_mfa_login_strategy` supports `1` (enforced) and `2` (choose by user).

5. **Password policy limits**
   - Minimum length: 1-32 characters.
   - Force change period: 0-365 days (`0` = no limit).
   - Reuse limit: 0-24 (`0` = no limit).

6. **Network configuration**
   - VPC and subnet resources are created in the specified region.
   - Security group rules are applied in the specified region.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=The current account is not the organization administrator
```

**Cause**: The executing account is not the organization administrator or lacks permissions.
**Solution**:
- Confirm the provider credentials belong to the organization administrator account.
- Check that the CAM policy includes the required permissions.

#### Error 2: Member not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Member not found
```

**Cause**: The specified member UIN or name does not exist in the organization.
**Solution**:
```bash
# Verify member UIN and name via the organization members data source
terraform console
> data.tencentcloud_organization_members.members.items
```

#### Error 3: Region not supported

```
Error: [TencentCloudSDKError] Code=InvalidParameterValue
Message=Region not supported
```

**Cause**: The specified region is not in the supported list.
**Solution**:
```bash
# List supported regions
terraform console
> data.tencentcloud_regions.regions.region_list
```

#### Error 4: Validation failed

```
Error: Validation failed for variable
Message=security_mfa_login_strategy must be 1 or 2
```

**Cause**: Variable value violates the validation condition.
**Solution**:
- Check that the value is within the allowed range.
- Refer to the input tables above for valid values.

#### Error 5: Batch apply timeout

**Symptom**: Baseline config is created but batch apply stays incomplete for a long time.
**Cause**: Applying to a large number of accounts takes time.
**Solution**:
- Wait for the async operation to finish (usually a few minutes to tens of minutes).
- Check batch apply status in the Tencent Cloud Console.
- Apply in smaller batches to reduce the size of a single operation.

## License

See [LICENSE](../../../../LICENSE) for full details.
