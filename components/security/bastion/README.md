# Tencent Cloud Bastion Host (BH) Component

Terraform component under `components/security/bastion` for deploying and managing Tencent Cloud Bastion Host (BH) — providing secure remote access management — as part of the `security` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component deploys and manages a Bastion Host instance, providing centralized and secure remote access management. Main features:

- **VPC network integration** – deploy into an existing VPC/subnet via `vpc_id`, `subnet_id`, and `vpc_cidr_block`.
- **Bastion deployment** – deploy a standard-edition Bastion Host instance.
- **Access control** – configure both intranet (`intranet_access`) and external (`external_access`) access.
- **Billing management** – prepaid (monthly subscription) billing mode is supported.
- **Auto-renewal** – enable auto-renewal with `auto_renew_flag`.
- **Multi-node deployment** – `resource_node` supports a multi-node high-availability deployment.
- **Tag management** – classify resources with tags.
- **Resource output** – output the Bastion Host resource ID for later management.

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
| `QcloudBastionHostFullAccess` | Full access to Bastion Host |
| `QcloudVPCFullAccess` | Full access to VPC |
| `QcloudFinanceFullAccess` | Full access to finance management |
| `QcloudTagFullAccess` | Full access to Tag management |
| `QcloudBillingReadOnlyAccess` | Read-only access to billing |

### Prerequisites

- Decide the deployment region and availability zone.
- Plan the VPC network CIDR and subnet segmentation.
- Decide the Bastion Host edition and node count.
- Decide the billing period and renewal strategy.
- Plan the access control policy (intranet / external).
- Prepare the tag classification scheme.

---

## Inputs

