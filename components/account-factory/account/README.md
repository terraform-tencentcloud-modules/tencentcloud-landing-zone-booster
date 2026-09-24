# Tencent Cloud Account Deployment Module

## Module Overview

This module is used to create and manage member accounts in a Tencent Cloud Organization (TCO). It supports the following core capabilities:

- Create organization member accounts in the resource directory
- Configure permission policies for member accounts
- Bind email and phone number to member accounts
- Customize the organization node (department) the account belongs to
- Manage account tags

---

## Module Positioning

> ⚠️ **Relationship with the `organization/members` module in this repository**
>
> This module (`account-factory/account`) is the **single-account** version for creating organization members. It creates one member account and optionally binds email/phone.
> The repository also contains `tc-modules/components/organization/members`, which supports **batch** creation via `for_each` (its `node_id` can be auto-resolved from the node name, and `is_modify_nick_name` takes the raw API numeric values `1/0`).
>
> The two modules overlap heavily in functionality; do not mix them on the caller side. For batch creation, prefer `organization/members`; for creating a single account where you want to pass `is_modify_nick_name` with `bool` semantics, use this module. If a consolidation plan emerges later, both will converge into one module.

---

## Prerequisites

### Environment Requirements

| Tool | Minimum Version | Description |
|------|-----------------|-------------|
| Terraform | `>= 1.3.0` | Infrastructure-as-code tool |
| tencentcloud provider | `>= 1.81.0` | Tencent Cloud Terraform Provider |

### Permission Requirements

Executing this module requires the following Tencent Cloud permissions:

| Permission Name | Description |
|-----------------|-------------|
| `QcloudOrganizationFullAccess` | Full read/write access to Tencent Cloud Organization |
| `QcloudOrganizationMemberFullAccess` | Organization member management permission |

### Other Requirements

- The current account must be the **administrator account (root account)** of the Tencent Cloud Organization
- Tencent Cloud Organization initialization must be completed
- If binding an email, ensure the email address is not already used by another account

---

## Input Variables

### Required Variables

| Name | Type | Description | Example |
|------|------|-------------|---------|
| `member_name` | `string` | Member account name, unique within the organization | `"business-prod"` |
| `permission_ids` | `list(number)` | List of member account permission IDs | `[1, 2, 3]` |
| `policy_type` | `string` | Member financial permission type | `"Financial"` |

### Optional Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `node_id` | `number` | `null` | Organization node ID; falls back to the root node when empty |
| `pay_uin` | `string` | `null` | UIN of the payment-on-behalf account |
| `force_delete_account` | `bool` | `false` | Whether to force delete the account |
| `is_modify_nick_name` | `bool` | `null` | Whether to sync member name to account nickname (`true`: sync, `false`: do not sync) |
| `record_id` | `number` | `null` | Creation record ID |
| `remark` | `string` | `null` | Account remark |
| `tags` | `map(string)` | `null` | Key-value string tags for the member |

### Email Binding Variables

> The following variables are required when `enable_bound = true`

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enable_bound` | `bool` | `false` | Whether to enable email binding |
| `email` | `string` | `null` | Bound email address |
| `phone` | `string` | `null` | Bound phone number (without country code) |
| `country_code` | `number` | `86` | Country/region code for the phone number |

---

## Variable Configuration

### variables.tf

> The following reflects the variables actually used by the module (kept consistent with `variables.tf`).

```hcl
# ============================================================
# Required variables
# ============================================================

variable "member_name" {
  description = "The name of the organization member."
  type        = string
}

variable "permission_ids" {
  description = <<-EOD
    Financial management permission IDs. Valid values:
    - 1: View bill
    - 2: Check balance
    - 3: Fund transfer
    - 4: Combine bill
    - 5: Issue an invoice
    - 6: Inherit discount
    - 7: Pay on behalf

    Values 1 and 2 are required.
  EOD
  type = list(number)
}

variable "policy_type" {
  description = "Organization policy type. Financial: Financial management policy."
  type        = string
  default     = "Financial"

  validation {
    condition     = contains(["Financial"], var.policy_type)
    error_message = "policy_type currently only supports: Financial."
  }
}

# ============================================================
# Optional variables
# ============================================================

variable "node_id" {
  description = "Organization node ID."
  type        = number
  default     = null
}

variable "pay_uin" {
  description = "The UIN of the payment account on behalf. Required when permission_ids contains 7 (Pay on behalf)."
  type        = string
  default     = null

  validation {
    condition     = !contains(var.permission_ids, 7) || var.pay_uin != null
    error_message = "pay_uin is required when permission_ids contains 7 (Pay on behalf)."
  }
}

