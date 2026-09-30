# Tencent Cloud Cloud Firewall (CFW) VPC Firewall Component

Terraform component under `components/security/cfw/fw-vpc` for configuring and managing the VPC Firewall capability of Tencent Cloud Cloud Firewall (CFW) — as part of the `security` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component configures and manages the Cloud Firewall (CFW) VPC firewall feature. Main capabilities:

- **VPC firewall instance management** – create and manage VPC firewall instance groups.
- **Network mode support** – private network mode and CCN (Cloud Connect Network) mode.
- **Switch mode** – single-point intercommunication, multi-point communication, and custom routing.
- **Multi-region deployment** – deploy firewall instances across regions.
- **Policy control** – define and manage inter-VPC access-control policies.
- **Automatic network planning** – auto or manually configured firewall network segment.
- **CCN integration** – deploy the firewall in a CCN environment.

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
| `QcloudCCNFullAccess` | Access to CCN (CCN mode) |

### Prerequisites

- Plan the VPC firewall working mode (private network / CCN).
- Decide the switch mode (single point / multi-point / custom routing).
- Prepare the VPC ID list.
- Plan the firewall instances' regional deployment.
- Prepare the access-control policy rules.
- For CCN mode, prepare the CCN ID.

---

## Inputs

### Required configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_name"></a> [name](#input\_name) | `string` | yes | – | VPC firewall (group) name. |
| <a name="input_mode"></a> [mode](#input\_mode) | `number` | yes | – | Working mode: `0` = private network mode; `1` = CCN (cloud networking) mode. (Must be `0` or `1`.) |
| <a name="input_switch_mode"></a> [switch\_mode](#input\_switch\_mode) | `number` | yes | – | Switch mode: `1` = single-point intercommunication; `2` = multi-point communication; `4` = custom routing. (Must be `1`, `2`, or `4`.) |
| <a name="input_fw_instances"></a> [fw\_instances](#input\_fw\_instances) | `list(object)` | yes | – | List of firewall instances under the firewall (group). |

### Optional configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_fw_vpc_cidr"></a> [fw\_vpc\_cidr](#input\_fw\_vpc\_cidr) | `string` | no | `auto` | Firewall network segment: `auto` = automatically select; or a user-specified CIDR (e.g. `10.10.10.0/24`). |
| <a name="input_ccn_id"></a> [ccn\_id](#input\_ccn\_id) | `string` | no | `null` | Cloud networking ID (CCN mode). |
| <a name="input_ccn_name"></a> [ccn\_name](#input\_ccn\_name) | `string` | no | `null` | Cloud networking name (CCN mode). |
| <a name="input_vpc_fw_group_id"></a> [vpc\_fw\_group\_id](#input\_vpc\_fw\_group\_id) | `string` | no | `null` | Firewall instance group ID where the rule takes effect. Default is `ALL`. |
| <a name="input_vpc_fw_policies"></a> [vpc\_fw\_policies](#input\_vpc\_fw\_policies) | `list(object)` | no | `[]` | VPC firewall policy list. |

#### Firewall instance object (`fw_instances`)

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Firewall instance name. |
| `fw_deploy` | `list(object)` | yes | – | Firewall deployment configuration. |
| `vpc_ids` | `set(string)` | no | – | Set of VPC IDs. |

#### Firewall deployment object (`fw_deploy`)

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `deploy_region` | `string` | yes | – | Deployment region. |
| `width` | `number` | yes | – | Bandwidth (Mbps). |
| `zone_set` | `set(string)` | yes | – | Availability-zone set. |
| `cross_a_zone` | `number` | no | – | Cross-AZ deployment: `0` = disable, `1` = enable. |

#### Policy object (`vpc_fw_policies`)

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `description` | `string` | yes | – | Policy description. |
| `source_type` | `string` | yes | – | Source type: `net`, `template`. |
| `source_content` | `string` | yes | – | Source content. |
| `dest_type` | `string` | yes | – | Destination type: `net`, `template`, `domain`. |
| `dest_content` | `string` | yes | – | Destination content. |
| `protocol` | `string` | yes | – | Protocol: `TCP`, `UDP`, `ICMP`, `ANY`, `HTTP`, `HTTPS`, `HTTP/HTTPS`, `SMTP`, `SMTPS`, `SMTP/SMTPS`, `FTP`, `DNS`, `TLS/SSL`. |
| `port` | `string` | yes | – | Port. |
| `rule_action` | `string` | yes | – | Action: `accept` (allow), `drop` (deny), `log` (record). |
| `enable` | `string` | no | `true` | Enable status: `true` = enabled, `false` = disabled. |

---

## Configuration Examples

### Basic configuration (private network mode)

```hcl
# Basic configuration
name        = "prod-vpc-fw"
mode        = 0  # private network mode
switch_mode = 1  # single-point intercommunication
fw_vpc_cidr = "auto"  # auto-select the network segment

# Firewall instance configuration
fw_instances = [
  {
    name = "vpc-fw-instance-1"
    fw_deploy = [
      {
        deploy_region = "ap-beijing"
        width         = 1000  # 1Gbps
        zone_set      = ["ap-beijing-1", "ap-beijing-2"]
        cross_a_zone  = 0  # disable cross-AZ
      }
    ]
    vpc_ids = ["vpc-123456", "vpc-789012"]
  }
]

# VPC firewall policies
vpc_fw_policies = [
  {
    description    = "Allow inter-VPC HTTP access"
    source_type    = "net"
    source_content = "vpc:10.1.0.0/16"
    dest_type      = "net"
    dest_content   = "vpc:10.2.0.0/16"
    protocol       = "TCP"
    port           = "80"
    rule_action    = "accept"
    enable         = "true"
  },
  {
    description    = "Block inter-VPC database access"
    source_type    = "net"
    source_content = "vpc:10.1.0.0/16"
    dest_type      = "net"
    dest_content   = "vpc:10.2.0.0/16"
    protocol       = "TCP"
    port           = "3306"
    rule_action    = "drop"
    enable         = "true"
  }
]
```

### CCN mode configuration

```hcl
# CCN mode configuration
name        = "ccn-vpc-fw"
mode        = 1  # CCN mode
switch_mode = 2  # multi-point communication
fw_vpc_cidr = "10.10.10.0/24"  # manually specified network segment
ccn_id      = "ccn-abcdef"  # CCN ID
ccn_name    = "ccn-demo"  # CCN name

# Multi-region firewall instances
fw_instances = [
  {
    name = "ccn-fw-beijing"
    fw_deploy = [
      {
        deploy_region = "ap-beijing"
        width         = 2000  # 2Gbps
        zone_set      = ["ap-beijing-1", "ap-beijing-2"]
        cross_a_zone  = 1  # enable cross-AZ
      }
    ]
  },
  {
    name = "ccn-fw-shanghai"
    fw_deploy = [
      {
        deploy_region = "ap-shanghai"
        width         = 2000  # 2Gbps
        zone_set      = ["ap-shanghai-1", "ap-shanghai-2"]
        cross_a_zone  = 1  # enable cross-AZ
      }
    ]
  }
]

# CCN policy configuration
vpc_fw_policies = [
  {
    description    = "Allow HTTPS access within CCN"
    source_type    = "net"
    source_content = "ccn:0.0.0.0/0"
    dest_type      = "net"
    dest_content   = "ccn:0.0.0.0/0"
    protocol       = "TCP"
    port           = "443"
    rule_action    = "accept"
    enable         = "true"
  }
]
```

### Custom routing mode configuration

```hcl
# Custom routing mode
name        = "custom-route-fw"
mode        = 0  # private network mode
switch_mode = 4  # custom routing
fw_vpc_cidr = "auto"

# Firewall instance configuration
fw_instances = [
  {
    name = "custom-fw-instance"
    fw_deploy = [
      {
        deploy_region = "ap-guangzhou"
        width         = 1000
        zone_set      = ["ap-guangzhou-1"]
        cross_a_zone  = 0
      }
    ]
    vpc_ids = ["vpc-web", "vpc-app", "vpc-db"]
  }
]

# Fine-grained policy configuration
vpc_fw_policies = [
  {
    description    = "Web tier to app tier access"
    source_type    = "net"
    source_content = "vpc:10.1.0.0/16"
    dest_type      = "net"
    dest_content   = "vpc:10.2.0.0/16"
    protocol       = "TCP"
    port           = "8080"
    rule_action    = "accept"
  },
  {
    description    = "App tier to database access"
    source_type    = "net"
    source_content = "vpc:10.2.0.0/16"
    dest_type      = "net"
    dest_content   = "vpc:10.3.0.0/16"
    protocol       = "TCP"
    port           = "3306"
    rule_action    = "accept"
  }
]
```

---

## Usage Examples

### Example 1: Enterprise multi-VPC interconnection

```hcl
# Enterprise multi-VPC environment
name        = "enterprise-vpc-fw"
mode        = 0
switch_mode = 2  # multi-point communication
fw_vpc_cidr = "auto"

# Multi-VPC firewall instance
fw_instances = [
  {
    name = "enterprise-fw"
    fw_deploy = [
      {
        deploy_region = "ap-beijing"
        width         = 3000  # 3Gbps
        zone_set      = ["ap-beijing-1", "ap-beijing-2"]
        cross_a_zone  = 1
      }
    ]
    vpc_ids = ["vpc-prod", "vpc-staging", "vpc-dev", "vpc-mgmt"]
  }
]

# Enterprise-grade policies
vpc_fw_policies = [
  # Strict isolation for production
  {
    description    = "Strict isolation for production environment"
    source_type    = "net"
    source_content = "vpc:10.10.0.0/16"
    dest_type      = "net"
    dest_content   = "vpc:10.20.0.0/16"
    protocol       = "ANY"
    port           = "-1/-1"
    rule_action    = "drop"
  },
  # Dev/test interconnection
  {
    description    = "Dev/test environment interconnection"
    source_type    = "net"
    source_content = "vpc:10.30.0.0/16"
    dest_type      = "net"
    dest_content   = "vpc:10.40.0.0/16"
    protocol       = "ANY"
    port           = "-1/-1"
    rule_action    = "accept"
  }
]
```

### Example 2: CCN multi-region deployment

```hcl
# CCN multi-region deployment
name        = "multi-region-ccn-fw"
mode        = 1
switch_mode = 1  # single-point intercommunication
fw_vpc_cidr = "10.20.30.0/24"
ccn_id      = "ccn-global"
ccn_name    = "ccn-global-demo"

# Multi-region firewall deployment
fw_instances = [
  {
    name = "fw-beijing"
    fw_deploy = [
      {
        deploy_region = "ap-beijing"
        width         = 2000
        zone_set      = ["ap-beijing-1"]
        cross_a_zone  = 0
      }
    ]
  },
  {
    name = "fw-shanghai"
    fw_deploy = [
      {
        deploy_region = "ap-shanghai"
        width         = 2000
        zone_set      = ["ap-shanghai-1"]
        cross_a_zone  = 0
      }
    ]
  },
  {
    name = "fw-guangzhou"
    fw_deploy = [
      {
        deploy_region = "ap-guangzhou"
        width         = 2000
        zone_set      = ["ap-guangzhou-1"]
        cross_a_zone  = 0
      }
    ]
  }
]

# Global policy configuration
vpc_fw_policies = [
  {
    description    = "Global HTTPS access"
    source_type    = "net"
    source_content = "ccn:0.0.0.0/0"
    dest_type      = "net"
    dest_content   = "ccn:0.0.0.0/0"
    protocol       = "TCP"
    port           = "443"
    rule_action    = "accept"
  }
]
```

---

## Configuration Notes

### Working mode

#### Private network mode (mode = 0)
- **Characteristic**: the firewall is deployed inside a private network.
- **Advantage**: fine-grained control of intra-VPC traffic.
- **Use case**: single-VPC or multi-VPC interconnection.
- **Topology**: intra-VPC traffic → VPC firewall → target VPC.

#### CCN mode (mode = 1)
- **Characteristic**: the firewall is deployed in a CCN environment.
- **Advantage**: control of cross-region, cross-account traffic.
- **Use case**: multi-CCN environment, cross-region access control.
- **Requirement**: CCN ID must be configured.
- **Topology**: CCN traffic → VPC firewall → target network.

### Switch mode

#### Single-point intercommunication (switch_mode = 1)
- **Characteristic**: all traffic passes through a single firewall instance.
- **Advantage**: simple configuration, easy management.
- **Use case**: small- and medium-scale environments.
- **Limitation**: single point of failure risk.

#### Multi-point communication (switch_mode = 2)
- **Characteristic**: traffic is load-balanced across multiple firewall instances.
- **Advantage**: high availability, better performance.
- **Use case**: large-scale environments, high-availability requirements.
- **Deployment**: multi-instance deployment.

#### Custom routing (switch_mode = 4)
- **Characteristic**: the firewall path is chosen per routing policy.
- **Advantage**: flexible routing control.
- **Use case**: complex network topology.
- **Requirement**: routing policies must be configured.

### Network segment configuration

- **Automatic (`auto`)**: the system automatically allocates the firewall network segment.
- **Manual**: a user-defined CIDR block (e.g. `10.10.10.0/24`).
- **Caution**: ensure the network segment does not conflict with existing VPCs.

### Policy configuration guide

#### Protocols
- **Basic**: TCP, UDP, ICMP, ANY.
- **Application**: HTTP, HTTPS, SMTP, FTP, DNS, and more.
- **Combinations**: HTTP/HTTPS, SMTP/SMTPS, TLS/SSL.

#### Address type
- **net**: IP/CIDR format, e.g. `vpc:10.0.0.0/8`.
- **template**: parameter template.
- **domain**: domain rule (destination type only).

#### Action
- **accept**: allow traffic.
- **drop**: silently discard traffic.
- **log**: record traffic without blocking.

### Best practices

1. **Mode selection**: choose the appropriate mode per network architecture.
2. **High-availability design**: multi-AZ, multi-region deployment.
3. **Bandwidth planning**: plan per business traffic peak.
4. **Policy minimization**: configure the minimum necessary permissions on demand.
5. **Network isolation**: plan VPCs and network segments reasonably.
6. **Monitoring & alerting**: configure traffic monitoring and anomaly detection.
7. **Periodic audit**: review policies and access logs regularly.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Mode compatibility**
   - Private network mode requires a VPC ID list.
   - CCN mode requires a CCN ID.
   - The mode cannot be changed after selection.

2. **Network configuration**
   - Confirm VPC IDs are correct.
   - Verify CCN ID configuration.
   - Check for network-segment conflicts.

3. **Switch mode**
   - Single-point mode has a single-point-of-failure risk.
   - Multi-point mode requires multi-instance deployment.
   - Custom mode requires routing configuration.

4. **Firewall instance**
   - Ensure the regional deployment meets business needs.
   - Choose bandwidth per business needs.
   - Consider cross-AZ high availability.

5. **Policy configuration**
   - Avoid overly permissive policies.
   - Minimize openings per business needs.
   - Test policies to avoid service interruption.

6. **Dependencies**
   - Policy configuration depends on the firewall instance being created.
   - Ensure sufficient network resource permissions.
   - Check the status of dependent resources.

7. **Performance impact**
   - Complex policies may affect performance.
   - Monitor firewall performance metrics.
   - Adjust the bandwidth spec as needed.

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
- Check CFW, VPC, and CCN related permissions.
- Request the necessary permissions.
- Verify resource operation permissions.

#### Error 2: Network configuration error

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Network configuration error
```

**Cause**: VPC, CCN, or network-segment configuration error.
**Solution**:
- Check whether VPC IDs are correct.
- Verify CCN ID configuration.
- Check for network-segment conflicts.

#### Error 3: Mode configuration error

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Mode configuration error
```

**Cause**: Wrong working mode or switch mode parameter.
**Solution**:
- Check the `mode` value (0 or 1).
- Check the `switch_mode` value (1, 2, 4).
- Confirm the parameters required by the mode are configured.

#### Error 4: Resource not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Resource not found
```

**Cause**: The referenced resource does not exist.
**Solution**:
- Check whether VPC / CCN exist.
- Confirm region configuration is correct.
- Verify resource ID format.

#### Error 5: Policy configuration error

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy configuration error
```

**Cause**: Wrong policy parameter format or value.
**Solution**:
- Check the policy object format.
- Confirm parameter values meet requirements.
- Validate protocol and address types.

## License

See [LICENSE](../../../../LICENSE) for full details.
