# Tencent Cloud Anti-DDoS (BGP) Component

Terraform component under `components/security/anti-ddos` for deploying and managing Tencent Cloud Anti-DDoS (BGP) protection — providing professional DDoS attack mitigation — as part of the `security` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component deploys and manages Anti-DDoS (BGP) instances, providing professional DDoS attack protection. Main features:

- **Multiple plan support** – Enterprise, Standard, and Standard 2.0 (StandardPlus) protection plans.
- **Flexible billing** – Monthly subscription (PREPAID) and pay-as-you-go (POSTPAID_BY_MONTH) billing modes.
- **Elastic bandwidth** – elastic bandwidth expansion to absorb traffic bursts.
- **Multi-IP protection** – protect multiple IP addresses simultaneously.
- **Regional deployment** – multi-region deployment for optimized access.
- **Tag management** – classify resources with tags.
- **Auto-configuration** – parameters are configured automatically based on the plan type.
- **Resource output** – outputs the Anti-DDoS instance ID for later management.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.82.61 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.82.61 |

### IAM Permissions

The executing principal needs the following Tencent Cloud permissions:

| Permission | Description |
|------------|-------------|
| `QcloudAntiDDoSFullAccess` | Full access to Anti-DDoS |
| `QcloudFinanceFullAccess` | Full access to finance management |
| `QcloudTagFullAccess` | Full access to Tag management |
| `QcloudBillingReadOnlyAccess` | Read-only access to billing |

### Prerequisites

- Understand the basic concepts and requirements of DDoS protection.
- Decide the protection plan type and specs.
- Plan the number of protected IPs and bandwidth needs.
- Choose an appropriate deployment region.
- Decide the billing mode and period.
- Prepare the tag classification scheme.

