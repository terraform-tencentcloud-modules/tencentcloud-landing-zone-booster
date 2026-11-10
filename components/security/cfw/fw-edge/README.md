# Tencent Cloud Cloud Firewall (CFW) Edge Firewall Component

Terraform component under `components/security/cfw/fw-edge` for configuring and managing the Edge Firewall capability of Tencent Cloud Cloud Firewall (CFW) — as part of the `security` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component configures and manages the Cloud Firewall (CFW) edge firewall feature. Main capabilities:

- **Asset sync** – automatically synchronize cloud asset information to the firewall.
- **Edge switch management** – configure and manage the edge firewall switch status.
- **Inbound policy** – define and manage inbound traffic access-control policies.
- **Outbound policy** – define and manage outbound traffic access-control policies.
- **Multi-mode support** – bypass and serial working modes.
- **Fine-grained control** – multi-dimensional access control based on IP, port, protocol, and region.

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
| `QcloudCFWReadOnlyAccess` | Read-only access to Cloud Firewall |
| `QcloudVPCFullAccess` | Access to VPC |
| `QcloudCVMFullAccess` | Access to CVM |
| `QcloudEIPFullAccess` | Access to EIP |

### Prerequisites

- A Cloud Firewall instance must already be created.
- Decide the edge firewall working mode (bypass / serial).
- Plan the network topology and traffic path.
- Prepare the access-control policy rules.
- Confirm the subnet and public IP configuration.
- Decide the rule effect scope.

---

## Inputs

### Edge switch configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_switches"></a> [switches](#input\_switches) | `list(object)` | yes | – | Edge firewall switch list. |

#### Switch object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `switch_enable` | `number` | yes | – | Switch status: `0` = off, `1` = on. |
| `switch_mode` | `number` | yes | – | Working mode: `0` = bypass, `1` = serial. |
| `switch_public_addr` | `string` | yes | – | Public IP address. |
| `switch_subnet_id` | `string` | no | – | Subnet ID (required when `switch_mode` = `1` and `switch_enable` = `1`, to create a private connection). |

### Inbound policy configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_inbound_policies"></a> [inbound\_policies](#input\_inbound\_policies) | `list(object)` | no | `[]` | Inbound access-control policy list. |

#### Inbound policy object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `port` | `string` | yes | – | Port: `-1/-1` = all ports, `80` = port 80. |
| `protocol` | `string` | yes | – | Protocol. For inbound rules, optional: TCP, UDP, ICMP, ANY, HTTP, HTTPS, HTTP/HTTPS, SMTP, SMTPS, SMTP/SMTPS, FTP, DNS. |
| `rule_action` | `string` | yes | – | Action: `accept` (allow), `drop` (deny), `log` (record). |
| `source_content` | `string` | yes | – | Source address, e.g. `net:IP/CIDR(192.168.0.2)`. |
| `source_type` | `string` | yes | – | Source type: for inbound rules, `net`, `location`, `vendor`, `template`. |
| `target_content` | `string` | yes | – | Target address, e.g. `net:IP/CIDR(192.168.0.2)` or `domain:*.qq.com`. |
| `target_type` | `string` | yes | – | Target type: for inbound rules, `net`, `instance`, `tag`, `template`, `group`. |
| `enable` | `string` | no | `true` | Rule status: `true` = enabled, `false` = disabled. |
| `scope` | `string` | no | `ALL` | Effect scope: `ALL` = global; a region code = region scope; an instance ID = instance scope. |
| `description` | `string` | no | `""` | Rule description. |
| `param_template_id` | `string` | no | – | Parameter template ID. |

### Outbound policy configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_outbound_policies"></a> [outbound\_policies](#input\_outbound\_policies) | `list(object)` | no | `[]` | Outbound access-control policy list. |

