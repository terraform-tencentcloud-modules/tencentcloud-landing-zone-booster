# Tencent Cloud Organization Members Component

Terraform component under `components/organization/members` for creating and managing Organization member accounts, supporting batch member creation, finance permission configuration, department association, and security binding, as part of the `organization` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates Organization member accounts and manages their configuration. Main features:

- **Member account management** – create and manage Organization member accounts.
- **Permission configuration** – configure financial management and organization policy permissions.
- **Department association** – associate members with a specific Organization department node.
- **Batch operations** – create and manage multiple members in one batch.
- **Security information binding** – bind email and phone as security information.
- **Tag management** – attach custom tags to members.
- **Dependency handling** – node name → node ID mapping is resolved automatically.
- **Output management** – output member name → UIN mapping.

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
| `QcloudFinanceFullAccess` | Full access to finance management |

### Prerequisites

- Understand the Organization structure and department hierarchy.
- Plan a member naming convention.
- Decide the permission assignment strategy.
- Collect optional member contact information.
- Understand financial permission configuration.
- Prepare a payment (pay-on-behalf) account UIN if needed.

---

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_members"></a> [members](#input\_members) | `map(list(object))` | no | `{}` | A map of Organization members. The map key is the unique node (department) name; each value is a list of member objects under that node. |

### Member object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Member name. |
| `permission_ids` | `list(number)` | yes | – | Financial management permission IDs. `1` (view bill) and `2` (check balance) are required. |
| `policy_type` | `string` | yes | – | Organization policy type. Currently `Financial`: financial management policy. |
| `pay_uin` | `string` | conditional | – | The UIN of the payment account that pays on behalf. Required when `permission_ids` contains `7`. |
| `node_id` | `number` | no | `null` | Organization node ID. When omitted, the node ID is resolved from the map key (node name). |
| `force_delete_account` | `bool` | no | `false` | Whether to force-delete the member account on delete. Applies only to member accounts created (not invited) by this org. |
| `is_modify_nick_name` | `number` | no | – | Whether to sync the member name to the account nickname. `1` – sync, `0` – do not sync. Takes effect only when `name` is modified. |
| `record_id` | `number` | no | – | Create-member record ID. Required to recreate after a failed creation. |
| `remark` | `string` | no | – | Member remark. |
| `tags` | `map(string)` | no | – | Member tags. |
| `enable_bound` | `bool` | no | `false` | Whether to enable security information binding. An activation email is sent to the bound email address. |
| `email` | `string` | no | – | Email of the user or contact person. |
| `phone` | `string` | no | – | Phone number of the user or contact person. |
| `country_code` | `number` | no | – | Country code of the phone number (e.g. `86` for China). |

### Financial management permission IDs

| Permission ID | Name | Description | Required? |
|---------------|------|-------------|-----------|
| **1** | View bill | View consumption bill and details | Required |
| **2** | Check balance | View account balance | Required |
| **3** | Fund transfer | Perform fund transfer operations | Optional |
| **4** | Combine bill | Combine multiple bills for viewing | Optional |
| **5** | Issue invoice | Request and issue invoices | Optional |
| **6** | Inherit discount | Inherit the main account discount | Optional |
| **7** | Pay on behalf | Pay using a pay-on-behalf account | Conditionally required |

### Organization policy types

| Policy type | Description | Applicable scenario |
|-------------|-------------|---------------------|
| **Financial** | Financial management policy | Finance management and fund operations |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_member_uins"></a> [member\_uins](#output\_member\_uins) | Map of node name → (member name → UIN). |

---

## Configuration Examples

### `terraform.tfvars` – basic

```hcl
# Basic member configuration example
members = {
  # Technology department members
  "Technology" = [
    {
      name           = "developer_zhangsan"
      permission_ids = [1, 2, 3]  # view bill, check balance, fund transfer
      policy_type    = "Financial"
      remark         = "Backend engineer"
      email          = "zhangsan@example.com"
      phone          = "13800138000"
      country_code   = 86
      tags           = {
        role  = "developer"
        team  = "backend"
        level = "senior"
      }
    },
    {
      name           = "developer_lisi"
      permission_ids = [1, 2]      # view-only permissions
      policy_type    = "Financial"
      remark         = "Frontend engineer"
      email          = "lisi@example.com"
      enable_bound   = true        # enable security binding
    }
  ],

  # Finance department members
  "Finance" = [
    {
      name           = "finance_wangwu"
      permission_ids = [1, 2, 3, 4, 5, 6, 7]  # full permissions
      policy_type    = "Financial"
      pay_uin        = "123456789"             # pay-on-behalf account UIN
      remark         = "Finance manager"
      email          = "wangwu@example.com"
      phone          = "13900139000"
      country_code   = 86
      force_delete_account = true  # force-delete account
    },
    {
      name           = "finance_zhaoliu"
      permission_ids = [1, 2, 4, 5]  # view and invoice permissions
      policy_type    = "Financial"
      remark         = "Finance specialist"
      email          = "zhaoliu@example.com"
    }
  ],

  # Management department members
  "Management" = [
    {
      name           = "manager_liqi"
      permission_ids = [1, 2, 3, 6]  # basic financial permissions
      policy_type    = "Financial"
      remark         = "Department manager"
      email          = "liqi@example.com"
      phone          = "13700137000"
      country_code   = 86
      is_modify_nick_name = 1  # sync name to nickname
    }
  ]
}
```