variable "force_delete_account" {
  description = "Whether to force delete the member account when deleting the organization member. Only applicable to creation-type members, not invitation-type. Default is false."
  type        = bool
  default     = false
}

variable "is_modify_nick_name" {
  description = "Whether to synchronize organization member names to their account nicknames. Values: true: Sync, false: Do not sync. This parameter takes effect only when the name field is being modified."
  type        = bool
  default     = null
}

variable "record_id" {
  description = "Create member record ID. Required when creation failed and needs to be recreated."
  type        = number
  default     = null
}

variable "remark" {
  description = "Remark for the organization member."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags assigned to the organization member. Map of key-value strings."
  type        = map(string)
  default     = null
}

# ============================================================
# Email binding variables
# ============================================================

variable "enable_bound" {
  description = "Whether to enable security information binding. Default is false. An activation email will be sent to the specified email address after binding."
  type        = bool
  default     = false
}

variable "email" {
  description = "The email address of the user or contact person."
  type        = string
  default     = null
}

variable "phone" {
  description = "The phone of the user or contact person."
  type        = string
  default     = null
}

variable "country_code" {
  description = "The country code for the phone number (e.g., 86 for China)."
  type        = number
  default     = 86
}
```

### terraform.tfvars Example

```hcl
# Required configuration
member_name    = "business-prod"
permission_ids = [1, 2]
policy_type    = "Financial"

# Optional configuration
node_id              = 123456
pay_uin              = "100037718139"
force_delete_account = false
is_modify_nick_name  = true
remark               = "Production business account"

tags = {
  environment = "production"
  team        = "platform"
  createdBy   = "terraform"
}

# Email binding configuration
enable_bound = true
email        = "admin@example.com"
phone        = "13800138000"
country_code = 86
```

---

## Usage Examples

### Example 1: Create a Basic Member Account (No Email Binding)

```hcl
module "org_member_basic" {
  source = "./modules/account"

  # Required parameters
  member_name    = "business-dev"
  permission_ids = [1, 2]
  policy_type    = "Financial"

  # Optional parameters
  remark = "Development environment account"
  tags = {
    environment = "development"
    createdBy   = "terraform"
  }
}
```

### Example 2: Create a Member Account and Bind Email

```hcl
module "org_member_with_email" {
  source = "./modules/account"

  # Required parameters
  member_name    = "business-prod"
  permission_ids = [1, 2]
  policy_type    = "Financial"

  # Specify the node
  node_id = 123456

  # Enable email binding
  enable_bound = true
  email        = "prod-admin@example.com"
  phone        = "13800138000"
  country_code = 86

  remark = "Production core business account"
  tags = {
    environment = "production"
    team        = "platform"
    createdBy   = "terraform"
  }
}
```

### Example 3: Create a Member Account with a Payment-on-Behalf Account

```hcl
module "org_member_with_pay" {
  source = "./modules/account"

  # Required parameters
  member_name    = "business-staging"
  permission_ids = [1, 2, 7]  # Includes payment-on-behalf permission
  policy_type    = "Financial"

  # Payment-on-behalf configuration
  pay_uin = "100037718139"

  # Specify the node
  node_id = 654321

  remark = "Staging environment account, paid on behalf by the root account"
  tags = {
    environment = "staging"
    createdBy   = "terraform"
  }
}
```

### Example 4: Batch Creation of Multiple Member Accounts

> Note: This module creates a single account (no `for_each`). For batch creation, use the `organization/members` module instead. The example below illustrates the intended pattern if adapted to that module.

```hcl
locals {
  members = {
    "business-dev" = {
      node_id      = 111111
      remark       = "Development environment account"
      enable_bound = false
      email        = null
      phone        = null
    }
    "business-staging" = {
      node_id      = 222222
      remark       = "Staging environment account"
      enable_bound = true
      email        = "staging@example.com"
      phone        = "13800138001"
    }
    "business-prod" = {
      node_id      = 333333
      remark       = "Production environment account"
      enable_bound = true
      email        = "prod@example.com"
      phone        = "13800138002"
    }
  }
}

module "org_members" {
  source   = "./modules/account"
  for_each = local.members

  member_name    = each.key
  permission_ids = [1, 2]
  policy_type    = "Financial"
  node_id        = each.value.node_id
  remark         = each.value.remark
  enable_bound   = each.value.enable_bound
  email          = each.value.email
  phone          = each.value.phone
  country_code   = 86