#### Outbound policy object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `port` | `string` | yes | – | Port: `-1/-1` = all ports, `80` = port 80. |
| `protocol` | `string` | yes | – | Protocol. For outbound rules, optional: TCP, UDP, ANY. |
| `rule_action` | `string` | yes | – | Action: `accept` (allow), `drop` (deny), `log` (record). |
| `source_content` | `string` | yes | – | Source address, e.g. `net:IP/CIDR(192.168.0.2)`. |
| `source_type` | `string` | yes | – | Source type: for outbound rules, `net`, `instance`, `tag`, `template`, `group`. |
| `target_content` | `string` | yes | – | Target address, e.g. `net:IP/CIDR(192.168.0.2)` or `domain:*.qq.com`. |
| `target_type` | `string` | yes | – | Target type: for outbound rules, `net`, `location`, `vendor`, `template`. |
| `enable` | `string` | no | `true` | Rule status: `true` = enabled, `false` = disabled. |
| `scope` | `string` | no | `ALL` | Effect scope: `ALL` = global; a region code = region scope; an instance ID = instance scope. |
| `description` | `string` | no | `""` | Rule description. |
| `param_template_id` | `string` | no | – | Parameter template ID. |

> **Note on domain targets**: To match a domain (e.g. `*.tencent.com`), set `target_content` to `domain:*.tencent.com` while keeping `target_type` as `net`. The `domain` value is not a `target_type` value — domain rules are expressed via the `domain:` prefix in `target_content`.

## Outputs

This component exposes no outputs.

---

## Configuration Examples

### `terraform.tfvars`

```hcl
# Edge firewall switch configuration
switches = [
  {
    switch_enable      = 1  # on
    switch_mode        = 1  # serial mode
    switch_public_addr = "203.0.113.10"
    switch_subnet_id   = "subnet-abcdef123456"
  },
  {
    switch_enable      = 1  # on
    switch_mode        = 0  # bypass mode
    switch_public_addr = "203.0.113.11"
  }
]

# Inbound policy configuration
inbound_policies = [
  {
    port           = "80"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:192.168.1.100"
    target_type    = "net"
    enable         = "true"
    scope          = "ALL"
    description    = "Allow public access to web service"
  },
  {
    port           = "22"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.0.0.0/8"
    source_type    = "net"
    target_content = "net:192.168.1.0/24"
    target_type    = "net"
    enable         = "true"
    scope          = "ap-beijing"
    description    = "Allow internal SSH access"
  }
]

# Outbound policy configuration
outbound_policies = [
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:192.168.1.0/24"
    source_type    = "net"
    target_content = "domain:*.tencent.com"
    target_type    = "net"
    enable         = "true"
    scope          = "ALL"
    description    = "Allow access to Tencent Cloud services"
  },
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "drop"
    source_content = "net:192.168.2.0/24"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    enable         = "true"
    scope          = "cfwnat-123456"
    description    = "Block outbound traffic from a specific subnet"
  }
]
```

### Production environment

```hcl
# Production edge firewall configuration
switches = [
  {
    switch_enable      = 1
    switch_mode        = 1  # serial mode for core business
    switch_public_addr = "203.0.113.100"
    switch_subnet_id   = "subnet-prod-core"
  },
  {
    switch_enable      = 1
    switch_mode        = 0  # bypass mode for test environment
    switch_public_addr = "203.0.113.101"
  }
]

# Production inbound policies
inbound_policies = [
  # Web service access
  {
    port           = "80,443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:10.10.1.0/24"
    target_type    = "net"
    description    = "Public web access"
  },
  # Management access
  {
    port           = "22"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.0.0.0/8"
    source_type    = "net"
    target_content = "net:10.10.0.0/16"
    target_type    = "net"
    description    = "Internal management access"
  }
]

# Production outbound policies
outbound_policies = [
  # Allow access to cloud services
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.10.0.0/16"
    source_type    = "net"
    target_content = "domain:*.tencentcloudapi.com"
    target_type    = "net"
    description    = "Access Tencent Cloud API"
  },
  # Block dangerous outbound
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "drop"
    source_content = "net:10.10.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    description    = "Deny all outbound by default"
  }
]
```

### Minimal configuration

```hcl
# Minimal edge firewall configuration
switches = [
  {
    switch_enable      = 1
    switch_mode        = 0  # bypass mode
    switch_public_addr = "203.0.113.50"
  }
]

# Basic inbound policy
inbound_policies = [
  {
    port           = "80,443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:192.168.1.100"
    target_type    = "net"
  }
]

# Basic outbound policy
outbound_policies = [
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "accept"
    source_content = "net:192.168.1.0/24"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
  }
]
```

---