### Mandatory configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_deploy_region"></a> [deploy\_region](#input\_deploy\_region) | `string` | yes | – | Region to deploy the BH resource. |
| <a name="input_deploy_zone"></a> [deploy\_zone](#input\_deploy\_zone) | `string` | yes | – | Availability zone to deploy the BH resource. |

### Bastion Host configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | `string` | no | `null` | The CIDR block for the resource. |
| <a name="input_resource_edition"></a> [resource\_edition](#input\_resource\_edition) | `string` | no | `null` | The edition of the BH resource (e.g., `standard`). |
| <a name="input_resource_node"></a> [resource\_node](#input\_resource\_node) | `number` | no | `null` | The number of nodes for the BH resource. |
| <a name="input_time_unit"></a> [time\_unit](#input\_time\_unit) | `string` | no | `null` | The unit of the purchase time (`m` for month). |
| <a name="input_time_span"></a> [time\_span](#input\_time\_span) | `number` | no | `null` | The length of purchase (e.g., `1`). |
| <a name="input_pay_mode"></a> [pay\_mode](#input\_pay\_mode) | `number` | no | `1` | The pay mode (`1` for prepaid). |
| <a name="input_auto_renew_flag"></a> [auto\_renew\_flag](#input\_auto\_renew\_flag) | `number` | no | `1` | Whether to enable auto-renewal (`1` for enable). |
| <a name="input_intranet_access"></a> [intranet\_access](#input\_intranet\_access) | `number` | no | `1` | Whether to enable intranet access (`1` for enable). |
| <a name="input_external_access"></a> [external\_access](#input\_external\_access) | `number` | no | `1` | Whether to enable external access (`1` for enable). |

### Existing VPC configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | `string` | no | `null` | The ID of the VPC. |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | `string` | no | `null` | The name of the VPC. |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | `string` | no | `null` | The ID of the subnet within the VPC. |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | `string` | no | `null` | The CIDR block for the VPC. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | Bastion Resource ID. |

---

## Configuration Examples

### Production (multi-node, intranet only)

```hcl
# Basic configuration
deploy_region = "ap-guangzhou"
deploy_zone   = "ap-guangzhou-3"

# Existing VPC configuration
vpc_id         = "vpc-prod-123"
subnet_id      = "subnet-bastion-456"
vpc_cidr_block = "10.10.0.0/16"

# Bastion Host configuration
cidr_block       = "10.10.1.0/24"
resource_edition = "standard"
resource_node    = 2       # 2-node high availability
time_unit        = "m"
time_span        = 36      # 3 years
pay_mode         = 1
auto_renew_flag  = 1       # auto-renew
intranet_access  = 1
external_access  = 0       # intranet only in production
```

### Use existing VPC

```hcl
# Basic configuration
deploy_region = "ap-shanghai"
deploy_zone   = "ap-shanghai-1"

# Existing VPC configuration
vpc_id         = "vpc-12345678"
subnet_id      = "subnet-12345678"
vpc_cidr_block = "192.168.0.0/16"

# Bastion Host configuration
cidr_block       = "192.168.10.0/24"
resource_edition = "standard"
resource_node    = 1
time_unit        = "m"
time_span        = 6
pay_mode         = 1
auto_renew_flag  = 0
intranet_access  = 1
external_access  = 1
```

### Minimal configuration

```hcl
# Basic configuration
deploy_region = "ap-beijing"
deploy_zone   = "ap-beijing-1"

# Minimal Bastion Host configuration (defaults:
# prepaid, auto-renew, intranet access enabled, external access enabled)
resource_edition = "standard"
resource_node    = 1
time_unit        = "m"
time_span        = 1
```

### High availability (multi-node, multi-AZ style)

```hcl
# Basic configuration
deploy_region = "ap-guangzhou"
deploy_zone   = "ap-guangzhou-1"

# Existing VPC configuration
vpc_id         = "vpc-ha-123"
subnet_id      = "subnet-ha-bastion-456"
vpc_cidr_block = "10.100.0.0/16"

# High availability Bastion Host configuration
cidr_block       = "10.100.1.0/24"
resource_edition = "standard"
resource_node    = 3       # 3-node HA
time_unit        = "m"
time_span        = 12
pay_mode         = 1
auto_renew_flag  = 1
intranet_access  = 1
external_access  = 0
```

### Development environment

```hcl
# Basic configuration
deploy_region = "ap-shanghai"
deploy_zone   = "ap-shanghai-2"

# Existing VPC configuration
vpc_id         = "vpc-dev-123"
subnet_id      = "subnet-dev-bastion-456"
vpc_cidr_block = "10.200.0.0/16"

# Dev Bastion Host configuration
cidr_block       = "10.200.1.0/24"
resource_edition = "standard"
resource_node    = 1
time_unit        = "m"
time_span        = 1       # 1 month
pay_mode         = 1
auto_renew_flag  = 0       # manual renew
intranet_access  = 1
external_access  = 1       # external access enabled in dev
```

---

## Usage Examples

### Example 1: Production Bastion Host deployment

```hcl
# Production Bastion Host configuration
deploy_region = "ap-guangzhou"
deploy_zone   = "ap-guangzhou-3"

# Production VPC configuration
vpc_id         = "vpc-prod-bh"
subnet_id      = "subnet-prod-bh"
vpc_cidr_block = "10.10.0.0/16"

# Production Bastion Host configuration
cidr_block       = "10.10.1.0/24"
resource_edition = "standard"
resource_node    = 2       # dual-node HA
time_unit        = "m"
time_span        = 36
pay_mode         = 1
auto_renew_flag  = 1
intranet_access  = 1
external_access  = 0       # external disabled in production

vpc_name = "prod_bastion_vpc"
```

### Example 2: Hybrid-cloud Bastion Host

```hcl
# Hybrid-cloud configuration
deploy_region = "ap-beijing"
deploy_zone   = "ap-beijing-1"

# Use existing enterprise VPC
vpc_id         = "vpc-enterprise-123"
subnet_id      = "subnet-bastion-456"
vpc_cidr_block = "172.16.0.0/16"

# Hybrid-cloud Bastion Host configuration
cidr_block       = "172.16.100.0/24"
resource_edition = "standard"
resource_node    = 1
time_unit        = "m"
time_span        = 12
pay_mode         = 1
auto_renew_flag  = 1
intranet_access  = 1
external_access  = 1       # external access needed for hybrid cloud
```

### Example 3: Hardened Bastion Host

```hcl
# Hardened configuration
deploy_region = "ap-shanghai"
deploy_zone   = "ap-shanghai-1"

# Secure VPC configuration
vpc_id         = "vpc-secure-123"
subnet_id      = "subnet-secure-bh-456"
vpc_cidr_block = "192.168.0.0/16"

# Secure Bastion Host configuration
cidr_block       = "192.168.100.0/24"
resource_edition = "standard"
resource_node    = 1
time_unit        = "m"
time_span        = 12
pay_mode         = 1
auto_renew_flag  = 0       # manual renew for auditability
intranet_access  = 1
external_access  = 0       # strictly disable external access
```

---

## Configuration Notes

### VPC integration

This component deploys the Bastion Host into an existing VPC/subnet. Provide `vpc_id`, `subnet_id`, and `vpc_cidr_block` to integrate with an existing network.

- **Use case**: integrate with an existing network environment.
- **Advantage**: reuse existing network resources for fast deployment.
- **Caution**: ensure the VPC and subnet IDs are correct and in the same region as `deploy_region`.

### Access control policy

#### Intranet access (`intranet_access = 1`)
- **Enabled by default**: recommended for production.
- **Security level**: higher; intranet-only access.
- **Use case**: internal management, jump-host access.

#### External access (`external_access = 1`)
- **Enabled by default**: disable it in production.
- **Security level**: lower; exposes a public-network risk.
- **Use case**: temporary access, dev/test.

### Billing mode

#### Prepaid (`pay_mode = 1`)
- **Charging**: upfront payment.
- **Cost advantage**: lower cost for long-term use.
- **Use case**: stable business environments.

#### Auto-renewal (`auto_renew_flag = 1`)
- **Convenience**: avoids service interruption.
- **Cost control**: watch the budget.
- **Audit requirement**: some environments require manual renewal.

### High availability deployment

#### Single node (`resource_node = 1`)
- **Use case**: dev/test.
- **Cost**: lower.
- **Availability**: single point of failure.

#### Multi-node (`resource_node >= 2`)
- **Use case**: production.
- **Cost**: higher.
- **Availability**: high availability with failover.

### Region selection

| Region | Code | Use case | Latency |
|--------|------|----------|---------|
| **South China** | ap-guangzhou | Users in South China | Low |
| **East China** | ap-shanghai | Users in East China | Low |
| **North China** | ap-beijing | Users in North China | Low |
| **Southwest China** | ap-chongqing | Users in Southwest China | Medium |

### Security best practices

1. **Network isolation**: place the Bastion Host in a dedicated VPC or subnet.
2. **Access control**: disable external access in production.
3. **Audit logging**: enable Bastion Host operation logs.
4. **Credential rotation**: rotate access credentials regularly.
5. **Least privilege**: follow the principle of least privilege.
6. **Monitoring & alerting**: set up abnormal-access alerts.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Network planning**
   - Plan the VPC CIDR in advance to avoid IP conflicts.
   - Ensure the subnet CIDR is within the VPC CIDR range.
   - Consider future expansion needs.

2. **Region limits**
   - The Bastion Host service is region-specific.
   - The VPC and Bastion Host must be in the same region.
   - Cross-region access requires extra configuration.

3. **Permission verification**
   - Confirm sufficient permission to create a Bastion Host.
   - Check account quota limits.
   - Verify network permissions.

4. **Billing confirmation**
   - Prepaid requires an upfront payment.
   - Confirm the auto-renewal setting.
   - Note the impact of node count on cost.

5. **Access policy**
   - Disable external access in production.
   - Configure strict security group rules.
   - Enable multi-factor authentication.

6. **High availability**
   - Use multi-node deployment in production.
   - Consider cross-AZ deployment.
   - Configure automatic failover.

7. **Tag management**
   - Follow a consistent tag naming convention.
   - Use tags for cost allocation.
   - Use tags for resource management.

8. **Testing**
   - Test Bastion Host connectivity after deployment.
   - Verify network reachability.
   - Test the access control policy.

9. **Monitoring**
   - Configure Bastion Host monitoring.
   - Set performance-threshold alerts.
   - Monitor abnormal access behavior.

10. **Backup strategy**
    - Back up Bastion Host configuration regularly.
    - Define a disaster recovery plan.
    - Test the recovery procedure.

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
- Check Bastion Host related permissions.
- Request `QcloudBastionHostFullAccess`.
- Verify VPC related permissions.

#### Error 2: Resource limit exceeded

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Resource limit exceeded
```

**Cause**: The resource count limit has been reached.
**Solution**:
- Check the current number of Bastion Host instances.
- Request a quota increase.
- Choose a lower spec.

#### Error 3: Network conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=CIDR block conflict
```

**Cause**: CIDR block conflict.
**Solution**:
- Check whether the VPC CIDR conflicts.
- Change the CIDR block configuration.
- Use a different IP range.

#### Error 4: Region not available

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**Cause**: The selected region does not support Bastion Host.
**Solution**:
- Check region availability.
- Choose a supported region.
- Contact Tencent Cloud support.

#### Error 5: VPC not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=VPC not found
```

**Cause**: The specified VPC does not exist.
**Solution**:
- Check whether the VPC ID is correct.
- Confirm the VPC exists in the target region.

#### Error 6: Subnet not found

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Subnet not found
```

**Cause**: The specified subnet does not exist.
**Solution**:
- Check whether the subnet ID is correct.
- Confirm the subnet exists in the target VPC.

## License

See [LICENSE](../../../LICENSE) for full details.