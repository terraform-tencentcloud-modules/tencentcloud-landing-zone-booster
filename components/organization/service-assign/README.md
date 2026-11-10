# Tencent Cloud Organization Service Delegation Component

Terraform component under `components/organization/service-assign` for delegating the administration of specific Tencent Cloud services to Organization members (enabling a member account as a delegated administrator), supporting batch delegation of multiple services to multiple members, as part of the `organization` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component delegates service management permissions to Organization members. Main features:

- **Service delegation management** – delegate administration of specific cloud services to Organization members.
- **Member identification** – identify the target member by member UIN or member name.
- **Batch operations** – delegate multiple services to multiple members in one batch.
- **Automatic mapping** – member name → UIN mapping is resolved automatically.
- **Unified permission** – centrally manage service delegation across the Organization.
- **Service coverage** – supports multiple core Tencent Cloud services (see supported service list below).
- **Dependency handling** – member information dependencies are handled automatically.
- **Flexible configuration** – multiple configuration styles for different scenarios.

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
| Management permission for the delegated service | The corresponding permission for each service being delegated |

### Prerequisites

- Understand the Organization structure and member structure.
- Plan the service delegation strategy.
- Define the delegation scope and permission level.
- Collect member UINs or exact member names.
- Understand the capabilities of each target service.
- Prepare the service delegation list.

