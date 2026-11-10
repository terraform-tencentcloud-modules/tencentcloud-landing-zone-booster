# Tencent Cloud Key Management Service (KMS) Component

Terraform component under `components/security/kms` for deploying and managing the Key Management Service (KMS) in Tencent Cloud — as part of the `security` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component deploys and manages the Key Management Service (KMS), providing secure and reliable key management and data encryption services. Main features:

- **Key management** – professional key lifecycle management.
- **Data encryption** – generate and manage data keys.
- **Security & compliance** – meets financial-grade security standards and compliance.
- **Billing management** – subscription (PrePay) billing mode.
- **Auto renewal** – configure auto-renewal.
- **Professional edition** – professional edition KMS service.
- **Data key quota** – expand the number of data keys.
- **Resource output** – output the KMS instance ID for later management.

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
| `QcloudKMSFullAccess` | Full access to KMS |
| `QcloudTagFullAccess` | Tag management access |

### Prerequisites

- Decide the deployment region and availability zone.
- Select the KMS professional edition feature.
- Decide the number of extended data keys.
- Decide the billing period and renewal strategy.
- Prepare the project ID if applicable.
- Confirm the auto-renewal settings.
- Plan the number of instances.

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
| `goodsNum` | `number` | `1` | Goods quantity (number of instances). |
| `autoRenewFlag` | `number` | `0` | Auto-renewal flag: `0` = disabled, `1` = enabled. |
| `sv_kms_pg_pro` | `bool` | `true` | KMS professional edition feature. |
| `sv_kms_exp_data_key` | `number` | `1000` | Number of extended data keys. |

### Renewal flag options

| Value | Description |
|-------|-------------|
| `NOTIFY_AND_MANUAL_RENEW` | Notify and manually renew. |
| `NOTIFY_AND_AUTO_RENEW` | Notify and automatically renew. |
| `DISABLE_NOTIFY_AND_MANUAL_RENEW` | Disable notification and manual renewal. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | KMS instance ID. |

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
  sv_kms_pg_pro       = true    # enable KMS professional edition
  sv_kms_exp_data_key = 5000    # 5000 extended data keys
  autoRenewFlag       = 1       # enable auto renewal
  goodsNum            = 1       # 1 instance
}

# Optional configuration
project_id     = 123456
create_timeout = "30m"
```

### Production environment configuration

```hcl
# Production environment configuration
region   = "ap-shanghai"
zone     = "ap-shanghai-2"
pay_mode = "PrePay"

# Production KMS configuration
parameter = {
  sv_kms_pg_pro       = true    # professional edition KMS
  sv_kms_exp_data_key = 10000   # 10000 data key quota
  autoRenewFlag       = 1       # auto renewal for continuity
  goodsNum            = 2       # 2 instances (redundant)
}

# Long-term subscription
period      = 36
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Project association
project_id = 10086
```

### Development / testing environment

```hcl
# Development environment configuration
region = "ap-beijing"
zone   = "ap-beijing-3"

# Development KMS configuration
parameter = {
  sv_kms_pg_pro       = true    # professional edition
  sv_kms_exp_data_key = 1000    # default 1000 data keys
  autoRenewFlag       = 0       # manual renewal
  goodsNum            = 1       # single instance
}

# Short-term subscription
period      = 1
period_unit = "m"
renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
```

### High-availability configuration

```hcl
# High-availability configuration
region   = "ap-guangzhou"
zone     = "ap-guangzhou-1"
pay_mode = "PrePay"

# High-availability KMS configuration
parameter = {
  sv_kms_pg_pro       = true    # professional edition
  sv_kms_exp_data_key = 20000   # 20000 data keys
  autoRenewFlag       = 1       # auto renewal
  goodsNum            = 3       # 3 instances for HA
}

# Annual subscription
period      = 2
period_unit = "y"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Extend create timeout
create_timeout = "45m"
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

# All defaults used: professional edition enabled, 1000 data keys, manual renewal, 1 month, 20m timeout
```

---

## Usage Examples

### Example 1: Finance-grade security configuration

```hcl
# Finance-grade security configuration
region   = "ap-shanghai"
zone     = "ap-shanghai-2"
pay_mode = "PrePay"

# Finance-grade KMS configuration
parameter = {
  sv_kms_pg_pro       = true    # professional edition is mandatory
  sv_kms_exp_data_key = 50000   # large data key pool
  autoRenewFlag       = 1       # ensure continuity
  goodsNum            = 2       # redundant deployment
}

# Long-term stable subscription
period      = 36
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Explicit project ownership
project_id = 88888
```

### Example 2: Multi-business-line shared configuration

```hcl
# Multi-business-line shared configuration
region   = "ap-beijing"
zone     = "ap-beijing-1"
pay_mode = "PrePay"

