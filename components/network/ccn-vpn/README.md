# Tencent Cloud CCN-VPN Component

Terraform component under `components/network/ccn-vpn` for creating a VPN gateway in Tencent Cloud, configuring customer gateways and VPN connections, and attaching the VPN gateway to a CCN (Cloud Connect Network) instance, enabling hybrid (on-premises ↔ cloud) interconnection as part of the `network` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates a VPN gateway, customer gateway(s), VPN connection(s), and attaches the gateway to a CCN instance. Main features:

- **VPN gateway creation** – create `IPSEC`, `SSL`, `CCN`, or `SSL_CCN` VPN gateways.
- **Customer gateway management** – configure the remote (on-premises) customer gateway.
- **VPN connection** – establish IPsec tunnels with IKE/IPsec security specifications.
- **BGP routing** – dynamic routing via `bgp_asn` and per-connection `bgp_config`.
- **DPD / health check** – dead-peer-detection and intra-tunnel health checks.
- **SPD policy** – fine-grained `security_group_policy` controlling which VPC/IDC CIDRs can communicate.
- **CCN attachment** – attach the VPN gateway to a CCN instance.
- **Route table association** – associate the attachment with a specific CCN route table.

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
| `QcloudVPNXFullAccess` | Full access to VPN gateway management |
| `QcloudCCNFullAccess` | Full access to CCN management |
| `QcloudTagFullAccess` | Full access to Tag management |
| `QcloudVPCFullAccess` | Full access to VPC management |

### Prerequisites

- Plan the VPN gateway bandwidth and type.
- Obtain the remote customer gateway's public IP address.
- Prepare a pre-shared key for the VPN connection.
- Obtain the CCN instance ID and its region.
- Plan security policies (IKE/IPsec) and routing policies (static / BGP / SPD).

---

## Inputs

