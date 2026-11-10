# Tencent Cloud Cloud Firewall (CFW) NAT Firewall Component

Terraform component under `components/security/cfw/fw-nat` for configuring and managing the NAT Firewall capability of Tencent Cloud Cloud Firewall (CFW) — as part of the `security` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component configures and manages the Cloud Firewall (CFW) NAT firewall feature, providing NAT instance management, working-mode support, bandwidth configuration, multi-AZ deployment, switch management, and policy control.

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
| `QcloudNATGatewayFullAccess` | Access to NAT Gateway |

### Prerequisites

- Decide the working mode (access mode / new mode).
- Prepare the NAT gateways (access mode) or EIPs + VPCs (new mode).
- Plan the bandwidth spec per business peak traffic.
- Plan the availability-zone set for multi-AZ deployment.
- Prepare the access-control policy rules.

---

## Inputs

### Required configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_mode"></a> [mode](#input\_mode) | `number` | yes | – | Working mode: `1` = access mode; `0` = new mode. (Must be `0` or `1`.) |
| <a name="input_name"></a> [name](#input\_name) | `string` | yes | – | Firewall instance name. |
| <a name="input_width"></a> [width](#input\_width) | `number` | yes | – | Bandwidth (Mbps). |
| <a name="input_zone_set"></a> [zone\_set](#input\_zone\_set) | `set(string)` | yes | – | Availability-zone set. |
| <a name="input_switches"></a> [switches](#input\_switches) | `list(object)` | yes | – | NAT firewall switch list. |

#### Switch object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `enable` | `number` | yes | – | Switch status: `0` = off, `1` = on. |
| `subnet_id` | `string` | yes | – | Subnet ID. |

### Optional configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_cross_a_zone"></a> [cross\_a\_zone](#input\_cross\_a\_zone) | `number` | no | `0` | Off-site disaster recovery: `1` = enable; `0` = disable. (Must be `0` or `1`.) |
| <a name="input_nat_gw_list"></a> [nat\_gw\_list](#input\_nat\_gw\_list) | `set(string)` | no | `[]` | List of NAT gateways connected in access mode. At least one of `nat_gw_list` and `new_mode_items` must be supplied. |
| <a name="input_new_mode_items"></a> [new\_mode\_items](#input\_new\_mode\_items) | `list(object)` | no | `[]` | New-mode parameters. At least one of `new_mode_items` and `nat_gw_list` must be supplied. |
| <a name="input_inbound_policies"></a> [inbound\_policies](#input\_inbound\_policies) | `list(object)` | no | `[]` | Inbound access-control policy list. |
| <a name="input_outbound_policies"></a> [outbound\_policies](#input\_outbound\_policies) | `list(object)` | no | `[]` | Outbound access-control policy list. |

#### `new_mode_items` object

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `eips` | `set(string)` | yes | – | Set of EIPs used in new mode. |
| `vpc_list` | `set(string)` | yes | – | Set of VPCs used in new mode. |

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

| Name | Description |
|------|-------------|
| <a name="output_nat_instance_id"></a> [nat\_instance\_id](#output\_nat\_instance\_id) | ID of the resource. |

---

## Configuration Examples

### Basic configuration (access mode)

```hcl
mode        = 1  # access mode
name        = "prod-nat-fw"
width       = 1000
zone_set    = ["ap-beijing-1", "ap-beijing-2"]

nat_gw_list = ["nat-123456"]

switches = [
  {
    enable    = 1
    subnet_id = "subnet-web"
  }
]

inbound_policies = [
  {
    port           = "80,443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:10.20.1.0/24"
    target_type    = "net"
  }
]
```

### New mode configuration

```hcl
mode        = 0  # new mode
name        = "new-mode-fw"
width       = 2000
zone_set    = ["ap-guangzhou-1"]

new_mode_items = [
  {
    eips     = ["eip-123456"]
    vpc_list = ["vpc-abcdef"]
  }
]
```

---

## Usage Examples

### Enterprise multi-NAT-gateway access

```hcl
mode        = 1
name        = "enterprise-nat-fw"
width       = 2000
zone_set    = ["ap-beijing-1", "ap-beijing-2"]

nat_gw_list = ["nat-gw-1", "nat-gw-2"]

switches = [
  {
    enable    = 1
    subnet_id = "subnet-web"
  },
  {
    enable    = 1
    subnet_id = "subnet-app"
  }
]
```

### Off-site disaster recovery deployment

```hcl
mode        = 1
name        = "dr-nat-fw"
width       = 3000
zone_set    = ["ap-beijing-1", "ap-shanghai-1"]
cross_a_zone = 1  # enable off-site disaster recovery

nat_gw_list = ["nat-bj-1", "nat-sh-1"]
```

---

## Configuration Notes

### Working mode
- **Access mode (mode = 1)**: deployed based on existing NAT gateways.
- **New mode (mode = 0)**: deployed directly using EIPs.

### Disaster recovery
- **Local high availability**: multi-AZ deployment within a single region.
- **Off-site disaster recovery**: cross-region DR deployment (`cross_a_zone = 1`).

### Policy configuration
- **Port**: `-1/-1` (all ports), `80` (port 80).
- **Protocol**: For inbound rules — TCP, UDP, ICMP, ANY, HTTP, HTTPS, etc.; for outbound rules — TCP, UDP, ANY.
- **Action**: `accept` (allow), `drop` (deny), `log` (record).
- **Address type**: `net`, `instance`, `tag`, `template`, `group`, etc.

---

## Important Notes

1. **Mode selection**: access mode requires existing NAT gateways; new mode requires EIPs.
2. **Bandwidth planning**: choose a bandwidth spec per business peak traffic.
3. **Network planning**: confirm VPC, subnet, and NAT gateway configuration.
4. **Policy configuration**: follow the principle of least privilege.
5. **Disaster recovery**: off-site DR adds cross-region bandwidth cost.

---

## Troubleshooting

### Common errors
- **Insufficient permissions**: check CFW, VPC, and NAT Gateway permissions.
- **Network configuration error**: verify NAT gateway, VPC, and subnet configuration.
- **Resource not found**: confirm the referenced resource IDs are correct.
- **Bandwidth exceeded**: check the bandwidth quota and request an increase.
- **AZ unavailable**: choose another availability zone.

## License

See [LICENSE](../../../../LICENSE) for full details.