# Shared KMS configuration
parameter = {
  sv_kms_pg_pro       = true    # professional edition
  sv_kms_exp_data_key = 30000   # supports multiple business lines
  autoRenewFlag       = 1       # auto renewal
  goodsNum            = 1       # centralized management
}

# Annual subscription for budget management
period      = 1
period_unit = "y"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Cost-center project
project_id = 99999
```

### Example 3: Compliance-required configuration

```hcl
# Compliance configuration
region   = "ap-guangzhou"
zone     = "ap-guangzhou-3"
pay_mode = "PrePay"

# Compliance KMS configuration
parameter = {
  sv_kms_pg_pro       = true    # professional edition meets compliance
  sv_kms_exp_data_key = 15000   # sufficient data keys
  autoRenewFlag       = 1       # ensure no interruption
  goodsNum            = 2       # HA deployment
}

# Long-term subscription for audit requirements
period      = 24
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Compliance project identifier
project_id = 77777
```

### Example 4: Cost-optimized configuration

```hcl
# Cost-optimized configuration
region = "ap-chongqing"
zone   = "ap-chongqing-1"

# Cost-optimized KMS configuration
parameter = {
  sv_kms_pg_pro       = true    # keep professional edition
  sv_kms_exp_data_key = 1000    # minimum data key count
  autoRenewFlag       = 0       # manual renewal to control cost
  goodsNum            = 1       # single instance
}

# Monthly subscription for flexible adjustment
period      = 1
period_unit = "m"
renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
```

---

## Configuration Notes

### Feature editions

#### KMS Professional Edition
- **Feature**: full key management — key rotation, access control, audit logs, etc.
- **Use case**: production, compliance, finance-grade security.
- **Default**: enabled (`true`).
- **Recommendation**: enable professional edition in all environments.

#### Extended Data Keys
- **Feature**: increase the number of manageable data keys.
- **Default**: 1000.
- **Range**: scalable per business needs.
- **Cost impact**: more keys cost more.
- **Recommendation**: configure per actual encryption needs.

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

1. **Professional edition**: enable KMS professional edition in all environments.
2. **Auto renewal**: enable auto renewal in production to avoid interruption.
3. **Sufficient quota**: configure enough data keys per business needs.
4. **High availability**: consider multi-instance deployment in production.
5. **Periodic audit**: regularly review KMS usage and security config.
6. **Access control**: strictly manage KMS access permissions.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Edition compatibility**
   - KMS professional edition is the recommended config.
   - Confirm the feature edition meets business needs.
   - Different editions may affect the encryption scheme.

2. **Region limits**
   - KMS is region-specific.
   - Confirm the target region supports KMS.
   - Cross-region key management requires special configuration.

3. **Permission verification**
   - Confirm sufficient permissions to create a KMS instance.
   - Check account quota limits.
   - Verify finance and KMS permissions.

4. **Billing confirmation**
   - PrePay requires upfront payment.
   - Data key count affects cost.
   - Confirm auto-renewal settings.

5. **Quota planning**
   - Plan the data key count reasonably.
   - Avoid over-provisioning and waste.
   - Consider business growth.

6. **Key management**
   - Define a key-management policy.
   - Rotate encryption keys regularly.
   - Back up important key material.

7. **Test & verify**
   - Test KMS features after deployment.
   - Verify encrypt/decrypt operations.
   - Check access control.

8. **Monitoring**
   - Configure KMS service monitoring.
   - Set usage alerts.
   - Monitor security events.

9. **Renewal management**
   - Watch renewal time and cost.
   - Set renewal reminders.
   - Periodically review the renewal strategy.

10. **Compliance**
    - Ensure configuration meets security/compliance requirements.
    - Retain key-operation audit logs.
    - Follow data-encryption regulations.

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
- Check KMS related permissions.
- Request `QcloudKMSFullAccess`.
- Verify finance related permissions.

#### Error 2: Quota limit

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Resource limit exceeded
```

**Cause**: Reached resource count or quota limit.
**Solution**:
- Check the current number of KMS instances.
- Request a quota increase.
- Reduce the data key count configuration.

#### Error 3: Region unavailable

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**Cause**: The selected region does not support KMS.
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

#### Error 7: Data key count exceeded

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Data key count exceeded
```

**Cause**: The data key count exceeds the limit.
**Solution**:
- Reduce the `sv_kms_exp_data_key` value.
- Contact Tencent Cloud for a higher quota.
- Check the current quota usage.

## License

See [LICENSE](../../../../LICENSE) for full details.
