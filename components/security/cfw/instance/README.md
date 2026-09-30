# Tencent Cloud Cloud Firewall (CFW) Instance Component

Terraform component under `components/security/cfw/instance` for deploying and managing a Cloud Firewall (CFW) instance in Tencent Cloud — as part of the `security` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component deploys and manages a Cloud Firewall (CFW) instance, providing comprehensive network security protection. Main features:

- **Instance creation** – create and manage a CFW instance.
- **Edition selection** – supports Advanced, Enterprise, and Ultimate editions.
- **Billing management** – PrePay (subscription) mode with flexible purchase duration.
- **Bandwidth configuration** – configure north-south and VPC firewall bandwidth.
- **Log service** – configure log analysis and log storage.
- **Extended features** – full-traffic detection (NDR), network honeypot, address template, and more.
- **Auto renewal** – configure auto-renewal.
- **Multi-region deployment** – deploy in different regions and availability zones.

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
| `QcloudCFWFullAccess` | Full access to Cloud Firewall |
| `QcloudCFWReadOnlyAccess` | Read-only access to Cloud Firewall |
| `QcloudVPCFullAccess` | Access to VPC |

### Prerequisites

- Decide the CFW edition (Advanced / Enterprise / Ultimate).
- Plan bandwidth and log-storage requirements.
- Decide the purchase duration and renewal strategy.
- Select the deployment region and availability zone.
- Configure extended features if needed.
- Prepare the project ID if needed.

---

## Inputs