---

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_management_scope"></a> [management\_scope](#input\_management\_scope) | `number` | no | `1` | Management scope of the delegated administrator. `1` = all members, `2` = partial members. |
| <a name="input_service_assign_list"></a> [service\_assign\_list](#input\_service\_assign\_list) | `list(object)` | yes | – | A list of member-and-service maps. Either `member_uin` or `member_name` must be set (exactly one). |

### `service_assign_list` object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `member_uin` | `number` | conditional | `null` | Member UIN (set one of `member_uin` / `member_name`). |
| `member_name` | `string` | conditional | `null` | Member name (set one of `member_uin` / `member_name`). |
| `service_name` | `string` | yes | – | Service name to delegate (see supported service list). |

> Exactly one of `member_uin` and `member_name` must be provided; do not set both or neither.

### Supported services

| Service ID | Service Name (use this value for `service_name`) | Description |
|------------|--------------------------------------------------|-------------|
| **28** | WAF (Web Application Firewall) | The Organization management account or the delegated administrator can manage WAF resources for all Organization members. |
| **23** | CSIP (Cloud Security Center) | Centralized management of security risks across multiple accounts within an enterprise. |
| **29** | KMS (Key Management Service) | The group management account or delegated administrator can manage KMS for group members, enable KMS, and view/manage other members' key resources. |
| **24** | Control Center | Unified management and configuration of an enterprise multi-account environment; manage account usage standards. |
| **12** | CloudAudit | Cloud audit administrators can use tracking-set delivery to track the audit logs of all members. |
| **13** | Billing Center | Lets financial administrators access members' billing statements, account balances, and bill consolidation. |
| **18** | Config | Configuration auditing (Config) helps centrally audit and manage cloud resources; continuously records and evaluates configuration. |
| **27** | Quota Center | Centralized management of cloud service quotas. |
| **30** | Firewall Manager (FWM) | Unified policy management, control, and analysis across multiple products and accounts, plus resource sharing across account specifications. |
| **25** | Identity Center Management | Identity Center provides unified identity and permission management for multi-account based on the Group/Account organizational structure; configure enterprise IdP, SSO, and multi-account user access in one place. |

> Pass the exact **Service Name** string (e.g. `"WAF (Web Application Firewall)"`, `"CSIP (Cloud Security Center)"`) as `service_name`. The numeric ID is shown for reference only.

### Outputs

This component declares **no outputs** (the resource is managed entirely via the `service_assign_list`/inputs).

---

## Configuration Examples

### `terraform.tfvars` – basic

```hcl
# Basic service delegation configuration example
service_assign_list = [
  # Delegate development-related services to a tech member
  {
    member_name  = "developer_zhangsan"
    service_name = "CSIP (Cloud Security Center)"  # ID: 23
  },
  {
    member_name  = "developer_zhangsan"
    service_name = "KMS (Key Management Service)" # ID: 29
  },
  {
    member_name  = "developer_lisi"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },

  # Delegate security services to the security team
  {
    member_name  = "security_wangwu"
    service_name = "CSIP (Cloud Security Center)"  # ID: 23
  },
  {
    member_name  = "security_wangwu"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },

  # Delegate finance services to a finance member
  {
    member_name  = "finance_zhaoliu"
    service_name = "Billing Center"               # ID: 13
  },

  # Delegate management services to an admin
  {
    member_name  = "admin_liqi"
    service_name = "Control Center"               # ID: 24
  },
  {
    member_name  = "admin_liqi"
    service_name = "CloudAudit"                   # ID: 12
  },
  {
    member_name  = "admin_liqi"
    service_name = "Config"                       # ID: 18
  }
]
```

### Using member UIN

```hcl
# Delegate services using member UIN
service_assign_list = [
  {
    member_uin    = 1000000001                   # tech director UIN
    service_name  = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_uin    = 1000000001
    service_name  = "KMS (Key Management Service)" # ID: 29
  },
  {
    member_uin    = 1000000002                   # security lead UIN
    service_name  = "WAF (Web Application Firewall)" # ID: 28
  },
  {
    member_uin    = 1000000002
    service_name  = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_uin    = 1000000003                   # finance director UIN
    service_name  = "Billing Center"             # ID: 13
  },
  {
    member_uin    = 1000000004                   # system admin UIN
    service_name  = "Control Center"             # ID: 24
  },
  {
    member_uin    = 1000000004
    service_name  = "CloudAudit"                 # ID: 12
  }
]
```

### Mixed configuration (name + UIN)

```hcl
# Mix member name and UIN configuration
service_assign_list = [
  # By member name
  {
    member_name  = "tech_director"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_name  = "tech_director"
    service_name = "KMS (Key Management Service)" # ID: 29
  },

  # By member UIN
  {
    member_uin   = 1000000005                    # security expert UIN
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },
  {
    member_uin   = 1000000005
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },

  # Delegate to team leads
  {
    member_name  = "dev_team_lead"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_name  = "sec_team_lead"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },
  {
    member_name  = "fin_team_lead"
    service_name = "Billing Center"               # ID: 13
  }
]
```

### Enterprise-grade delegation

```hcl
# Enterprise-grade fine-grained service permission management
service_assign_list = [
  # Infrastructure team
  {
    member_name  = "infra_manager"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_name  = "infra_manager"
    service_name = "KMS (Key Management Service)" # ID: 29
  },
  {
    member_name  = "infra_engineer"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },

  # Security operations team
  {
    member_name  = "secops_manager"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_name  = "secops_manager"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },
  {
    member_name  = "secops_analyst"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },

  # Network team
  {
    member_name  = "network_admin"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },

  # Finance team
  {
    member_name  = "finance_director"
    service_name = "Billing Center"               # ID: 13
  },
  {
    member_name  = "finance_manager"
    service_name = "Billing Center"               # ID: 13
  },

  # Compliance & audit team
  {
    member_name  = "compliance_auditor"
    service_name = "CloudAudit"                   # ID: 12
  },
  {
    member_name  = "compliance_auditor"
    service_name = "Config"                       # ID: 18
  },

  # Management team
  {
    member_name  = "it_director"
    service_name = "Control Center"               # ID: 24
  },
  {
    member_name  = "it_director"
    service_name = "CloudAudit"                   # ID: 12
  }
]
```

---

## Usage Examples

### Example 1: Development team delegation

```hcl
# Development team service permission configuration
service_assign_list = [
  # Dev director - full dev service permissions
  {
    member_name  = "dev_director"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_name  = "dev_director"
    service_name = "KMS (Key Management Service)" # ID: 29
  },
  {
    member_name  = "dev_director"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },

  # Backend team - VM/security center permissions
  {
    member_name  = "backend_team_lead"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_name  = "backend_senior_dev"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_name  = "backend_junior_dev"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },

  # Frontend team - WAF permissions
  {
    member_name  = "frontend_team_lead"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },
  {
    member_name  = "frontend_dev"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  }
]
```

### Example 2: Security team delegation

```hcl
# Security team service permission configuration
service_assign_list = [
  # Security director - full security service permissions
  {
    member_name  = "security_director"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_name  = "security_director"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },
  {
    member_name  = "security_director"
    service_name = "KMS (Key Management Service)" # ID: 29
  },

  # Security analyst - monitoring & analysis
  {
    member_name  = "security_analyst"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_name  = "security_analyst"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },

  # Security engineer - implementation & configuration
  {
    member_name  = "security_engineer"
    service_name = "WAF (Web Application Firewall)" # ID: 28
  },
  {
    member_name  = "security_engineer"
    service_name = "KMS (Key Management Service)" # ID: 29
  }
]
```

### Example 3: Cross-team delegation

```hcl
# Cross-team service permission configuration
service_assign_list = [
  # PMO - global monitoring
  {
    member_name  = "pmo_director"
    service_name = "Control Center"   # ID: 24
  },
  {
    member_name  = "pmo_director"
    service_name = "Billing Center"   # ID: 13
  },
  {
    member_name  = "pmo_manager"
    service_name = "Billing Center"   # ID: 13
  },

  # Infrastructure team - resource management
  {
    member_name  = "infra_team_lead"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },
  {
    member_name  = "infra_engineer"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  },

  # Compliance team - audit monitoring
  {
    member_name  = "compliance_officer"
    service_name = "CloudAudit"       # ID: 12
  },
  {
    member_name  = "compliance_officer"
    service_name = "Config"           # ID: 18
  },

  # Customer support team - limited permissions
  {
    member_name  = "support_team_lead"
    service_name = "Billing Center"   # ID: 13
  },
  {
    member_name  = "support_engineer"
    service_name = "CSIP (Cloud Security Center)" # ID: 23
  }
]
```

---

## Configuration Notes

### Member identification

The module supports two identification methods:

1. **By member name**
   - Use `member_name` to specify the member name.
   - The module queries and maps it to the corresponding member UIN automatically.
   - Suitable when the name is known but the UIN is not.
   - The member name must be unique in the Organization.

2. **By member UIN**
   - Use `member_uin` to specify the member UIN.
   - The given UIN is used directly for delegation.
   - Suitable when the UIN is known and precise control is required.
   - The UIN must be correct and the member must exist.

### Management scope

`management_scope` controls the scope of the delegated administrator:
- `1` (default) – the delegated administrator manages **all** Organization members.
- `2` – the delegated administrator manages **partial** members (requires the relevant members to be specified through the delegation mechanism).

### Service permission categories

| Category | Permission level | Role | Managed scope |
|----------|------------------|------|---------------|
| Resource management | Operational | Ops engineer | VM, KMS, etc. |
| Security protection | Security | Security engineer | WAF, CSIP, etc. |
| Finance & cost | Finance | Finance staff | Billing, cost, etc. |
| Audit & compliance | Audit | Compliance staff | Audit logs, Config, etc. |
| Management & control | Management | Administrators | Control Center, Config, etc. |

### Automatic mapping

The module has a built-in automatic mapping:
- Queries all member information in the Organization.
- Builds a member name → UIN mapping table.
- Dynamically resolves member names.
- Handles the case where a member does not exist.
- Ensures the accuracy of delegation operations.

### Best practices

1. **Separation of duties**
   - Grant the minimum necessary permissions per responsibility.
   - Avoid over-delegation.
   - Periodically audit permission assignments.

2. **Naming convention**
   - Define a consistent member naming convention.
   - Ensure member name uniqueness.
   - Facilitate permission management and auditing.

3. **Service grouping**
   - Delegate services grouped by function.
   - Manage similar services centrally.
   - Avoid permission fragmentation.

4. **Monitoring & audit**
   - Enable operation logs.
   - Periodically check permission usage.
   - Revoke unnecessary permissions promptly.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Member identification**
   - `member_uin` and `member_name` are mutually exclusive (set exactly one).
   - Do not leave both empty or set both at once.
   - Ensure the identified member exists.

2. **Service availability**
   - Ensure the service to be delegated is enabled.
   - Check that the service status is normal.
   - Confirm service compatibility.

3. **Permission verification**
   - Verify the target member's permissions before delegation.
   - Ensure no permission conflicts are introduced.
   - Test that the permission takes effect.

4. **Name accuracy**
   - The member name must match exactly.
   - Name matching is case-sensitive.
   - Avoid ambiguous names.

5. **UIN accuracy**
   - The UIN must be accurate.
   - Avoid using wrong UINs.
   - Periodically verify UINs.

6. **Service limits**
   - Understand each service's functional limits.
   - Note dependencies between services.
   - Avoid conflicting configuration.

7. **Operation order**
   - Create the member before delegating services.
   - Operate following dependency order.
   - Avoid circular dependencies.

8. **Backup & recovery**
   - Periodically back up permission configuration.
   - Prepare a recovery plan.
   - Test the recovery process.

9. **Change management**
   - Record all permission changes.
   - Notify affected parties.
   - Evaluate change impact.

10. **Compliance**
    - Comply with internal compliance requirements.
    - Meet industry regulatory requirements.
    - Perform periodic compliance checks.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Member not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Member not found
```

**Cause**: The specified member name or UIN does not exist.
**Solution**:
- Check the member name spelling.
- Confirm the member UIN is correct.
- Ensure the member is created in the Organization.

#### Error 2: Service not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Service not found
```

**Cause**: The specified `service_name` does not exist or is not enabled.
**Solution**:
- Check the `service_name` string matches a supported service exactly (including the `(...)` suffix where applicable).
- Confirm the service is enabled.
- Refer to the supported service list above.

#### Error 3: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=PermissionDenied
Message=Insufficient permissions
```

**Cause**: The current account lacks sufficient permissions.
**Solution**:
- Check the current account's permissions.
- Confirm it has delegation permission.
- Request the necessary permissions.

#### Error 4: Duplicate delegation

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Service already assigned
```

**Cause**: The same service is already delegated to that member.
**Solution**:
- Check for duplicate configuration.
- Remove the duplicate delegation entry.
- Confirm whether re-delegation is needed.

#### Error 5: Parameter conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Parameter conflict
```

**Cause**: Both `member_uin` and `member_name` are set.
**Solution**:
- Use only one identification method.
- Remove the conflicting parameter.
- Choose the preferred method.

#### Error 6: Service limit exceeded

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Service limit exceeded
```

**Cause**: The service delegation count limit has been reached.
**Solution**:
- Check the service delegation limit.
- Reduce the number of delegations.
- Request a quota increase.

## License

See [LICENSE](../../../LICENSE) for full details.