### Simple configuration (small team)

```hcl
# Simple member configuration (for small teams)
members = {
  "Default" = [
    {
      name           = "admin_user"
      permission_ids = [1, 2]      # basic view permissions
      policy_type    = "Financial"
      remark         = "Admin account"
      email          = "admin@company.com"
    },
    {
      name           = "dev_user"
      permission_ids = [1, 2]      # basic view permissions
      policy_type    = "Financial"
      remark         = "Developer account"
      email          = "dev@company.com"
    },
    {
      name           = "finance_user"
      permission_ids = [1, 2, 3, 4, 5]  # finance-related permissions
      policy_type    = "Financial"
      remark         = "Finance account"
      email          = "finance@company.com"
    }
  ]
}
```

### Advanced permission configuration

```hcl
# Advanced permission configuration (fine-grained control)
members = {
  "R&D Center" = [
    {
      name           = "rd_director"
      permission_ids = [1, 2, 3, 6]  # management-level permissions
      policy_type    = "Financial"
      remark         = "R&D director"
      email          = "rd_director@tech.com"
      phone          = "18600186000"
      country_code   = 86
      tags           = {
        department  = "rd"
        level       = "director"
        cost_center = "RD001"
      }
    },
    {
      name           = "rd_manager"
      permission_ids = [1, 2, 3]      # manager-level permissions
      policy_type    = "Financial"
      remark         = "R&D manager"
      email          = "rd_manager@tech.com"
      tags           = {
        department  = "rd"
        level       = "manager"
        cost_center = "RD002"
      }
    },
    {
      name           = "rd_engineer"
      permission_ids = [1, 2]          # engineer base permissions
      policy_type    = "Financial"
      remark         = "R&D engineer"
      email          = "rd_engineer@tech.com"
      tags           = {
        department  = "rd"
        level       = "engineer"
        cost_center = "RD003"
      }
    }
  ],

  "Finance Center" = [
    {
      name           = "finance_director"
      permission_ids = [1, 2, 3, 4, 5, 6, 7]  # full permissions
      policy_type    = "Financial"
      pay_uin        = "888888888"             # main pay-on-behalf account
      remark         = "Finance director"
      email          = "finance_director@tech.com"
      phone          = "18500185000"
      country_code   = 86
      force_delete_account = true
      tags           = {
        department  = "finance"
        level       = "director"
        cost_center = "FIN001"
      }
    },
    {
      name           = "finance_specialist"
      permission_ids = [1, 2, 4, 5]      # invoice and bill permissions
      policy_type    = "Financial"
      remark         = "Finance specialist"
      email          = "finance_specialist@tech.com"
      tags           = {
        department  = "finance"
        level       = "specialist"
        cost_center = "FIN002"
      }
    }
  ]
}
```

### Internationalized configuration

```hcl
# Internationalized member configuration
members = {
  "Global" = [
    {
      name           = "global_admin"
      permission_ids = [1, 2, 3, 4, 5, 6]  # global management permissions
      policy_type    = "Financial"
      remark         = "Global Administrator"
      email          = "admin@global.com"
      phone          = "+14155550123"
      country_code   = 1
      tags           = {
        region = "global"
        role   = "administrator"
      }
    },
    {
      name           = "us_finance"
      permission_ids = [1, 2, 3, 7]          # US finance permissions
      policy_type    = "Financial"
      pay_uin        = "US123456789"
      remark         = "US Finance Manager"
      email          = "finance.us@global.com"
      phone          = "+12125550123"
      country_code   = 1
      tags           = {
        region = "north_america"
        role   = "finance_manager"
      }
    },
    {
      name           = "eu_developer"
      permission_ids = [1, 2]                  # EU developer permissions
      policy_type    = "Financial"
      remark         = "EU Developer"
      email          = "dev.eu@global.com"
      phone          = "+442012345678"
      country_code   = 44
      tags           = {
        region = "europe"
        role   = "developer"
      }
    }
  ]
}
```

---

## Usage Examples

### Example 1: Enterprise member management