### Required configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_region"></a> [region](#input\_region) | `string` | yes | – | Deployment region, e.g. `ap-beijing`. |
| <a name="input_zone"></a> [zone](#input\_zone) | `string` | yes | – | Availability zone, e.g. `ap-beijing-1`. |
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

#### Common

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `goodsNum` | `number` | `1` | Goods quantity. |

#### Edition selection

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `sv_cloudfirewall_basic_aeps` | `bool` | `false` | Advanced Edition. |
| `sv_cloudfirewall_basic_eeps` | `bool` | `false` | Enterprise Edition. |
| `sv_cloudfirewall_basic_ueps` | `bool` | `false` | Ultimate Edition. |

#### Log service

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `sv_cloudfirewall_extended_clasps` | `bool` | `false` | Log analysis feature. |
| `sv_cloudfirewall_extended_clsesps` | `number` | `0` | Log storage capacity (GB, step size 1000). |

#### Bandwidth configuration

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `sv_cloudfirewall_extended_ibtesps` | `number` | `0` | North-south protection bandwidth (Mbps, step size 1). |
| `sv_cloudfirewall_extended_vpcbges` | `number` | `0` | VPC firewall bandwidth (Gbps, step size 1). |
| `sv_cloudfirewall_extended_vpc` | `number` | `0` | VPC firewall bandwidth (Mbps, step size 1). |
| `sv_cloudfirewall_extended_ndr` | `number` | `0` | Full-traffic detection and response (NDR) bandwidth (Gbps, step size 1). |

#### Extended features

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `sv_cloudfirewall_extended_pcs` | `number` | `0` | Network honeypot (step size 1). |
| `sv_cloudfirewall_extended_sub` | `number` | `0` | General instance (step size 1). |
| `sv_cloudfirewall_extended_subs` | `number` | `0` | General rule (step size 100). |
| `sv_cloudfirewall_extended_ates` | `number` | `0` | Address template (step size 10). |
| `sv_cloudfirewall_extended_spt` | `bool` | `false` | Critical Protection Toolkit. |

#### Other (purpose not documented in the API)

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `sv_cloudfirewall_extended_ex` | `number` | `0` | Extended feature (purpose unspecified). |
| `sv_cloudfirewall_extended_nats` | `number` | `0` | NAT-related (purpose unspecified). |
| `sv_cloudfirewall_extended_sra` | `number` | `0` | SRA-related (purpose unspecified). |
| `sv_cloudfirewall_extended_srb` | `number` | `0` | SRB-related (purpose unspecified). |

> **Note**: At most one edition flag (`..._aeps` / `..._eeps` / `..._ueps`) should be set to `true`. Setting more than one will trigger a `Version conflict` error.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | CFW instance ID. |

---

## Configuration Examples

### `terraform.tfvars`

```hcl
# Basic configuration
region     = "ap-beijing"
zone       = "ap-beijing-1"
pay_mode   = "PrePay"

# Billing configuration
period      = 12
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Product parameter configuration
parameter = {
  # Edition selection - Enterprise
  sv_cloudfirewall_basic_eeps = true

  # Log service
  sv_cloudfirewall_extended_clasps  = true  # enable log analysis
  sv_cloudfirewall_extended_clsesps = 1000  # 1TB log storage

  # Bandwidth configuration
  sv_cloudfirewall_extended_ibtesps = 100   # 100Mbps north-south bandwidth
  sv_cloudfirewall_extended_vpcbges = 1     # 1Gbps VPC firewall bandwidth

  # Extended features
  sv_cloudfirewall_extended_pcs = 2         # 2 network honeypots
  sv_cloudfirewall_extended_ates = 10       # 10 address templates
  sv_cloudfirewall_extended_spt  = true     # enable Critical Protection Toolkit
}

# Optional configuration
project_id = 123456
```

### Production environment configuration

```hcl
# Production environment configuration
region     = "ap-shanghai"
zone       = "ap-shanghai-2"

# Long-term subscription
period      = 36
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# Production-grade parameters
parameter = {
  # Ultimate edition
  sv_cloudfirewall_basic_ueps = true

  # Full log service
  sv_cloudfirewall_extended_clasps  = true
  sv_cloudfirewall_extended_clsesps = 5000  # 5TB log storage

  # High bandwidth
  sv_cloudfirewall_extended_ibtesps = 1000  # 1Gbps north-south bandwidth
  sv_cloudfirewall_extended_vpcbges = 5     # 5Gbps VPC firewall bandwidth
  sv_cloudfirewall_extended_ndr     = 2     # 2Gbps full-traffic detection

  # Advanced security features
  sv_cloudfirewall_extended_pcs  = 5        # 5 network honeypots
  sv_cloudfirewall_extended_subs = 500      # 500 general rules
  sv_cloudfirewall_extended_ates = 50       # 50 address templates
  sv_cloudfirewall_extended_spt  = true     # Critical Protection Toolkit
}

project_id = 789012
```

### Testing environment configuration

```hcl
# Testing environment configuration
region = "ap-guangzhou"
zone   = "ap-guangzhou-1"

# Short-term subscription
period      = 1
period_unit = "m"

# Basic parameters
parameter = {
  # Advanced edition
  sv_cloudfirewall_basic_aeps = true

  # Basic log service
  sv_cloudfirewall_extended_clsesps = 100  # 100GB log storage

  # Basic bandwidth
  sv_cloudfirewall_extended_ibtesps = 10   # 10Mbps north-south bandwidth
  sv_cloudfirewall_extended_vpc     = 100  # 100Mbps VPC firewall bandwidth
}
```

### Minimal configuration

```hcl
# Minimal configuration
region = "ap-beijing"
zone   = "ap-beijing-3"

parameter = {
  # Advanced edition only
  sv_cloudfirewall_basic_aeps = true

  # Minimum bandwidth
  sv_cloudfirewall_extended_ibtesps = 1  # 1Mbps north-south bandwidth
}
```

---

## Usage Examples

### Example 1: Enterprise CFW deployment

```hcl
# Enterprise CFW configuration
region     = "ap-shanghai"
zone       = "ap-shanghai-2"
period     = 24  # 2 years
period_unit = "m"

parameter = {
  # Enterprise edition
  sv_cloudfirewall_basic_eeps = true

  # Enterprise log
  sv_cloudfirewall_extended_clasps  = true  # log analysis
  sv_cloudfirewall_extended_clsesps = 2000  # 2TB storage

  # Enterprise bandwidth
  sv_cloudfirewall_extended_ibtesps = 500   # 500Mbps north-south
  sv_cloudfirewall_extended_vpcbges = 2     # 2Gbps VPC firewall

  # Enterprise security features
  sv_cloudfirewall_extended_pcs  = 3        # 3 honeypots
  sv_cloudfirewall_extended_ates = 20       # 20 address templates
  sv_cloudfirewall_extended_spt  = true     # critical protection
}

project_id = 100001
```

### Example 2: Finance high-security configuration

```hcl
# Finance CFW configuration
region     = "ap-beijing"
zone       = "ap-beijing-1"
period     = 36  # max 3-year subscription

parameter = {
  # Ultimate edition, highest security
  sv_cloudfirewall_basic_ueps = true

  # Complete audit log
  sv_cloudfirewall_extended_clasps  = true
  sv_cloudfirewall_extended_clsesps = 10000 # 10TB log storage

  # High bandwidth
  sv_cloudfirewall_extended_ibtesps = 2000  # 2Gbps north-south
  sv_cloudfirewall_extended_vpcbges = 10    # 10Gbps VPC firewall
  sv_cloudfirewall_extended_ndr     = 5     # 5Gbps full-traffic detection

  # Advanced threat protection
  sv_cloudfirewall_extended_pcs  = 10       # 10 network honeypots
  sv_cloudfirewall_extended_subs = 1000     # 1000 rules
  sv_cloudfirewall_extended_ates = 100      # 100 address templates
  sv_cloudfirewall_extended_spt  = true     # Critical Protection Toolkit
}

project_id = 200002
```

### Example 3: Multi-VPC network protection

```hcl
# Multi-VPC environment CFW configuration
region = "ap-guangzhou"
zone   = "ap-guangzhou-3"

parameter = {
  # Enterprise edition supports multi-VPC
  sv_cloudfirewall_basic_eeps = true

  # VPC firewall configuration
  sv_cloudfirewall_extended_vpcbges = 3     # 3Gbps total bandwidth
  sv_cloudfirewall_extended_vpc     = 500   # 500Mbps per VPC

  # Centralized log management
  sv_cloudfirewall_extended_clasps  = true
  sv_cloudfirewall_extended_clsesps = 3000  # 3TB storage

  # Unified security policy
  sv_cloudfirewall_extended_subs = 300      # 300 unified rules
  sv_cloudfirewall_extended_ates = 30       # 30 shared address templates
}

project_id = 300003
```

### Example 4: Development / testing environment

```hcl
# Dev/test CFW configuration
region = "ap-shanghai"
zone   = "ap-shanghai-4"

# Monthly subscription for flexibility
period      = 1
period_unit = "m"

parameter = {
  # Advanced edition is enough
  sv_cloudfirewall_basic_aeps = true

  # Basic bandwidth
  sv_cloudfirewall_extended_ibtesps = 50    # 50Mbps
  sv_cloudfirewall_extended_vpc     = 50    # 50Mbps

  # Basic log
  sv_cloudfirewall_extended_clsesps = 500   # 500GB storage

  # Test features
  sv_cloudfirewall_extended_pcs = 1         # 1 honeypot for testing
}

project_id = 400004
```

---

## Configuration Notes

### Edition comparison

| Edition | Field | Protection | Use case | Price level |
|---------|-------|------------|----------|-------------|
| **Advanced** | `sv_cloudfirewall_basic_aeps` | Basic protection | Small business, test env | Low |
| **Enterprise** | `sv_cloudfirewall_basic_eeps` | Enhanced + multi-VPC | Medium business, production | Medium |
| **Ultimate** | `sv_cloudfirewall_basic_ueps` | Full + advanced features | Large business, finance | High |

### Bandwidth configuration guide

#### North-south bandwidth (`sv_cloudfirewall_extended_ibtesps`)
- **Unit**: Mbps.
- **Step**: 1.
- **Suggestion**: configure 50–70% of the internet egress bandwidth.
- **Example**: 100Mbps egress → configure 50–70Mbps.

#### VPC firewall bandwidth (`sv_cloudfirewall_extended_vpcbges`)
- **Unit**: Gbps.
- **Step**: 1.
- **Suggestion**: configure per inter-VPC traffic peak.
- **Example**: multi-VPC → configure 1–5Gbps.

#### Full-traffic detection bandwidth (`sv_cloudfirewall_extended_ndr`)
- **Unit**: Gbps.
- **Step**: 1.
- **Feature**: deep traffic analysis and threat detection.
- **Use case**: high-security scenarios.

### Log storage configuration

#### Log analysis (`sv_cloudfirewall_extended_clasps`)
- **Feature**: enable intelligent log analysis and threat detection.
- **Suggestion**: recommended for production.
- **Cost**: additional charge.

#### Log storage (`sv_cloudfirewall_extended_clsesps`)
- **Unit**: GB.
- **Step**: 1000 (starts at 1TB).
- **Retention**: depends on storage capacity.
- **Suggestion**: estimate per 30 days of traffic.

### Advanced features

#### Network honeypot (`sv_cloudfirewall_extended_pcs`)
- **Feature**: deploy decoy systems to detect attackers.
- **Use case**: high-threat environments.
- **Count**: per network scale.

#### Address template (`sv_cloudfirewall_extended_ates`)
- **Feature**: custom IP address groups for policies.
- **Step**: 10.
- **Use case**: complex policy management.

#### Critical Protection Toolkit (`sv_cloudfirewall_extended_spt`)
- **Feature**: enhanced protection for critical assets.
- **Includes**: advanced threat intelligence, zero-trust access, etc.
- **Use case**: critical business systems.

### Billing mode

#### PrePay (subscription)
- **Advantage**: discounts, controllable cost.
- **Duration**: 1–36 months.
- **Renewal**: auto-renewal supported.
- **Use case**: long-running, stable workloads.

#### Renewal strategy
- **Auto renewal**: high business-continuity requirement.
- **Manual renewal**: flexible control needed.
- **Disabled renewal**: temporary testing use.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Edition selection**
   - Confirm the edition meets business and compliance requirements.
   - Ultimate provides the most comprehensive security features.
   - Advanced is suitable for testing and small applications.

2. **Bandwidth planning**
   - Estimate north-south and inter-VPC traffic accurately.
   - Leave 20–30% bandwidth headroom.
   - Monitor usage and adjust in time.

3. **Log storage**
   - Determine retention per compliance requirements.
   - Consider log analysis needs.
   - Monitor storage usage.

4. **Region selection**
   - Choose the region closest to your business.
   - Confirm the region supports required features.
   - Consider cross-region traffic cost.

5. **Permission verification**
   - Confirm sufficient CFW operation permissions.
   - Check finance-related permissions.
   - Verify VPC network permissions.

6. **Network configuration**
   - Confirm VPC network configuration is correct.
   - Check route table configuration.
   - Verify network connectivity.

7. **Cost control**
   - Configure bandwidth reasonably to avoid over-provisioning.
   - Choose an appropriate subscription duration.
   - Monitor actual resource usage.

8. **Feature compatibility**
   - Confirm selected features are available in the edition.
   - Check feature dependencies.
   - Verify regional feature support.

9. **Security & compliance**
   - Ensure configuration meets security standards.
   - Retain enough logs for auditing.
   - Follow industry compliance requirements.

10. **Change management**
    - Test thoroughly before production changes.
    - Prepare a rollback plan.
    - Record change operation logs.

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
- Check CFW related permissions.
- Request `QcloudCFWFullAccess`.
- Verify finance permissions.

#### Error 2: Region not supported

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**Cause**: The selected region does not support CFW.
**Solution**:
- Check region availability.
- Choose a supported region.
- Contact Tencent Cloud support.

#### Error 3: Invalid parameter configuration

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid parameter configuration
```

**Cause**: Wrong parameter format or value.
**Solution**:
- Check the `parameter` object format.
- Confirm parameter values meet requirements.
- Validate step and unit.

#### Error 4: Version conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Version conflict
```

**Cause**: More than one edition selected.
**Solution**:
- Select only one edition (`aeps` / `eeps` / `ueps`).
- Check parameter configuration.

#### Error 5: Resource quota exceeded

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Resource quota exceeded
```

**Cause**: Exceeds resource quota limits.
**Solution**:
- Check current resource usage.
- Request a quota increase.
- Adjust configuration parameters.

#### Error 6: Network configuration error

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Network configuration error
```

**Cause**: VPC or network configuration error.
**Solution**:
- Check VPC configuration.
- Verify network connectivity.
- Check security group rules.

#### Error 7: Payment account issue

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Payment account issue
```

**Cause**: Abnormal financial account status.
**Solution**:
- Check account balance.
- Verify payment method.
- Contact finance support.

## License

See [LICENSE](../../../../LICENSE) for full details.