---

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_instance_charge_type"></a> [instance\_charge\_type](#input\_instance\_charge\_type) | `string` | yes | – | Billing mode: `PREPAID` (monthly subscription) / `POSTPAID_BY_MONTH` (pay-as-you-go). |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | `string` | yes | – | Protection plan: `Enterprise` / `Standard` / `StandardPlus` (Standard 2.0). |
| <a name="input_tag_info_list"></a> [tag\_info\_list](#input\_tag\_info\_list) | `list(object)` | no | `[]` | Tag information list. |

### Monthly subscription (PREPAID) configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_instance_charge_prepaid_period"></a> [instance\_charge\_prepaid\_period](#input\_instance\_charge\_prepaid\_period) | `number` | conditional | `null` | Purchase period in months. |
| <a name="input_instance_charge_prepaid_renew_flag"></a> [instance\_charge\_prepaid\_renew\_flag](#input\_instance\_charge\_prepaid\_renew\_flag) | `string` | no | `NOTIFY_AND_MANUAL_RENEW` | Renewal flag: `NOTIFY_AND_MANUAL_RENEW` (notify, no auto-renew) / `NOTIFY_AND_AUTO_RENEW` (notify and auto-renew) / `DISABLE_NOTIFY_AND_MANUAL_RENEW` (no notify, no auto-renew). |

### Standard plan configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_standard_region"></a> [standard\_region](#input\_standard\_region) | `string` | conditional | `null` | Region where the Anti-DDoS package is purchased. |
| <a name="input_standard_protect_ip_count"></a> [standard\_protect\_ip\_count](#input\_standard\_protect\_ip\_count) | `number` | conditional | `null` | Number of protected IPs (e.g. 1, 10, 50, 100). |
| <a name="input_standard_bandwidth"></a> [standard\_bandwidth](#input\_standard\_bandwidth) | `number` | conditional | `null` | Protected service bandwidth (Mbps). |
| <a name="input_standard_elastic_bandwidth_flag"></a> [standard\_elastic\_bandwidth\_flag](#input\_standard\_elastic\_bandwidth\_flag) | `bool` | no | `false` | Whether to enable elastic service bandwidth. |

### Standard 2.0 (StandardPlus) configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_standard_plus_region"></a> [standard\_plus\_region](#input\_standard\_plus\_region) | `string` | conditional | `null` | Region where the Anti-DDoS package is purchased. |
| <a name="input_standard_plus_protect_count"></a> [standard\_plus\_protect\_count](#input\_standard\_plus\_protect\_count) | `string` | conditional | `null` | Protection count: `TWO_TIMES` (2 full protections) / `UNLIMITED` (unlimited protections). |
| <a name="input_standard_plus_protect_ip_count"></a> [standard\_plus\_protect\_ip\_count](#input\_standard\_plus\_protect\_ip\_count) | `number` | conditional | `null` | Number of protected IPs (e.g. 1, 10, 50, 100). |
| <a name="input_standard_plus_bandwidth"></a> [standard\_plus\_bandwidth](#input\_standard\_plus\_bandwidth) | `number` | conditional | `null` | Protected service bandwidth (Mbps). |
| <a name="input_standard_plus_elastic_bandwidth_flag"></a> [standard\_plus\_elastic\_bandwidth\_flag](#input\_standard\_plus\_elastic\_bandwidth\_flag) | `bool` | no | `false` | Whether to enable elastic service bandwidth. |

### Enterprise plan configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_enterprise_region"></a> [enterprise\_region](#input\_enterprise\_region) | `string` | conditional | `null` | Region where the Anti-DDoS package is purchased. |
| <a name="input_enterprise_protect_ip_count"></a> [enterprise\_protect\_ip\_count](#input\_enterprise\_protect\_ip\_count) | `number` | conditional | `null` | Number of protected IPs (e.g. 1, 10, 50, 100). |
| <a name="input_enterprise_basic_protect_bandwidth"></a> [enterprise\_basic\_protect\_bandwidth](#input\_enterprise\_basic\_protect\_bandwidth) | `number` | conditional | `null` | Guaranteed protection bandwidth (Gbps). |
| <a name="input_enterprise_bandwidth"></a> [enterprise\_bandwidth](#input\_enterprise\_bandwidth) | `number` | conditional | `null` | Service bandwidth scale. |
| <a name="input_enterprise_elastic_protect_bandwidth"></a> [enterprise\_elastic\_protect\_bandwidth](#input\_enterprise\_elastic\_protect\_bandwidth) | `number` | no | `0` | Elastic bandwidth (Gbps), selectable [0, 400, 500, 600, 800, 1000]. |
| <a name="input_enterprise_elastic_bandwidth_flag"></a> [enterprise\_elastic\_bandwidth\_flag](#input\_enterprise\_elastic\_bandwidth\_flag) | `bool` | no | `false` | Whether to enable elastic service bandwidth. |

### `tag_info_list` object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `key` | `string` | yes | – | Tag key. |
| `value` | `string` | yes | – | Tag value. |

### Plan comparison

| Feature | Enterprise | Standard 2.0 | Standard |
|---------|------------|--------------|----------|
| **Protection capability** | Highest | High | Basic |
| **Protection count** | Unlimited | 2 times / Unlimited | Basic protection |
| **Elastic bandwidth** | Supported | Supported | Supported |
| **Use case** | Large enterprise | Medium enterprise | Small business |
| **Cost** | High | Medium | Low |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | BGP instance ID. |

---

## Configuration Examples

### `terraform.tfvars` – basic (Enterprise, PREPAID)

```hcl
# Basic configuration
instance_charge_type = "PREPAID"
package_type        = "Enterprise"

# Monthly subscription configuration
instance_charge_prepaid_period    = 12
instance_charge_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"

# Enterprise plan configuration
enterprise_region                    = "ap-guangzhou"
enterprise_protect_ip_count          = 10
enterprise_basic_protect_bandwidth   = 100
enterprise_bandwidth                 = 200
enterprise_elastic_protect_bandwidth = 500
enterprise_elastic_bandwidth_flag    = true

# Tag configuration
tag_info_list = [
  {
    key   = "Environment"
    value = "Production"
  },
  {
    key   = "Department"
    value = "Security"
  },
  {
    key   = "Project"
    value = "AntiDDoS"
  }
]
```

### Standard plan

```hcl
# Basic configuration
instance_charge_type = "POSTPAID_BY_MONTH"
package_type        = "Standard"

# Standard plan configuration
standard_region                 = "ap-beijing"
standard_protect_ip_count       = 5
standard_bandwidth              = 50
standard_elastic_bandwidth_flag = true

# Tag configuration
tag_info_list = [
  {
    key   = "Environment"
    value = "Development"
  },
  {
    key   = "Team"
    value = "DevOps"
  }
]
```

### Standard 2.0 plan

```hcl
# Basic configuration
instance_charge_type = "PREPAID"
package_type        = "StandardPlus"

# Monthly subscription configuration
instance_charge_prepaid_period    = 6
instance_charge_prepaid_renew_flag = "NOTIFY_AND_MANUAL_RENEW"

# Standard 2.0 configuration
standard_plus_region                 = "ap-shanghai"
standard_plus_protect_count          = "UNLIMITED"
standard_plus_protect_ip_count       = 20
standard_plus_bandwidth              = 100
standard_plus_elastic_bandwidth_flag = false

# Tag configuration
tag_info_list = [
  {
    key   = "Environment"
    value = "Staging"
  },
  {
    key   = "Business"
    value = "E-commerce"
  }
]
```

### Mixed / advanced configuration

```hcl
# Basic configuration
instance_charge_type = "PREPAID"
package_type        = "Enterprise"

# Monthly subscription configuration
instance_charge_prepaid_period    = 24
instance_charge_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"

# Enterprise plan advanced configuration
enterprise_region                    = "ap-guangzhou"
enterprise_protect_ip_count          = 50
enterprise_basic_protect_bandwidth   = 200
enterprise_bandwidth                 = 500
enterprise_elastic_protect_bandwidth = 1000
enterprise_elastic_bandwidth_flag    = true

# Detailed tag configuration
tag_info_list = [
  {
    key   = "Environment"
    value = "Production"
  },
  {
    key   = "CostCenter"
    value = "Security"
  },
  {
    key   = "Application"
    value = "WebService"
  },
  {
    key   = "Owner"
    value = "SecurityTeam"
  },
  {
    key   = "Compliance"
    value = "PCI-DSS"
  },
  {
    key   = "Backup"
    value = "Enabled"
  }
]
```

### Pay-as-you-go configuration

```hcl
# Basic configuration
instance_charge_type = "POSTPAID_BY_MONTH"
package_type        = "Standard"

# Standard plan configuration (pay-as-you-go)
standard_region                 = "ap-beijing"
standard_protect_ip_count       = 3
standard_bandwidth              = 30
standard_elastic_bandwidth_flag = false

# Simple tag configuration
tag_info_list = [
  {
    key   = "Billing"
    value = "PayAsYouGo"
  },
  {
    key   = "Tier"
    value = "Standard"
  }
]
```

---

## Usage Examples

### Example 1: Production environment protection (Enterprise)

```hcl
# Production DDoS protection configuration
instance_charge_type = "PREPAID"
package_type        = "Enterprise"

# Monthly subscription (2 years, auto-renew)
instance_charge_prepaid_period    = 24
instance_charge_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"

# Enterprise advanced protection configuration
enterprise_region                    = "ap-guangzhou"
enterprise_protect_ip_count          = 25
enterprise_basic_protect_bandwidth   = 150
enterprise_bandwidth                 = 300
enterprise_elastic_protect_bandwidth = 800
enterprise_elastic_bandwidth_flag    = true

# Production tags
tag_info_list = [
  {
    key   = "Env"
    value = "Prod"
  },
  {
    key   = "Criticality"
    value = "High"
  },
  {
    key   = "SLACritical"
    value = "Yes"
  }
]
```

### Example 2: Dev/test environment protection (Standard)

```hcl
# Dev/test DDoS protection configuration
instance_charge_type = "POSTPAID_BY_MONTH"
package_type        = "Standard"

# Standard plan basic configuration (pay-as-you-go)
standard_region                 = "ap-shanghai"
standard_protect_ip_count       = 2
standard_bandwidth              = 20
standard_elastic_bandwidth_flag = false

# Dev tags
tag_info_list = [
  {
    key   = "Env"
    value = "Dev"
  },
  {
    key   = "Purpose"
    value = "Testing"
  }
]
```

### Example 3: E-commerce business protection (StandardPlus)

```hcl
# E-commerce DDoS protection configuration
instance_charge_type = "PREPAID"
package_type        = "StandardPlus"

# Monthly subscription (1 year, auto-renew)
instance_charge_prepaid_period    = 12
instance_charge_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"

# Standard 2.0 unlimited protection configuration
standard_plus_region                 = "ap-beijing"
standard_plus_protect_count          = "UNLIMITED"
standard_plus_protect_ip_count       = 15
standard_plus_bandwidth              = 80
standard_plus_elastic_bandwidth_flag = true

# E-commerce tags
tag_info_list = [
  {
    key   = "Business"
    value = "E-commerce"
  },
  {
    key   = "PeakHours"
    value = "9-21"
  },
  {
    key   = "RevenueCritical"
    value = "Yes"
  }
]
```

---

## Configuration Notes

### Billing mode selection

#### Monthly subscription (PREPAID)
- **Use case**: long-running, stable workloads.
- **Advantage**: lower cost, guaranteed resources.
- **Caution**: upfront payment, lower flexibility.

#### Pay-as-you-go (POSTPAID_BY_MONTH)
- **Use case**: temporary or testing environments.
- **Advantage**: pay per usage, high flexibility.
- **Caution**: relatively higher cost, resources may be limited.

### Plan selection guide

#### Enterprise
- **Use case**: large enterprises, finance, gaming, and other high-security workloads.
- **Protection**: highest level, unlimited protections.
- **Bandwidth**: large bandwidth and elastic bandwidth supported.
- **Cost**: high.

#### Standard 2.0 (StandardPlus)
- **Use case**: medium enterprises, e-commerce, online services.
- **Protection**: strong protection, 2 times or unlimited protections.
- **Bandwidth**: moderate bandwidth, elastic bandwidth supported.
- **Cost**: medium.

#### Standard
- **Use case**: small businesses, personal websites, testing environments.
- **Protection**: basic protection.
- **Bandwidth**: basic bandwidth, optional elastic bandwidth.
- **Cost**: low.

### Region selection

| Region | Code | Use case | Latency |
|--------|------|----------|---------|
| **South China** | ap-guangzhou | Users in South China | Low |
| **East China** | ap-shanghai | Users in East China | Low |
| **North China** | ap-beijing | Users in North China | Low |
| **Southwest China** | ap-chongqing | Users in Southwest China | Medium |

### Elastic bandwidth

Elastic bandwidth absorbs sudden large traffic attacks:
- **When to enable**: when the workload has burst traffic needs.
- **Cost**: billed by actual usage.
- **Recommendation**: size it according to the business peak traffic.

### Tag management best practices

1. **Environment**: use `Env` to mark the environment (Prod/Dev/Test).
2. **Business**: use `Business` to mark the business type.
3. **Cost center**: use `CostCenter` for cost allocation.
4. **Criticality**: use `Criticality` to mark security level.
5. **Owner**: use `Owner` to mark the resource owner.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Billing mode**
   - PREPAID requires an upfront payment; ensure sufficient account balance.
   - POSTPAID_BY_MONTH is charged hourly; control the cost closely.

2. **Plan selection**
   - Choose a plan that fits the business scale; avoid over-provisioning.
   - Enterprise and StandardPlus support higher protection capability.

3. **Region limits**
   - The Anti-DDoS package is region-specific; pick the correct region.
   - Cross-region protection requires extra configuration.

4. **IP count**
   - Plan the number of protected IPs in advance.
   - Adding IPs may involve a plan change.

5. **Bandwidth**
   - Base bandwidth must cover daily business needs.
   - Elastic bandwidth is for traffic bursts.

6. **Renewal**
   - Set a proper renewal policy for PREPAID instances.
   - Avoid protection interruption caused by expiration.

7. **Tagging**
   - Follow a consistent tag naming convention.
   - Ensure tag key/value uniqueness.

8. **Permission verification**
   - Confirm sufficient permission to create Anti-DDoS instances.
   - Check account quota limits.

9. **Testing**
   - Test the protection effect after deployment.
   - Verify tags are applied correctly.

10. **Monitoring & alerting**
    - Set up resource usage monitoring.
    - Configure cost overrun alerts.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=PermissionDenied
Message=Insufficient permissions
```

**Cause**: The current account lacks sufficient permissions.
**Solution**:
- Check Anti-DDoS related permissions.
- Request `QcloudAntiDDoSFullAccess`.

#### Error 2: Resource limit exceeded

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Resource limit exceeded
```

**Cause**: The resource count limit has been reached.
**Solution**:
- Check the current number of Anti-DDoS instances.
- Request a quota increase.

#### Error 3: Region not available

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**Cause**: The selected region does not support the plan.
**Solution**:
- Check region availability.
- Choose a supported region.

#### Error 4: Package type conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Package type conflict
```

**Cause**: A parameter mismatch with the selected plan was configured.
**Solution**:
- Check that `package_type` matches the configured parameters.
- Only configure parameters for the selected plan.

#### Error 5: Billing error

```
Error: [TencentCloudSDKError] Code=BillingError
Message=Billing configuration error
```

**Cause**: Billing configuration error.
**Solution**:
- Check `instance_charge_type`.
- Confirm the prepaid parameters are correct.

#### Error 6: Invalid tag format

```
Error: [TerraformError] Code=ValidationError
Message=Invalid tag format
```

**Cause**: The tag format is invalid.
**Solution**:
- Check the tag key/value format.
- Ensure keys and values are not empty.

## License

See [LICENSE](../../../LICENSE) for full details.