```hcl
# Enterprise-level member permission management
members = {
  "Board" = [
    {
      name           = "board_chairman"
      permission_ids = [1, 2, 3, 4, 5, 6]  # board full permissions
      policy_type    = "Financial"
      remark         = "Board chairman"
      email          = "chairman@enterprise.com"
      phone          = "13900000001"
      country_code   = 86
      tags           = {
        level = "board"
        role  = "chairman"
      }
    }
  ],

  "Executives" = [
    {
      name           = "ceo"
      permission_ids = [1, 2, 3, 4, 5, 6]  # executive full permissions
      policy_type    = "Financial"
      remark         = "Chief Executive Officer"
      email          = "ceo@enterprise.com"
      phone          = "13900000002"
      country_code   = 86
      tags           = {
        level = "c_level"
        role  = "ceo"
      }
    },
    {
      name           = "cfo"
      permission_ids = [1, 2, 3, 4, 5, 6, 7]  # CFO full + pay on behalf
      policy_type    = "Financial"
      pay_uin        = "enterprise_main"
      remark         = "Chief Financial Officer"
      email          = "cfo@enterprise.com"
      phone          = "13900000003"
      country_code   = 86
      force_delete_account = true
      tags           = {
        level = "c_level"
        role  = "cfo"
      }
    }
  ],

  "Dept Management" = [
    {
      name           = "tech_vp"
      permission_ids = [1, 2, 3, 6]  # tech VP permissions
      policy_type    = "Financial"
      remark         = "VP of Technology"
      email          = "tech.vp@enterprise.com"
      tags           = {
        level      = "vp"
        department = "technology"
      }
    },
    {
      name           = "sales_vp"
      permission_ids = [1, 2, 3, 6]  # sales VP permissions
      policy_type    = "Financial"
      remark         = "VP of Sales"
      email          = "sales.vp@enterprise.com"
      tags           = {
        level      = "vp"
        department = "sales"
      }
    }
  ]
}
```

### Example 2: Project team permission management

```hcl
# Project team permission configuration
members = {
  "Project A Team" = [
    {
      name           = "project_a_manager"
      permission_ids = [1, 2, 3]      # project manager permissions
      policy_type    = "Financial"
      remark         = "Project A manager"
      email          = "manager.project_a@company.com"
      tags           = {
        project = "project_a"
        role    = "manager"
        budget  = "500000"
      }
    },
    {
      name           = "project_a_lead"
      permission_ids = [1, 2]          # tech lead permissions
      policy_type    = "Financial"
      remark         = "Project A tech lead"
      email          = "lead.project_a@company.com"
      tags           = {
        project = "project_a"
        role    = "tech_lead"
      }
    },
    {
      name           = "project_a_dev"
      permission_ids = [1, 2]          # developer permissions
      policy_type    = "Financial"
      remark         = "Project A developer"
      email          = "dev.project_a@company.com"
      tags           = {
        project = "project_a"
        role    = "developer"
      }
    }
  ],

  "Project B Team" = [
    {
      name           = "project_b_manager"
      permission_ids = [1, 2, 3]      # project manager permissions
      policy_type    = "Financial"
      remark         = "Project B manager"
      email          = "manager.project_b@company.com"
      tags           = {
        project = "project_b"
        role    = "manager"
        budget  = "300000"
      }
    },
    {
      name           = "project_b_qa"
      permission_ids = [1, 2]          # QA permissions
      policy_type    = "Financial"
      remark         = "Project B QA engineer"
      email          = "qa.project_b@company.com"
      tags           = {
        project = "project_b"
        role    = "qa_engineer"
      }
    }
  ]
}
```

### Example 3: Vendor (outsourced) permission management

```hcl
# Vendor (outsourced) permission configuration (least-privilege)
members = {
  "Vendor Team" = [
    {
      name           = "vendor_lead"
      permission_ids = [1, 2]          # vendor lead base permissions
      policy_type    = "Financial"
      remark         = "Vendor team lead"
      email          = "vendor.lead@external.com"
      phone          = "13800000001"
      country_code   = 86
      tags           = {
        type     = "vendor"
        role     = "team_lead"
        contract = "CT2024001"
      }
    },
    {
      name           = "vendor_dev"
      permission_ids = [1]              # vendor dev read-only permissions
      policy_type    = "Financial"
      remark         = "Vendor developer"
      email          = "vendor.dev@external.com"
      tags           = {
        type     = "vendor"
        role     = "developer"
        contract = "CT2024001"
      }
    },
    {
      name           = "vendor_qa"
      permission_ids = [1]              # vendor QA read-only permissions
      policy_type    = "Financial"
      remark         = "Vendor QA engineer"
      email          = "vendor.qa@external.com"
      tags           = {
        type     = "vendor"
        role     = "qa_engineer"
        contract = "CT2024001"
      }
    }
  ]
}
```

