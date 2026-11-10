# Tencent Cloud Cloud Firewall (CFW) VPC Firewall Route Reconfiguration Component

Terraform component under `components/security/cfw/fw-vpc-route-reconfig` for configuring and managing VPC firewall route reconfiguration of Tencent Cloud Cloud Firewall (CFW) — as part of the `security` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component reconfigures the routes associated with a VPC firewall instance. Main capabilities:

- **Route reconfiguration** – automatically reconfigure the route table entries associated with the VPC firewall.
- **HAVIP support** – use a High-Availability Virtual IP (HAVIP) as the route next hop.
- **VPC integration** – seamless integration with the VPC firewall.
- **Gateway management** – manage the VPC firewall gateway route configuration.
- **Automated deployment** – automate the route reconfiguration workflow.

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
| `QcloudCFWFullAccess` | Full access to Cloud Firewall |
| `QcloudVPCFullAccess` | Access to VPC |
| `QcloudHAVIPFullAccess` | Access to HAVIP |

### Prerequisites

- A VPC firewall instance must already be deployed.
- Obtain the VPC ID of the VPC firewall.
- Obtain the gateway ID of the VPC firewall.
- Confirm the network topology and routing requirements.
- Plan the HAVIP configuration (if applicable).

---

## Inputs

### Required configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | `string` | yes | – | VPC ID of the VPC firewall. |
| <a name="input_gateway_id"></a> [gateway\_id](#input\_gateway\_id) | `string` | yes | – | Gateway ID of the VPC firewall. |

> **Note on route next hop**: The route entries created by this component use a High-Availability Virtual IP (HAVIP) as the next hop (`route_next_type = HAVIP`). This is fixed module behavior, not a user-input variable — only `vpc_id` and `gateway_id` are configurable inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_item_ids"></a> [route\_item\_ids](#output\_route\_item\_ids) | List of route item IDs (`route_item_id`) created for the HAVIP route entries. |

---

## Configuration Examples

### `terraform.tfvars`

```hcl
# VPC firewall route reconfiguration
vpc_id     = "vpc-abcdef123456"  # VPC ID of the VPC firewall
gateway_id = "vpngw-1234567890"  # Gateway ID of the VPC firewall
```

### Standalone module usage

```hcl
# Reference the VPC firewall route reconfiguration component
module "vpc_fw_route_reconfig" {
  source = "../components/security/cfw/fw-vpc-route-reconfig"

  vpc_id     = "vpc-abcdef123456"  # from the VPC firewall component
  gateway_id = "vpngw-1234567890"  # from the VPC firewall component
}

# Output the reconfiguration result
output "route_reconfig_status" {
  description = "VPC firewall route reconfiguration status"
  value       = module.vpc_fw_route_reconfig
}
```

### Integration with the VPC firewall component

```hcl
# Deploy the VPC firewall
module "vpc_firewall" {
  source = "../components/security/cfw/fw-vpc"

  name        = "prod-vpc-fw"
  mode        = 0
  switch_mode = 1
  fw_vpc_cidr = "auto"

  fw_instances = [
    {
      name = "vpc-fw-instance"
      fw_deploy = [
        {
          deploy_region = "ap-beijing"
          width         = 1000
          zone_set      = ["ap-beijing-1", "ap-beijing-2"]
          cross_a_zone  = 0
        }
      ]
      vpc_ids = ["vpc-abcdef123456"]
    }
  ]
}

# Deploy route reconfiguration
module "vpc_fw_route_reconfig" {
  source = "../components/security/cfw/fw-vpc-route-reconfig"

  # Note: the fw-vpc component exposes `vpc_instances` as a LIST, so index it
  # and verify the exact attribute names against the fw-vpc outputs.
  vpc_id     = module.vpc_firewall.vpc_instances[0].vpc_id
  gateway_id = module.vpc_firewall.vpc_instances[0].gateway_id
}
```

---

## Usage Examples

### Example 1: Production route reconfiguration

```hcl
# Production VPC firewall
module "prod_vpc_fw" {
  source = "../components/security/cfw/fw-vpc"

  name        = "prod-vpc-fw"
  mode        = 0
  switch_mode = 2  # multi-point communication
  fw_vpc_cidr = "10.20.30.0/24"

  fw_instances = [
    {
      name = "prod-fw-instance"
      fw_deploy = [
        {
          deploy_region = "ap-beijing"
          width         = 2000
          zone_set      = ["ap-beijing-1", "ap-beijing-2"]
          cross_a_zone  = 1
        }
      ]
      vpc_ids = ["vpc-prod-123456"]
    }
  ]
}

# Production route reconfiguration
module "prod_route_reconfig" {
  source = "../components/security/cfw/fw-vpc-route-reconfig"

  vpc_id     = module.prod_vpc_fw.vpc_instances[0].vpc_id
  gateway_id = module.prod_vpc_fw.vpc_instances[0].gateway_id
}
```

### Example 2: Multi-VPC route reconfiguration

```hcl
# Multi-VPC firewall deployment
module "multi_vpc_fw" {
  source = "../components/security/cfw/fw-vpc"

  name        = "multi-vpc-fw"
  mode        = 0
  switch_mode = 4  # custom routing
  fw_vpc_cidr = "auto"

  fw_instances = [
    {
      name = "multi-fw-instance"
      fw_deploy = [
        {
          deploy_region = "ap-shanghai"
          width         = 3000
          zone_set      = ["ap-shanghai-1", "ap-shanghai-2"]
          cross_a_zone  = 1
        }
      ]
      vpc_ids = ["vpc-web-123", "vpc-app-456", "vpc-db-789"]
    }
  ]
}

# Multi-VPC route reconfiguration
module "multi_route_reconfig" {
  source = "../components/security/cfw/fw-vpc-route-reconfig"

  vpc_id     = module.multi_vpc_fw.vpc_instances[0].vpc_id
  gateway_id = module.multi_vpc_fw.vpc_instances[0].gateway_id
}
```

---

## Configuration Notes

### Feature description

#### Route reconfiguration
- **Automatic route optimization**: automatically reconfigure the route table entries associated with the VPC firewall.
- **HAVIP integration**: use a High-Availability Virtual IP as the route next hop.
- **Failover**: support high availability and failover capability.
- **Performance optimization**: optimize network traffic paths and improve performance.

#### HAVIP (High-Availability Virtual IP)
- **High availability**: provides HA guarantee for the virtual IP.
- **Load balancing**: supports traffic load balancing.
- **Failure detection**: automatically detects and switches over failed nodes.
- **Transparent switchover**: transparent to upper-layer applications, no configuration change required.

### Workflow

1. **Obtain VPC information**: get the VPC ID and gateway ID from the VPC firewall component.
2. **Route analysis**: analyze the current route configuration and optimization needs.
3. **Reconfiguration execution**: execute the route reconfiguration operation.
4. **HAVIP configuration**: configure the HAVIP as the next hop.
5. **Verification**: verify the route reconfiguration result.

### Integration architecture

```
+----------------+      +------------------------+      +-------------------+
| VPC firewall   | ---> | Route reconfig         | ---> | Network route     |
| (fw-vpc)       |      | (fw-vpc-route-reconfig)|      | table             |
+----------------+      +------------------------+      +-------------------+
       |                         |                         |
       v                         v                         v
+----------------+      +------------------------+      +-------------------+
| VPC instance   |      | HAVIP config           |      | Optimized routes  |
| info           |      |                        |      |                   |
+----------------+      +------------------------+      +-------------------+
```

### Best practices

1. **Deployment order**: deploy the VPC firewall first, then the route reconfiguration.
2. **Dependency management**: ensure the route reconfiguration component depends on the VPC firewall output.
3. **Test & verify**: verify the route configuration and network connectivity after deployment.
4. **Monitoring & alerting**: configure route-change monitoring and anomaly alerts.
5. **Backup & recovery**: back up route configuration regularly and prepare a recovery plan.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Dependencies**
   - This component depends on the VPC firewall outputs.
   - Ensure the VPC firewall is deployed successfully.
   - Verify the correctness of the VPC ID and gateway ID.

2. **Network impact**
   - Route reconfiguration may affect network connectivity.
   - Execute during off-peak business hours.
   - Prepare a rollback plan.

3. **HAVIP configuration**
   - Confirm the HAVIP feature is enabled.
   - Check the HAVIP quota and limits.
   - Verify HAVIP high availability.

4. **Permissions**
   - Requires VPC, CFW, and HAVIP related permissions.
   - Verify that operation permissions are sufficient.
   - Check resource operation limits.

5. **Regional limits**
   - Confirm the region supports the HAVIP feature.
   - Check cross-region network connectivity.
   - Verify cross-region deployment requirements.

6. **Compatibility**
   - Confirm Terraform version compatibility.
   - Check the provider version requirement.
   - Verify module version compatibility.

7. **Monitoring & alerting**
   - Configure route-change monitoring.
   - Set anomaly alert thresholds.
   - Monitor network performance metrics.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: VPC firewall not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=VPC firewall not found
```

**Cause**: The specified VPC ID or gateway ID does not exist.
**Solution**:
- Check whether the VPC firewall is deployed.
- Verify the correctness of the VPC ID and gateway ID.
- Confirm the VPC firewall status is normal.

#### Error 2: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=PermissionDenied
Message=Insufficient permissions
```

**Cause**: The current account lacks sufficient permissions.
**Solution**:
- Check CFW, VPC, and HAVIP related permissions.
- Request the necessary permissions.
- Verify resource operation permissions.

#### Error 3: HAVIP not supported

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=HAVIP not supported
```

**Cause**: The current region does not support the HAVIP feature.
**Solution**:
- Check whether the region supports HAVIP.
- Confirm the HAVIP feature is enabled.
- Contact technical support to confirm support.

#### Error 4: Route configuration conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Route configuration conflict
```

**Cause**: A route configuration conflict exists.
**Solution**:
- Check the existing route configuration.
- Resolve the route conflict.
- Re-run the route reconfiguration.

#### Error 5: Network timeout

```
Error: [TencentCloudSDKError] Code=RequestTimeout
Message=Network timeout
```

**Cause**: Network connection timeout.
**Solution**:
- Check network connectivity.
- Retry the operation.
- Adjust the timeout configuration.

## License

See [LICENSE](../../../../LICENSE) for full details.