### VPN gateway

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_name"></a> [name](#input\_name) | `string` | yes | – | Name of the VPN gateway (1–60 characters). |
| <a name="input_bandwidth"></a> [bandwidth](#input\_bandwidth) | `number` | no | `5` | Max public-network egress bandwidth (Mbps). Valid: `5,10,20,50,100,200,500,1000`. Bandwidth downgrade is unsupported when `charge_type = PREPAID`. |
| <a name="input_zone"></a> [zone](#input\_zone) | `string` | no | `null` | Zone of the VPN gateway (ForceNew). |
| <a name="input_type"></a> [type](#input\_type) | `string` | no | `"IPSEC"` | Gateway type: `IPSEC`, `SSL`, `CCN`, `SSL_CCN`. |
| <a name="input_charge_type"></a> [charge\_type](#input\_charge\_type) | `string` | no | `"POSTPAID_BY_HOUR"` | Charge type: `PREPAID`, `POSTPAID_BY_HOUR`. |
| <a name="input_prepaid_period"></a> [prepaid\_period](#input\_prepaid\_period) | `number` | no | `1` | Prepaid period in months. Valid: `1,2,3,4,6,7,8,9,12,24,36`. Can only be changed on IPSEC gateways. |
| <a name="input_prepaid_renew_flag"></a> [prepaid\_renew\_flag](#input\_prepaid\_renew\_flag) | `string` | no | `"NOTIFY_AND_AUTO_RENEW"` | Renew flag: `NOTIFY_AND_AUTO_RENEW`, `NOTIFY_AND_MANUAL_RENEW`. |
| <a name="input_max_connection"></a> [max\_connection](#input\_max\_connection) | `number` | no | `5` | Max connected clients for SSL VPN gateway. Valid: `[5,10,20,50,100]`. Only for SSL gateways. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | no | `{}` | Tags for the VPN gateway. |
| <a name="input_bgp_asn"></a> [bgp\_asn](#input\_bgp\_asn) | `number` | no | `null` | BGP ASN (1–4294967295). Required when using BGP. |
| <a name="input_cdc_id"></a> [cdc\_id](#input\_cdc\_id) | `string` | no | `null` | CDC instance ID. |

### Customer gateways (map)

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_customer_gateways"></a> [customer\_gateways](#input\_customer\_gateways) | `map(object)` | no | `{}` | Customer gateway definitions, keyed by a logical name. |
| `↳ name` | `string` | yes | – | Customer gateway name (1–60 characters). |
| `↳ public_ip_address` | `string` | yes | – | Public IP of the customer gateway (ForceNew). |
| `↳ bgp_asn` | `number` | no | – | BGP ASN (1–4294967295). Avoid reserved ASN `139341`, `45090`, `58835`. |
| `↳ tags` | `map(string)` | no | – | Tags for the customer gateway. |

### VPN connections (map)

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_vpn_connections"></a> [vpn\_connections](#input\_vpn\_connections) | `map(object)` | no | `{}` | VPN connection definitions, keyed by a logical name. |
| `↳ name` | `string` | yes | – | Connection name (1–60 characters). |
| `↳ pre_share_key` | `string` | yes | – | Pre-shared key of the connection. |
| `↳ customer_gateway_name` | `string` | yes | – | Name of the customer gateway to bind (matches a key in `customer_gateways`). |
| `↳ route_type` | `string` | no | – | Route type (ForceNew): `STATIC`, `StaticRoute`, `Policy`, `Bgp`. |
| `↳ negotiation_type` | `string` | no | – | `active`, `passive`, `flowTrigger`. |
| `↳ dpd_enable` | `number` | no | – | DPD enable: `0` (disable) / `1` (enable). |
| `↳ dpd_action` | `string` | no | – | Action after DPD timeout: `clear`, `restart` (valid when `dpd_enable=1`). |
| `↳ dpd_timeout` | `number` | no | `30` | DPD timeout (30–60s, valid when `dpd_enable=1`). |
| **IKE** |
| `↳ ike_proto_encry_algorithm` | `string` | no | `"3DES-CBC"` | IKE encrypt: `3DES-CBC`, `AES-CBC-128/192/256`, `DES-CBC`, `SM4`, `AES128GCM128`, `AES192GCM128`, `AES256GCM128`. |
| `↳ ike_proto_authen_algorithm` | `string` | no | `"MD5"` | IKE auth: `MD5`, `SHA`, `SHA-256`. |
| `↳ ike_local_identity` | `string` | no | `"ADDRESS"` | `ADDRESS`, `FQDN`. |
| `↳ ike_exchange_mode` | `string` | no | `"MAIN"` | `AGGRESSIVE`, `MAIN`. |
| `↳ ike_local_address` | `string` | no | – | Local address (valid when `ike_local_identity=ADDRESS`), usually the VPN gateway public IP. |
| `↳ ike_remote_identity` | `string` | no | `"ADDRESS"` | `ADDRESS`, `FQDN`. |
| `↳ ike_remote_address` | `string` | no | – | Remote address (valid when `ike_remote_identity=ADDRESS`), usually the customer gateway public IP. |
| `↳ ike_dh_group_name` | `string` | no | `"GROUP1"` | `GROUP1`, `GROUP2`, `GROUP5`, `GROUP14`, `GROUP24`. |
| `↳ ike_sa_lifetime_seconds` | `number` | no | `86400` | IKE SA lifetime (60–604800s). |
| `↳ ike_local_fqdn_name` | `string` | no | – | Local FQDN name. |
| `↳ ike_remote_fqdn_name` | `string` | no | – | Remote FQDN name. |
| `↳ ike_version` | `string` | no | `"IKEV1"` | `IKEV1`, `IKEV2`. |
| **IPsec** |
| `↳ ipsec_encrypt_algorithm` | `string` | no | `"3DES-CBC"` | IPsec encrypt: `3DES-CBC`, `AES-CBC-128/192/256`, `DES-CBC`, `SM4`, `NULL`, `AES128GCM128`, `AES192GCM128`, `AES256GCM128`. |
| `↳ ipsec_integrity_algorithm` | `string` | no | `"MD5"` | IPsec integrity: `SHA1`, `MD5`, `SHA-256`. |
| `↳ ipsec_sa_lifetime_seconds` | `number` | no | `3600` | IPsec SA lifetime (180–604800s). |
| `↳ ipsec_pfs_dh_group` | `string` | no | `"NULL"` | PFS DH group: `DH-GROUP1`, `DH-GROUP2`, `DH-GROUP5`, `DH-GROUP14`, `DH-GROUP24`, `NULL`. |
| `↳ ipsec_sa_lifetime_traffic` | `number` | no | `1843200` | IPsec SA lifetime (KB, ≥ 2560). |
| **Health check / BGP / SPD** |
| `↳ enable_health_check` | `bool` | no | `false` | Whether intra-tunnel health checks are enabled. |
| `↳ health_check_local_ip` | `string` | no | – | Local health-check IP. |
| `↳ health_check_remote_ip` | `string` | no | – | Remote (peer) health-check IP. |
| `↳ health_check_config` | `object` | no | – | Health-check probe config: `probe_interval`, `probe_threshold`, `probe_timeout`, `probe_type`. |
| `↳ bgp_config` | `list(object)` | no | `[]` | BGP config: `local_bgp_ip`, `remote_bgp_ip`, `tunnel_cidr`. |
| `↳ security_group_policy` | `set(object)` | no | `[]` | SPD policy: `local_cidr_block` (VPC segment) → `remote_cidr_block` (set of IDC segments). |
| `↳ tags` | `map(string)` | no | `{}` | Tags for the connection. |

### CCN attachment

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ccn_uin"></a> [ccn\_uin](#input\_ccn\_uin) | `string` | no | `null` | UIN of the CCN owner. If not set, uses the current account's UIN. Used for cross-account CCN attachment. |
| <a name="input_attached_ccn_id"></a> [attached\_ccn\_id](#input\_attached\_ccn\_id) | `string` | yes | – | ID of the CCN instance to attach. |
| <a name="input_attached_ccn_region"></a> [attached\_ccn\_region](#input\_attached\_ccn\_region) | `string` | yes | – | Region of the CCN instance. |
| <a name="input_attached_ccn_description"></a> [attached\_ccn\_description](#input\_attached\_ccn\_description) | `string` | no | `null` | Description of the attachment. |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | `string` | no | `null` | ID of the CCN route table to associate. |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpn_gateway_id"></a> [vpn\_gateway\_id](#output\_vpn\_gateway\_id) | The ID of the VPN gateway. |
| <a name="output_vpn_gateway_public_ip"></a> [vpn\_gateway\_public\_ip](#output\_vpn\_gateway\_public\_ip) | The public IP address of the VPN gateway. |
| <a name="output_customer_gateway_id"></a> [customer\_gateway\_id](#output\_customer\_gateway\_id) | The map of customer gateway IDs (keyed by the logical name in `customer_gateways`). |
| <a name="output_vpn_connection_id"></a> [vpn\_connection\_id](#output\_vpn\_connection\_id) | The map of VPN connection IDs (keyed by the logical name in `vpn_connections`). |

---

## Configuration Examples

### `terraform.tfvars` – production IPSEC VPN with BGP and SPD

```hcl
# VPN gateway
name        = "production-vpn-gateway"
bandwidth   = 200
zone        = "ap-beijing-3"
type        = "IPSEC"
charge_type = "POSTPAID_BY_HOUR"
bgp_asn     = 65001

tags = {
  Environment = "production"
  NetworkType = "hybrid"
  ManagedBy   = "terraform"
}

# Customer gateways (map)
customer_gateways = {
  on_premise = {
    name              = "on-premise-gateway"
    public_ip_address = "203.0.113.10"
    bgp_asn           = 65002
    tags = {
      Location = "datacenter"
      Owner    = "network-team"
    }
  }
}

# VPN connections (map)
vpn_connections = {
  prod_tunnel = {
    name                  = "prod-vpn-connection"
    customer_gateway_name = "on-premise-gateway"
    pre_share_key         = "MySecurePreShareKey123"
    route_type            = "Bgp"
    negotiation_type      = "active"

    ike_proto_encry_algorithm  = "AES-CBC-256"
    ike_proto_authen_algorithm = "SHA-256"
    ike_dh_group_name          = "GROUP14"
    ike_sa_lifetime_seconds    = 28800

    ipsec_encrypt_algorithm   = "AES-CBC-256"
    ipsec_integrity_algorithm = "SHA-256"
    ipsec_sa_lifetime_seconds = 7200
    ipsec_pfs_dh_group        = "DH-GROUP14"

    enable_health_check    = true
    health_check_local_ip  = "10.0.1.10"
    health_check_remote_ip = "192.168.1.10"

    security_group_policy = [
      {
        local_cidr_block  = "10.0.0.0/16"
        remote_cidr_block = ["192.168.0.0/24", "192.168.1.0/24"]
      }
    ]

    tags = {
      ConnectionType = "site-to-site"
      SLA            = "99.9%"
    }
  }
}

# CCN attachment
attached_ccn_id          = "ccn-abcdef"
attached_ccn_region      = "ap-beijing"
attached_ccn_description = "Production VPN gateway attached to CCN"
route_table_id           = "ccn-rtb-xxxxxx"
```

### Simple configuration (static route, no BGP)

```hcl
name        = "basic-vpn-gateway"
bandwidth   = 50
zone        = "ap-shanghai-2"
type        = "IPSEC"

customer_gateways = {
  office = {
    name              = "office-gateway"
    public_ip_address = "198.51.100.20"
  }
}

vpn_connections = {
  basic = {
    name                  = "basic-vpn-connection"
    customer_gateway_name = "office-gateway"
    pre_share_key         = "BasicPreShareKey456"
  }
}

attached_ccn_id     = "ccn-123456"
attached_ccn_region = "ap-shanghai"
```

### SSL VPN gateway with health check config

```hcl
name           = "ssl-vpn-gateway"
bandwidth      = 100
type           = "SSL"
max_connection = 20

customer_gateways = {
  remote_access = {
    name              = "remote-access-gateway"
    public_ip_address = "203.0.113.30"
  }
}

vpn_connections = {
  ssl_conn = {
    name                  = "ssl-vpn-connection"
    customer_gateway_name = "remote-access-gateway"
    pre_share_key         = "SSLPreShareKey789"

    enable_health_check = true
    health_check_config = {
      probe_interval  = 30
      probe_threshold = 3
      probe_timeout   = 10
      probe_type      = "ICMP"
    }

    security_group_policy = [
      {
        local_cidr_block  = "10.0.0.0/16"
        remote_cidr_block = ["192.168.0.0/24", "192.168.1.0/24"]
      }
    ]
  }
}

attached_ccn_id     = "ccn-789012"
attached_ccn_region = "ap-guangzhou"
```

---

## Usage Examples

### Example 1: Production IPSEC VPN gateway (prepaid, BGP, SPD)

```hcl
name        = "prod-ipsec-vpn"
bandwidth   = 500
zone        = "ap-beijing-3"
type        = "IPSEC"
charge_type = "PREPAID"
prepaid_period = 12
bgp_asn     = 65010

customer_gateways = {
  dc = {
    name              = "prod-datacenter-gw"
    public_ip_address = "203.0.113.100"
    bgp_asn           = 65020
  }
}

vpn_connections = {
  tunnel = {
    name                  = "prod-ipsec-tunnel"
    customer_gateway_name = "prod-datacenter-gw"
    pre_share_key         = "ProdSecureKey2024"
    route_type            = "Bgp"
    negotiation_type      = "active"

    ike_proto_encry_algorithm  = "AES-CBC-256"
    ike_proto_authen_algorithm = "SHA-256"
    ike_dh_group_name          = "GROUP14"
    ike_sa_lifetime_seconds    = 28800

    ipsec_encrypt_algorithm   = "AES-CBC-256"
    ipsec_integrity_algorithm = "SHA-256"
    ipsec_sa_lifetime_seconds = 7200
    ipsec_pfs_dh_group        = "DH-GROUP14"

    enable_health_check    = true
    health_check_local_ip  = "10.100.1.1"
    health_check_remote_ip = "192.168.100.1"

    security_group_policy = [
      {
        local_cidr_block  = "10.100.0.0/16"
        remote_cidr_block = ["192.168.100.0/24", "192.168.101.0/24"]
      }
    ]
  }
}

attached_ccn_id          = "ccn-prod-main"
attached_ccn_region      = "ap-beijing"
attached_ccn_description = "Production IPSEC VPN gateway attachment"
route_table_id           = "ccn-rtb-prod"

tags = {
  Environment = "production"
  VPNType     = "ipsec"
  Bandwidth   = "500Mbps"
  SLA         = "99.95%"
}
```

### Example 2: Development basic VPN gateway

```hcl
name        = "dev-vpn-gateway"
bandwidth   = 50
zone        = "ap-shanghai-2"
type        = "IPSEC"

customer_gateways = {
  office = {
    name              = "dev-office-gw"
    public_ip_address = "198.51.100.50"
  }
}

vpn_connections = {
  dev = {
    name                  = "dev-vpn-connection"
    customer_gateway_name = "dev-office-gw"
    pre_share_key         = "DevPreShareKey123"
  }
}

attached_ccn_id     = "ccn-dev"
attached_ccn_region = "ap-shanghai"

tags = {
  Environment = "development"
  Purpose     = "testing"
  CostCenter  = "rd"
}
```

### Example 3: High-availability SSL_CCN VPN gateway

```hcl
name           = "ha-ssl-vpn"
bandwidth      = 200
type           = "SSL_CCN"
max_connection = 50
charge_type    = "PREPAID"
prepaid_period = 24

customer_gateways = {
  ha_remote = {
    name              = "ha-remote-access"
    public_ip_address = "203.0.113.200"
  }
}

vpn_connections = {
  ha_conn = {
    name                  = "ha-ssl-connection"
    customer_gateway_name = "ha-remote-access"
    pre_share_key         = "HASSLKeySecure"

    enable_health_check = true
    health_check_config = {
      probe_interval  = 30
      probe_threshold = 3
      probe_timeout   = 10
      probe_type      = "ICMP"
    }
  }
}

attached_ccn_id          = "ccn-ha-infra"
attached_ccn_region      = "ap-guangzhou"
attached_ccn_description = "High-availability SSL VPN gateway attachment"
route_table_id           = "ccn-rtb-ha"

tags = {
  Environment      = "production"
  VPNType          = "ssl-ccn"
  HighAvailability = "enabled"
  MaxConnections   = "50"
}
```

---

## Configuration Notes

### VPN gateway types

| Type | Description | Use case |
|------|-------------|----------|
| **IPSEC** | IPSEC VPN gateway | Site-to-site VPN (default). |
| **SSL** | SSL VPN gateway | Remote-access VPN. |
| **CCN** | CCN VPN gateway | CCN-bound VPN. |
| **SSL_CCN** | SSL + CCN VPN gateway | Remote access + CCN. |

### Security algorithms

#### IKE encrypt algorithms
`3DES-CBC`, `AES-CBC-128`, `AES-CBC-192`, `AES-CBC-256`, `DES-CBC`, `SM4`, `AES128GCM128`, `AES192GCM128`, `AES256GCM128`.

#### IKE auth algorithms
`MD5`, `SHA`, `SHA-256`.

#### IPsec encrypt algorithms
`3DES-CBC`, `AES-CBC-128`, `AES-CBC-192`, `AES-CBC-256`, `DES-CBC`, `SM4`, `NULL`, `AES128GCM128`, `AES192GCM128`, `AES256GCM128`.

#### IPsec integrity algorithms
`SHA1`, `MD5`, `SHA-256`.

### Internal dependency order

1. The VPN gateway and customer gateway(s) are created first.
2. Then the VPN connection(s) are established.
3. Finally the CCN attachment (and optional route table association) is applied.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Permissions**
   - The executing account needs VPN gateway and CCN management permissions (`QcloudVPNXFullAccess`, `QcloudCCNFullAccess`).

2. **Pre-shared key security**
   - The pre-shared key is a critical security parameter.
   - Use a strong key (mix of letters, numbers, special characters).
   - Rotate the key periodically; ensure both ends use the same value.

3. **Bandwidth selection**
   - Valid values: `5,10,20,50,100,200,500,1000`.
   - Bandwidth downgrade is unsupported in `PREPAID` mode.
   - Right-size bandwidth to avoid waste.

4. **BGP configuration**
   - BGP ASN range: 1–4294967295.
   - Avoid reserved ASN: `139341`, `45090`, `58835`.
   - Ensure both ends have consistent BGP configuration.

5. **Security policies**
   - Prefer strong encryption (e.g. `AES-256`) and authentication (e.g. `SHA-256`).
   - Tune SA lifetimes appropriately.

6. **Health check**
   - Health-check IPs must be reachable from both ends.
   - Configure probe interval / timeout appropriately and monitor status.

7. **CCN attachment**
   - Ensure the CCN instance exists and is in a normal state.
   - Confirm the CCN region matches the VPN gateway region.
   - For cross-account CCN, set `ccn_uin`.

8. **Route table association**
   - `route_table_id` is optional; ensure the route table exists and belongs to the target CCN.
   - Understand the routing-policy impact.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks VPN gateway or CCN management permissions.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check `QcloudVPNXFullAccess` and `QcloudCCNFullAccess` are included.

#### Error 2: Invalid pre-shared key

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid pre-shared key
```

**Cause**: The pre-shared key format is invalid.
**Solution**:
- Check the key length and allowed character types.
- Ensure both ends use the same pre-shared key.
- Use a strong password policy.

#### Error 3: Unsupported bandwidth

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Unsupported bandwidth
```

**Cause**: The bandwidth value is out of range.
**Solution**:
- Use one of: `5,10,20,50,100,200,500,1000`.
- Bandwidth cannot be downgraded in `PREPAID` mode.

#### Error 4: BGP ASN conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=BGP ASN conflict
```

**Cause**: BGP ASN conflict or reserved ASN used.
**Solution**:
- Avoid reserved ASN: `139341`, `45090`, `58835`.
- Ensure ASN is in range (1–4294967295).
- Check whether the ASN is already in use.

#### Error 5: VPN connection establishment failed

```
Error: [TencentCloudSDKError] Code=VpnConnectionError
Message=VPN connection establishment failed
```

**Cause**: The VPN tunnel failed to establish.
**Solution**:
- Check remote gateway reachability.
- Verify pre-shared key consistency.
- Check security-policy configuration.
- Confirm network ACL and firewall rules.

#### Error 6: CCN attachment failed

```
Error: [TencentCloudSDKError] Code=CcnAttachmentError
Message=CCN attachment failed
```

**Cause**: The CCN attachment operation failed.
**Solution**:
- Confirm the CCN instance exists and is in a normal state.
- Check region consistency.
- Verify attachment permissions (and `ccn_uin` for cross-account).

## License

See [LICENSE](../../../LICENSE) for full details.