---

## Configuration Notes

### Permission profiles

| Profile | Permission IDs | Role | Description |
|---------|----------------|------|-------------|
| **Read-only** | `[1, 2]` | Regular staff | Can only view bill and balance |
| **Basic operations** | `[1, 2, 3]` | Team lead | Can view and perform fund transfer |
| **Finance** | `[1, 2, 3, 4, 5]` | Finance staff | Full finance operation permissions |
| **Pay-on-behalf** | `[1, 2, 3, 4, 5, 6, 7]` | Finance manager | Full + pay-on-behalf |
| **Management** | `[1, 2, 3, 6]` | Manager | Basic ops + discount inheritance |

### Department mapping

The module resolves node name → node ID automatically:
- If `node_id` is provided, the specified node ID is used directly.
- If `node_id` is omitted, the node ID is looked up from the Organization by the map key (node name).
- Cross-department member management is supported.
- Department dependency is handled automatically.

### Output

The module outputs a member name → UIN map:

```hcl
# Member UIN mapping output example
member_uins = {
  "Technology" = {
    "developer_zhangsan" = "1000000001"
    "developer_lisi"     = "1000000002"
  },
  "Finance" = {
    "finance_wangwu" = "1000000003"
    "finance_zhaoliu" = "1000000004"
  },
  "Management" = {
    "manager_liqi" = "1000000005"
  }
}
```

### Security binding

When `enable_bound = true`:
- An activation email is sent to the provided email address.
- The member must complete security binding before the account can be used.
- Recommended for sensitive operations to improve account security.

### Tag management

Tags are used for:
- Permission grouping and filtering.
- Cost-center identification.
- Role and level identification.
- Project and organization identification.
- Audit and reporting classification.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Permission planning**
   - Follow the principle of least privilege.
   - Plan permission assignment strategy in advance.
   - Avoid over-granting.

2. **Department dependency**
   - Ensure the department node already exists.
   - The node name must match exactly.
   - Create the department before adding members (recommended).

3. **Pay-on-behalf configuration**
   - Pay-on-behalf requires `pay_uin`.
   - The pay-on-behalf account must have sufficient permissions.
   - Authorize pay-on-behalf operations cautiously.

4. **Security binding**
   - Security binding sends an activation email.
   - Ensure the email address is correct.
   - Enable binding for sensitive operations.

5. **Deletion protection**
   - `force_delete_account` force-deletes the account.
   - Deletion is irreversible.
   - Use with caution in production.

6. **Name synchronization**
   - `is_modify_nick_name` syncs the name to the nickname.
   - Nickname changes may affect user experience.
   - Consider naming consistency.

7. **Retry mechanism**
   - `record_id` is used to retry a failed creation.
   - Keep the record ID safe.
   - Avoid duplicate creation.

8. **Tag convention**
   - Define a consistent tag naming convention.
   - Avoid tag conflicts.
   - Facilitate later querying and management.

9. **Contact information**
   - Collect complete contact information.
   - Ensure contact details are accurate.
   - Update contact information periodically.

10. **Audit & monitoring**
    - Enable operation logs.
    - Periodically audit member permissions.
    - Monitor abnormal operations.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Invalid permission configuration

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid permission ids
```

**Cause**: Permission IDs are invalid or required permissions are missing.
**Solution**:
- Verify permission IDs are valid (1–7).
- Ensure required permissions `1` and `2` are included.
- Validate the permission combination is reasonable.

#### Error 2: Node not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Node not found
```

**Cause**: The specified department node does not exist or the name does not match.
**Solution**:
- Check the node name spelling.
- Ensure the department node has been created.
- Use the correct node ID.

#### Error 3: Invalid pay UIN

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid pay uin
```

**Cause**: The pay-on-behalf account UIN is invalid or lacks permission.
**Solution**:
- Check the pay-on-behalf account UIN.
- Confirm the pay-on-behalf account has sufficient permissions.
- Verify the pay-on-behalf account status.

#### Error 4: Member already exists

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Member already exists
```

**Cause**: The member name already exists.
**Solution**:
- Check that the member name is unique.
- Rename the duplicated member.
- Use a different naming convention.

#### Error 5: Invalid contact information

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid contact information
```

**Cause**: Email or phone format is invalid.
**Solution**:
- Check the email format.
- Verify the phone number and country code.
- Ensure contact information is valid.

#### Error 6: Quota exceeded

```
Error: [TencentCloudSDKError] Code=QuotaExceeded
Message=Member quota exceeded
```

**Cause**: The member count quota limit has been reached.
**Solution**:
- Check the member quota limit.
- Request a quota increase or delete unused members.
- Merge members with similar permissions.

## License

See [LICENSE](../../../LICENSE) for full details.