  tags = {
    environment = "multi"
    createdBy   = "terraform"
  }
}
```

---

## Configuration Notes

### node_id Selection Logic

```
node_id selection logic:
┌─────────────────────────────────────┐
│  var.node_id != null                │
│  && var.node_id != 0                │
│         │                           │
│    YES  ▼              NO           │
│  Use specified node ID  →  Use root node ID │
│  (var.node_id)      (local.root_node_id) │
└─────────────────────────────────────┘
```

### Email Binding Lifecycle

```hcl
lifecycle {
  ignore_changes = [ email, phone ]
}
```

> After the email and phone are bound for the first time, subsequent Terraform runs will **ignore** changes to these two fields, avoiding accidental unbinding caused by configuration file edits. To change them, operate manually in the Tencent Cloud console.

### Resource Dependencies

```
tencentcloud_organization_org_member (member account)
          │
          │ depends_on
          ▼
tencentcloud_organization_org_member_email (email binding)
          │
          │ count = var.enable_bound ? 1 : 0
          ▼
     Created when binding enabled, skipped when disabled
```

---

## Caveats

> ⚠️ **Important: read carefully before operating**

1. **Account Deletion Risk**
   - `force_delete_account = true` will **forcefully deregister** the member account on `terraform destroy`
   - Account deregistration is **irreversible**; keep the default `false` in production

2. **Email Binding Limitations**
   - The same email address can only be bound to **one** Tencent Cloud account
   - After email binding, Terraform will not track changes to `email` and `phone` (`ignore_changes` is configured)
   - To change the bound email, operate manually in the Tencent Cloud console

3. **Node ID Notes**
   - When `node_id` is `null` or `0`, the member account will automatically belong to the organization **root node**
   - Ensure the specified `node_id` already exists in the organization

4. **Permission Requirements**
   - The account executing this module must be the organization **administrator account**
   - Ordinary member accounts cannot create other member accounts

5. **Payment-on-Behalf Limitations**
   - The `pay_uin` account must have an established financial relationship with the current organization
   - The payment-on-behalf relationship must be configured in advance in the Tencent Cloud console

6. **Permission ID Requirements**
   - `permission_ids` must include at least permission 1 (View bill) and 2 (Check balance)
   - For payment-on-behalf, permission 7 (Pay on behalf) is required

---

## Troubleshooting

### Error 1: Member Account Name Already Exists

```
Error: [TencentCloudSDKError] Code=ResourceInUse,
Message=Member name already exists
```

**Cause**: A member account with the same name already exists in the organization
**Solution**:
```hcl
# Change member_name to a unique name
member_name = "business-prod-v2"
```

---

### Error 2: Node ID Does Not Exist

```
Error: [TencentCloudSDKError] Code=ResourceNotFound,
Message=Node not found
```

**Cause**: The specified `node_id` does not exist in the organization
**Solution**:
```bash
# Query the organization node list
terraform console
> data.tencentcloud_organization_org_nodes.nodes
```
```hcl
# Or leave it empty to use the root node
node_id = null
```

---

### Error 3: Email Already in Use

```
Error: [TencentCloudSDKError] Code=ResourceInUse,
Message=Email already bound to another account
```

**Cause**: The email is already bound to another Tencent Cloud account
**Solution**:
```hcl
# Use an unoccupied email address
email = "new-admin@example.com"
```

---

### Error 4: Insufficient Permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation,
Message=The current account is not the organization administrator
```

**Cause**: The executing account is not an organization administrator
**Solution**:
- Confirm the `secret_id` / `secret_key` in the provider config belong to an organization administrator account
- Check that the CAM policy includes `QcloudOrganizationFullAccess`

```hcl
# Check provider configuration
provider "tencentcloud" {
  secret_id  = var.secret_id   # Confirm it is the administrator account key
  secret_key = var.secret_key
  region     = var.region
}
```

---

### Error 5: ignore_changes Causes Email Not to Update

**Symptom**: You modified `email` or `phone`, but `terraform plan` shows no changes
**Cause**: `lifecycle.ignore_changes` ignores changes to these two fields
**Solution**:
```bash
# Option 1: Modify the email binding manually via the Tencent Cloud console
# Option 2: Destroy the email binding resource first, then recreate it
terraform destroy -target="module.org_member.tencentcloud_organization_org_member_email.org_member_emails"
terraform apply
```