## Usage Examples

### Example 1: Enterprise web service protection

```hcl
# Web service edge protection
switches = [
  {
    switch_enable      = 1
    switch_mode        = 1  # serial mode for deep inspection
    switch_public_addr = "203.0.113.80"
    switch_subnet_id   = "subnet-web-tier"
  }
]

inbound_policies = [
  # HTTP/HTTPS access
  {
    port           = "80,443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:10.20.1.0/24"
    target_type    = "net"
    description    = "Public web access"
  },
  # Block common attack ports
  {
    port           = "22,23,135,139,445"
    protocol       = "TCP"
    rule_action    = "drop"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:10.20.0.0/16"
    target_type    = "net"
    description    = "Block external access to management ports"
  }
]

outbound_policies = [
  # Allow required outbound
  {
    port           = "53"
    protocol       = "UDP"
    rule_action    = "accept"
    source_content = "net:10.20.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    description    = "DNS resolution"
  },
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.20.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    description    = "HTTPS outbound"
  }
]
```

### Example 2: Multi-region distributed protection

```hcl
# Multi-region edge protection
switches = [
  # Beijing region
  {
    switch_enable      = 1
    switch_mode        = 1
    switch_public_addr = "203.0.113.100"
    switch_subnet_id   = "subnet-bj-core"
  },
  # Shanghai region
  {
    switch_enable      = 1
    switch_mode        = 1
    switch_public_addr = "203.0.113.101"
    switch_subnet_id   = "subnet-sh-core"
  },
  # Guangzhou region
  {
    switch_enable      = 1
    switch_mode        = 0  # bypass mode for monitoring
    switch_public_addr = "203.0.113.102"
  }
]

# Unified inbound policy
inbound_policies = [
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:10.0.0.0/8"
    target_type    = "net"
    scope          = "ALL"
    description    = "Global HTTPS access"
  }
]

# Region-specific outbound policies
outbound_policies = [
  # Beijing region outbound policy
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "accept"
    source_content = "net:10.1.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    scope          = "ap-beijing"
    description    = "Beijing full outbound"
  },
  # Shanghai region outbound policy
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.2.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    scope          = "ap-shanghai"
    description    = "Shanghai HTTPS outbound"
  }
]
```

### Example 3: Zero-trust network access

```hcl
# Zero-trust edge protection
switches = [
  {
    switch_enable      = 1
    switch_mode        = 1  # serial mode
    switch_public_addr = "203.0.113.200"
    switch_subnet_id   = "subnet-zero-trust"
  }
]

inbound_policies = [
  # Allow only a specific IP range
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "accept"
    source_content = "net:192.168.100.0/24"
    source_type    = "net"
    target_content = "net:10.100.0.0/16"
    target_type    = "net"
    description    = "Trusted network access"
  },
  # Deny all inbound by default
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "drop"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:10.100.0.0/16"
    target_type    = "net"
    description    = "Deny all inbound by default"
  }
]

outbound_policies = [
  # Allow only specific services
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.100.0.0/16"
    source_type    = "net"
    target_content = "domain:*.microsoft.com"
    target_type    = "net"
    description    = "Access Microsoft services"
  },
  # Deny all outbound by default
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "drop"
    source_content = "net:10.100.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    description    = "Deny all outbound by default"
  }
]
```

---

## Configuration Notes

### Working mode

#### Bypass mode (switch_mode = 0)
- **Characteristic**: traffic is forwarded directly without passing through the firewall.
- **Advantage**: zero latency, no impact on network performance.
- **Use case**: monitoring mode, logging, test environments.
- **Limitation**: cannot block attacks in real time.

#### Serial mode (switch_mode = 1)
- **Characteristic**: traffic must pass through firewall inspection.
- **Advantage**: real-time protection, can block attacks.
- **Use case**: production environments, high-security requirements.
- **Requirement**: requires a subnet to create a private connection.
- **Impact**: may add network latency.

### Policy configuration guide

#### Port
- **All ports**: `-1/-1`
- **Single port**: `80`, `443`, `22`
- **Port range**: `1000-2000`
- **Multiple ports**: `80,443,8080`

