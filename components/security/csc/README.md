# Tencent Cloud Cloud Security Center (CSC) Component

Terraform component under `components/security/csc` for deploying and managing the Cloud Security Center (CSC) service in Tencent Cloud — as part of the `security` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component deploys and manages the Cloud Security Center (CSC) service, providing comprehensive cloud security protection. Main features:

- **Security protection** – multi-edition security protection capability.
- **Billing management** – subscription (PrePay) billing mode.
- **Auto renewal** – configure auto-renewal.
- **Edition selection** – Advanced, Enterprise, and Flagship editions.
- **Extended features** – log analysis, organization account management, asset scan.
- **Tag management** – classify resources with tags.
- **Resource output** – output the CSC instance ID for later management.

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
| `QcloudFinanceFullAccess` | Financial management access |
| `QcloudBillingReadOnlyAccess` | Billing read-only access |
| `QcloudTagFullAccess` | Tag management access |
| `QcloudCSCFullAccess` | Full access to Cloud Security Center |

### Prerequisites

- Decide the deployment region and availability zone.
- Select the appropriate security center edition.
- Decide the billing period and renewal strategy.
- Plan extended-feature requirements.
- Prepare a tag classification scheme.
- Confirm the project ID if applicable.

---

## Inputs

### Required configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_region"></a> [region](#input\_region) | `string` | yes | – | Deployment region. |
| <a name="input_zone"></a> [zone](#input\_zone) | `string` | yes | – | Availability zone. |
| <a name="input_parameter"></a> [parameter](#input\_parameter) | `object` | yes | – | Product detail parameter object. All of its sub-fields are optional (see below). |

### Optional configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_pay_mode"></a> [pay\_mode](#input\_pay\_mode) | `string` | no | `PrePay` | Payment mode. Only `PrePay` (subscription) is supported. |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | `number` | no | `0` | Project ID. |
| <a name="input_period"></a> [period](#input\_period) | `number` | no | `1` | Purchase duration, max value is `36`. |
| <a name="input_period_unit"></a> [period\_unit](#input\_period\_unit) | `string` | no | `m` | Purchase duration unit: `m` (month), `y` (year). |
| <a name="input_renew_flag"></a> [renew\_flag](#input\_renew\_flag) | `string` | no | `NOTIFY_AND_MANUAL_RENEW` | Renewal flag: `NOTIFY_AND_MANUAL_RENEW` (manual), `NOTIFY_AND_AUTO_RENEW` (auto), `DISABLE_NOTIFY_AND_MANUAL_RENEW` (disabled). |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | `string` | no | `20m` | Create timeout. |

### `parameter` object fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `sv_soccloud_pc_ae` | `bool` | `false` | Advanced Edition. |
| `sv_soccloud_pc_ee` | `bool` | `false` | Enterprise Edition. |
| `sv_soccloud_pc_fe` | `bool` | `false` | Flagship Edition / Ultimate. |
| `sv_soccloud_pc_la` | `bool` | `false` | Log analysis feature. |
| `sv_soccloud_pc_ma` | `bool` | `false` | Organization account (limited). |
| `sv_soccloud_pc_mas` | `bool` | `false` | Organization account (unlimited). |
| `sv_soccloud_pc_ss` | `bool` | `false` | Asset scan feature. |
| `autoRenewFlag` | `number` | `0` | Auto-renewal flag: `0` = disabled, `1` = enabled. |
| `goodsNum` | `number` | `1` | Goods quantity. |
| `tag` | `list(string)` | `[]` | Tag list. |

> **Note**: Select at most one edition flag (`sv_soccloud_pc_ae` / `sv_soccloud_pc_ee` / `sv_soccloud_pc_fe`) to `true`. The organization account editions (`sv_soccloud_pc_ma` / `sv_soccloud_pc_mas`) are mutually exclusive as well.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | CSC instance ID. |

---

## Configuration Examples

### `terraform.tfvars`

```hcl
# Basic configuration
region   = "ap-guangzhou"
zone     = "ap-guangzhou-1"
pay_mode = "PrePay"

# Billing configuration
period      = 12
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Product parameter configuration
parameter = {
  sv_soccloud_pc_ae  = true   # enable Advanced Edition
  sv_soccloud_pc_la  = true   # enable log analysis
  sv_soccloud_pc_ss  = true   # enable asset scan
  autoRenewFlag      = 1      # enable auto renewal
  goodsNum           = 1      # goods quantity
  tag                = ["security", "production"]
}

# Optional configuration
project_id     = 123456
create_timeout = "30m"
```

### Enterprise edition configuration

```hcl
# Basic configuration
region   = "ap-shanghai"
zone     = "ap-shanghai-2"
pay_mode = "PrePay"

# Enterprise edition configuration
parameter = {
  sv_soccloud_pc_ee  = true   # enable Enterprise Edition
  sv_soccloud_pc_la  = true   # enable log analysis
  sv_soccloud_pc_ss  = true   # enable asset scan
  autoRenewFlag      = 1      # enable auto renewal
  goodsNum           = 2      # 2 instances
  tag                = ["enterprise", "security"]
}

# Long-term subscription
period      = 36
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"
```

### Flagship edition configuration

```hcl
# Basic configuration
region   = "ap-beijing"
zone     = "ap-beijing-3"
pay_mode = "PrePay"

# Flagship full-feature configuration
parameter = {
  sv_soccloud_pc_fe  = true   # enable Flagship Edition
  sv_soccloud_pc_la  = true   # enable log analysis
  sv_soccloud_pc_ss  = true   # enable asset scan
  autoRenewFlag      = 1      # enable auto renewal
  goodsNum           = 1      # goods quantity
  tag                = ["ultimate", "security"]
}

# Annual subscription
period      = 2
period_unit = "y"
renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
```

### Organization account configuration

```hcl
# Basic configuration
region   = "ap-guangzhou"
zone     = "ap-guangzhou-1"
pay_mode = "PrePay"

# Organization account unlimited edition
parameter = {
  sv_soccloud_pc_mas = true   # enable organization account unlimited edition
  sv_soccloud_pc_la  = true   # enable log analysis
  autoRenewFlag      = 0      # disable auto renewal
  goodsNum           = 1      # goods quantity
  tag                = ["organization", "unlimited"]
}

# Monthly subscription
period      = 1
period_unit = "m"
renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
```

### Minimal configuration

```hcl
# Minimal base configuration
region = "ap-shanghai"
zone   = "ap-shanghai-1"

# Use default parameters only
parameter = {
  goodsNum = 1
}

# All defaults used: 1 month, manual renewal, 20m timeout
```

---

## Usage Examples

### Example 1: Production Advanced edition

```hcl
# Production environment configuration
region   = "ap-guangzhou"
zone     = "ap-guangzhou-3"
pay_mode = "PrePay"

# Production parameters
parameter = {
  sv_soccloud_pc_ae  = true   # Advanced Edition
  sv_soccloud_pc_la  = true   # log analysis
  sv_soccloud_pc_ss  = true   # asset scan
  autoRenewFlag      = 1      # auto renewal
  goodsNum           = 1      # single instance
  tag                = ["production", "high-availability"]
}

# Long-term subscription for stability
period      = 24
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Project association
project_id = 10086
```

### Example 2: Multi-instance enterprise deployment

```hcl
# Enterprise multi-instance configuration
region   = "ap-beijing"
zone     = "ap-beijing-2"
pay_mode = "PrePay"

# Enterprise-grade deployment
parameter = {
  sv_soccloud_pc_ee  = true   # Enterprise Edition
  sv_soccloud_pc_la  = true   # log analysis
  sv_soccloud_pc_ss  = true   # asset scan
  autoRenewFlag      = 1      # auto renewal
  goodsNum           = 3      # 3 instances
  tag                = ["enterprise", "multi-instance"]
}

# Annual subscription
period      = 3
period_unit = "y"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Extend create timeout
create_timeout = "45m"
```

### Example 3: Development / testing environment

```hcl
# Development environment configuration
region = "ap-shanghai"
zone   = "ap-shanghai-4"

# Basic feature configuration
parameter = {
  sv_soccloud_pc_ae  = true   # Advanced Edition
  sv_soccloud_pc_ss  = true   # asset scan
  autoRenewFlag      = 0      # manual renewal
  goodsNum           = 1      # single instance
  tag                = ["development", "test"]
}

# Short-term subscription for testing
period      = 1
period_unit = "m"
renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
```

### Example 4: Compliance-required configuration

```hcl
# Compliance configuration
region   = "ap-guangzhou"
zone     = "ap-guangzhou-1"
pay_mode = "PrePay"

# Full-feature compliance configuration
parameter = {
  sv_soccloud_pc_fe  = true   # Flagship Edition
  sv_soccloud_pc_la  = true   # log analysis (compliance requirement)
  sv_soccloud_pc_ss  = true   # asset scan (compliance requirement)
  autoRenewFlag      = 1      # ensure service continuity
  goodsNum           = 2      # redundant deployment
  tag                = ["compliance", "audit", "security"]
}

# Long-term subscription to meet compliance cycle
period      = 36
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Explicit project ownership
project_id = 20010
```

---

## Configuration Notes

### Edition selection guide

#### Advanced Edition
- **Use case**: basic security needs of small/medium business.
- **Features**: basic protection, vulnerability scan.
- **Cost**: medium.
- **Recommendation**: fits most business scenarios.

#### Enterprise Edition
- **Use case**: comprehensive security needs of medium/large business.
- **Features**: enhanced protection, advanced threat detection.
- **Cost**: higher.
- **Recommendation**: for security-sensitive enterprises.

#### Flagship Edition
- **Use case**: large business, finance, government with high security requirements.
- **Features**: full protection, high-level threat intelligence.
- **Cost**: highest.
- **Recommendation**: critical workloads, strict compliance.

#### Organization account editions
- **Limited (MA)**: organization account management with limits.
- **Unlimited (MAS)**: organization account management without limits.
- **Use case**: multi-account environments, group enterprises.

### Feature modules

#### Log analysis
- **Feature**: security log collection, analysis, and audit.
- **Value**: meets compliance requirements, security incident investigation.
- **Recommendation**: enable in production.

#### Asset scan
- **Feature**: automated asset discovery and vulnerability scan.
- **Value**: asset inventory, risk identification.
- **Recommendation**: enable in all environments.

### Billing strategy

#### PrePay (subscription)
- **Model**: prepaid.
- **Advantage**: lower long-term cost.
- **Use case**: stable business environments.

#### Auto-renewal configuration
- **Auto renewal (`1`)**: avoid service interruption, ensure continuity.
- **Manual renewal (`0`)**: more flexible cost control.
- **Recommendation**: enable auto renewal in production.

#### Subscription period
- **Monthly (`m`)**: high flexibility, for test environments.
- **Annual (`y`)**: cost advantage, for production.
- **Max period**: 36 months.

### Deployment recommendations

#### Single-instance deployment
- **Use case**: dev/test, small workloads.
- **Advantage**: low cost, simple deployment.
- **Risk**: single point of failure.

#### Multi-instance deployment
- **Use case**: production, high-availability requirements.
- **Advantage**: redundancy, high availability.
- **Cost**: higher.

#### Region selection

| Region | Code | Use case | Latency |
|--------|------|----------|---------|
| **South China** | ap-guangzhou | South China users | Low |
| **East China** | ap-shanghai | East China users | Low |
| **North China** | ap-beijing | North China users | Low |
| **Southwest** | ap-chongqing | Southwest users | Medium |

### Security best practices

1. **Edition selection**: choose the edition per business needs.
2. **Feature enablement**: enable log analysis and asset scan in production.
3. **Auto renewal**: enable auto renewal in production to avoid interruption.
4. **Tag management**: use tags for cost allocation and management.
5. **Multi-instance deployment**: consider multi-instance HA in production.
6. **Periodic assessment**: regularly review security needs and config.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Edition compatibility**
   - Ensure the selected edition meets business needs.
   - Feature differences between editions are significant.
   - Upgrading an edition may require repurchase.

2. **Region limits**
   - CSC is region-specific.
   - Confirm the target region supports CSC.
   - Cross-region features may be limited.

3. **Permission verification**
   - Confirm sufficient permissions to create a CSC instance.
   - Check account quota limits.
   - Verify finance permissions.

4. **Billing confirmation**
   - PrePay requires upfront payment.
   - Confirm auto-renewal settings.
   - Note the impact of instance count on cost.

5. **Feature selection**
   - Select required feature modules carefully.
   - Unnecessary features increase cost.
   - Consider future expansion needs.

6. **Tag management**
   - Follow a unified tag naming convention.
   - Use tags for cost allocation.
   - Use tags for resource management.

7. **Test & verify**
   - Test CSC features after deployment.
   - Verify the configuration takes effect.
   - Check billing information.

8. **Monitoring**
   - Configure CSC service monitoring.
   - Set service-status alerts.
   - Monitor security events.

9. **Renewal management**
   - Watch renewal time and cost.
   - Set renewal reminders.
   - Periodically review the renewal strategy.

10. **Compliance**
    - Ensure configuration meets security/compliance requirements.
    - Retain necessary audit logs.
    - Follow data-protection regulations.

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
- Check CSC related permissions.
- Request `QcloudCSCFullAccess`.
- Verify finance related permissions.

#### Error 2: Quota limit

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Resource limit exceeded
```

**Cause**: Reached resource count or quota limit.
**Solution**:
- Check the current number of CSC instances.
- Request a quota increase.
- Choose a lower configuration.

#### Error 3: Region unavailable

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**Cause**: The selected region does not support CSC.
**Solution**:
- Check region availability.
- Choose a supported region.
- Contact Tencent Cloud support.

#### Error 4: Invalid parameter

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid parameter
```

**Cause**: Wrong parameter configuration.
**Solution**:
- Check the `parameter` object format.
- Validate parameter values.
- Refer to the example configuration.

#### Error 5: Pay mode not supported

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Pay mode not supported
```

**Cause**: An unsupported billing mode was used.
**Solution**:
- Confirm `PrePay` mode is used.
- Check the `pay_mode` parameter.

#### Error 6: Timeout

```
Error: timeout while waiting for state to become 'success'
```

**Cause**: The create operation timed out.
**Solution**:
- Increase the `create_timeout` value.
- Check network connectivity.
- Contact Tencent Cloud support.

## License

See [LICENSE](../../../../LICENSE) for full details.