#### Protocol
- **Inbound protocols**: TCP, UDP, ICMP, ANY, HTTP, HTTPS, HTTP/HTTPS, SMTP, SMTPS, SMTP/SMTPS, FTP, DNS.
- **Outbound protocols**: TCP, UDP, ANY.

#### Action
- **accept**: allow traffic.
- **drop**: silently discard traffic.
- **log**: record traffic without blocking.

#### Address type
- **net**: IP/CIDR format.
- **instance**: CVM instance.
- **tag**: resource tag.
- **template**: parameter template.
- **group**: security group.
- **location**: geographic region.
- **vendor**: cloud service provider.
- **domain**: domain rule (expressed via the `domain:` prefix in `target_content`).

#### Effect scope
- **Global (ALL)**: effective for all instances.
- **Region-level**: effective for a specific region (e.g. `ap-beijing`).
- **Instance-level**: effective for a specific instance (e.g. `cfwnat-xxx`).

### Best practices

1. **Least privilege**: only open necessary ports and protocols.
2. **Default deny**: configure a default-deny rule and explicitly allow necessary traffic.
3. **Layered defense**: combine network ACLs, security groups, and CFW.
4. **Log monitoring**: enable logging and audit policies regularly.
5. **Test & verify**: test policies thoroughly before production.
6. **Version control**: manage policy versions with Terraform.
7. **Periodic review**: review and optimize policy rules regularly.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Mode selection**
   - Serial mode requires a subnet ID.
   - Bypass mode suits monitoring; serial mode suits protection.
   - Serial mode is recommended for production.

2. **Network planning**
   - Confirm the public IP is configured correctly.
   - Check the subnet route-table configuration.
   - Verify network connectivity.

3. **Policy configuration**
   - Avoid overly permissive policies.
   - Minimize openings per business needs.
   - Test policies to avoid service interruption.

4. **Dependencies**
   - Policy configuration depends on asset synchronization.
   - Ensure the CFW instance is created.
   - Check network resource permissions.

5. **Performance impact**
   - Serial mode may add latency.
   - Complex policies may affect performance.
   - Monitor firewall performance metrics.

6. **Compliance**
   - Ensure configuration meets security standards.
   - Retain sufficient audit logs.
   - Follow industry compliance requirements.

7. **Change management**
   - Test thoroughly before production changes.
   - Define a rollback plan.
   - Record change-operation logs.

8. **Monitoring & alerting**
   - Configure firewall monitoring alerts.
   - Monitor policy hit counts.
   - Set up abnormal-traffic alerts.

9. **Backup & recovery**
   - Back up firewall configuration regularly.
   - Test the configuration recovery procedure.
   - Keep historical configuration versions.

10. **Technical support**
    - Contact Tencent Cloud support when issues occur.
    - Provide detailed error information.
    - Prepare the network topology diagram and related configuration.

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
- Verify network resource permissions.

#### Error 2: Network configuration error

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Network configuration error
```

**Cause**: Subnet or public IP misconfiguration.
**Solution**:
- Check whether the public IP is correct.
- Verify the subnet ID exists.
- Check network connectivity.

#### Error 3: Policy configuration error

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy configuration error
```

**Cause**: Wrong policy parameter format or value.
**Solution**:
- Check the policy object format.
- Confirm parameter values meet requirements.
- Validate protocol and port formats.

#### Error 4: Resource not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Resource not found
```

**Cause**: The referenced resource does not exist.
**Solution**:
- Check whether the subnet / public IP exists.
- Confirm the CFW instance is created.
- Verify region configuration.

#### Error 5: Mode conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Mode conflict
```

**Cause**: Working mode configuration conflict.
**Solution**:
- Check the `switch_mode` value (0 or 1).
- Confirm a subnet is specified for serial mode.
- Verify configuration consistency.

#### Error 6: Asset not synchronized

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Asset not synchronized
```

**Cause**: Asset information is not synchronized to the firewall.
**Solution**:
- Wait for asset synchronization to complete.
- Check the `sync_asset` resource status.
- Verify network resource permissions.

#### Error 7: Quota exceeded

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Quota exceeded
```

**Cause**: The resource quota limit has been exceeded.
**Solution**:
- Check current resource usage.
- Request a quota increase.
- Optimize the policy configuration.

## License

See [LICENSE](../../../../LICENSE) for full details.