# 腾讯云CCN-VPN网关管理模块

## 模块概述

本模块用于在腾讯云中创建VPN网关并将其关联到CCN（Cloud Connect Network，云联网），实现VPN与云联网的混合网络互联，主要功能包括：

- **VPN网关创建** - 创建IPSEC、SSL、CCN等类型的VPN网关
- **客户网关管理** - 配置对端客户网关信息
- **VPN连接建立** - 建立VPN隧道连接
- **安全策略配置** - 支持IKE和IPSec安全协议配置
- **BGP路由支持** - 支持BGP动态路由协议
- **健康检查** - 支持VPN隧道健康检查
- **CCN关联** - 将VPN网关关联到云联网
- **路由表关联** - 支持CCN路由表与VPN网关的关联配置

---

## 前置要求

### 环境要求

| 工具 | 最低版本 | 说明 |
|------|----------|------|
| Terraform | `>= 1.3.0` | 基础设施即代码工具 |
| tencentcloud provider | `>= 1.81.0` | 腾讯云 Terraform Provider |

### 权限要求

执行本模块需要具备以下腾讯云权限：

| 权限名称 | 说明 |
|----------|------|
| `QcloudVPNXFullAccess` | VPN网关管理全权限 |
| `QcloudCCNFullAccess` | CCN管理全权限 |
| `QcloudTagFullAccess` | 标签管理全权限 |
| `QcloudVPCFullAccess` | VPC管理全权限 |

### 其他要求

- 需要规划好VPN网关的带宽和类型
- 需要了解对端客户网关的公网IP地址
- 需要配置预共享密钥（Pre-shared Key）
- 需要了解CCN实例的ID和区域
- 需要规划好安全策略和路由策略

---

## 变量说明

### VPN网关配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `name` | `string` | 是 | - | VPN网关名称（1-60字符） |
| `bandwidth` | `number` | 否 | `200` | 带宽（Mbps）：5,10,20,50,100,200,500,1000 |
| `zone` | `string` | 否 | - | VPN网关可用区 |
| `type` | `string` | 否 | `IPSEC` | 网关类型：IPSEC, SSL, CCN, SSL_CCN |
| `charge_type` | `string` | 否 | `POSTPAID_BY_HOUR` | 计费类型：PREPAID, POSTPAID_BY_HOUR |
| `prepaid_period` | `number` | 否 | `null` | 预付费周期（月） |
| `prepaid_renew_flag` | `string` | 否 | `null` | 续费标志 |
| `max_connection` | `number` | 否 | `null` | SSL VPN最大连接数 |
| `bgp_asn` | `number` | 否 | `null` | BGP ASN（1-4294967295） |
| `tags` | `map(string)` | 否 | `{}` | VPN网关标签 |

### 客户网关配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `customer_gateway_name` | `string` | 是 | - | 客户网关名称（1-60字符） |
| `customer_gateway_public_ip_address` | `string` | 是 | - | 客户网关公网IP |
| `customer_gateway_bgp_asn` | `number` | 否 | `null` | 客户网关BGP ASN |
| `customer_gateway_tags` | `map(string)` | 否 | `{}` | 客户网关标签 |

### VPN连接配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpn_connection_name` | `string` | 是 | - | VPN连接名称（1-60字符） |
| `vpn_connection_customer_gateway_id` | `string` | 是 | `""` | 客户网关ID |
| `vpn_connection_pre_share_key` | `string` | 是 | `""` | 预共享密钥 |
| `vpn_connection_route_type` | `string` | 否 | `null` | 路由类型：STATIC, StaticRoute, Policy, Bgp |
| `vpn_connection_negotiation_type` | `string` | 否 | `null` | 协商类型：active, passive, flowTrigger |

### IKE配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpn_connection_ike_proto_encry_algorithm` | `string` | 否 | `3DES-CBC` | 加密算法 |
| `vpn_connection_ike_proto_authen_algorithm` | `string` | 否 | `MD5` | 认证算法 |
| `vpn_connection_ike_local_identity` | `string` | 否 | `ADDRESS` | 本地身份：ADDRESS, FQDN |
| `vpn_connection_ike_exchange_mode` | `string` | 否 | `MAIN` | 交换模式：AGGRESSIVE, MAIN |
| `vpn_connection_ike_remote_identity` | `string` | 否 | `ADDRESS` | 远程身份：ADDRESS, FQDN |
| `vpn_connection_ike_dh_group_name` | `string` | 否 | `GROUP1` | DH组名 |
| `vpn_connection_ike_sa_lifetime_seconds` | `number` | 否 | `86400` | SA生命周期（秒） |

### IPSec配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpn_connection_ipsec_encrypt_algorithm` | `string` | 否 | `3DES-CBC` | 加密算法 |
| `vpn_connection_ipsec_integrity_algorithm` | `string` | 否 | `MD5` | 完整性算法 |
| `vpn_connection_ipsec_sa_lifetime_seconds` | `number` | 否 | `3600` | SA生命周期（秒） |
| `vpn_connection_ipsec_pfs_dh_group` | `string` | 否 | `NULL` | PFS DH组 |
| `vpn_connection_ipsec_sa_lifetime_traffic` | `number` | 否 | `1843200` | SA生命周期（KB） |

### 健康检查配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpn_connection_enable_health_check` | `bool` | 否 | `false` | 是否启用健康检查 |
| `vpn_connection_health_check_local_ip` | `string` | 否 | `null` | 本地健康检查IP |
| `vpn_connection_health_check_remote_ip` | `string` | 否 | `null` | 远程健康检查IP |

### CCN关联配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `attached_ccn_id` | `string` | 是 | - | 关联的CCN ID |
| `attached_ccn_region` | `string` | 是 | - | CCN所在区域 |
| `attached_ccn_description` | `string` | 否 | `null` | 关联描述 |

### 路由表关联配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `route_table_id` | `string` | 否 | `null` | CCN路由表ID |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# VPN网关基础配置
name        = "production-vpn-gateway"
bandwidth   = 200
zone        = "ap-beijing-3"
type        = "IPSEC"
charge_type = "POSTPAID_BY_HOUR"

# BGP配置
bgp_asn = 65001

# 客户网关配置
customer_gateway_name              = "on-premise-gateway"
customer_gateway_public_ip_address = "203.0.113.10"
customer_gateway_bgp_asn           = 65002

# VPN连接配置
vpn_connection_name               = "prod-vpn-connection"
vpn_connection_pre_share_key      = "MySecurePreShareKey123"
vpn_connection_route_type         = "Bgp"
vpn_connection_negotiation_type   = "active"

# IKE配置
vpn_connection_ike_proto_encry_algorithm  = "AES-CBC-256"
vpn_connection_ike_proto_authen_algorithm = "SHA-256"
vpn_connection_ike_dh_group_name          = "GROUP14"
vpn_connection_ike_sa_lifetime_seconds    = 28800

# IPSec配置
vpn_connection_ipsec_encrypt_algorithm   = "AES-CBC-256"
vpn_connection_ipsec_integrity_algorithm = "SHA-256"
vpn_connection_ipsec_sa_lifetime_seconds = 7200
vpn_connection_ipsec_pfs_dh_group        = "DH-GROUP14"

# 健康检查配置
vpn_connection_enable_health_check    = true
vpn_connection_health_check_local_ip  = "10.0.1.10"
vpn_connection_health_check_remote_ip = "192.168.1.10"

# CCN关联配置
attached_ccn_id          = "ccn-abcdef"
attached_ccn_region      = "ap-beijing"
attached_ccn_description = "生产环境VPN网关关联到CCN"

# 路由表关联
route_table_id = "ccn-rtb-xxxxxx"

# 标签配置
tags = {
  Environment = "production"
  NetworkType = "hybrid"
  ManagedBy   = "terraform"
}

customer_gateway_tags = {
  Location    = "datacenter"
  Owner       = "network-team"
}

vpn_connection_tags = {
  ConnectionType = "site-to-site"
  SLA            = "99.9%"
}
```

### 简单配置示例

```hcl
# 基础VPN网关配置
name        = "basic-vpn-gateway"
bandwidth   = 50
zone        = "ap-shanghai-2"
type        = "IPSEC"

# 客户网关配置
customer_gateway_name              = "office-gateway"
customer_gateway_public_ip_address = "198.51.100.20"

# VPN连接配置
vpn_connection_name          = "basic-vpn-connection"
vpn_connection_pre_share_key = "BasicPreShareKey456"

# CCN关联配置
attached_ccn_id     = "ccn-123456"
attached_ccn_region = "ap-shanghai"
```

### SSL VPN配置示例

```hcl
# SSL VPN网关配置
name           = "ssl-vpn-gateway"
bandwidth      = 100
type           = "SSL"
max_connection = 20

# 客户网关配置
customer_gateway_name              = "remote-access-gateway"
customer_gateway_public_ip_address = "203.0.113.30"

# VPN连接配置
vpn_connection_name          = "ssl-vpn-connection"
vpn_connection_pre_share_key = "SSLPreShareKey789"

# CCN关联配置
attached_ccn_id     = "ccn-789012"
attached_ccn_region = "ap-guangzhou"

# 安全组策略
vpn_connection_security_group_policy = [
  {
    local_cidr_block  = "10.0.0.0/16"
    remote_cidr_block = ["192.168.0.0/24", "192.168.1.0/24"]
  }
]
```

---

## 使用示例

### 示例一：生产环境IPSEC VPN网关

```hcl
# 生产环境VPN网关配置
name        = "prod-ipsec-vpn"
bandwidth   = 500
zone        = "ap-beijing-3"
type        = "IPSEC"
charge_type = "PREPAID"
prepaid_period = 12

# BGP配置
bgp_asn = 65010

# 客户网关配置
customer_gateway_name              = "prod-datacenter-gw"
customer_gateway_public_ip_address = "203.0.113.100"
customer_gateway_bgp_asn           = 65020

# VPN连接配置
vpn_connection_name               = "prod-ipsec-tunnel"
vpn_connection_pre_share_key      = "ProdSecureKey2024"
vpn_connection_route_type         = "Bgp"
vpn_connection_negotiation_type   = "active"

# 高级IKE配置
vpn_connection_ike_proto_encry_algorithm  = "AES-CBC-256"
vpn_connection_ike_proto_authen_algorithm = "SHA-256"
vpn_connection_ike_dh_group_name          = "GROUP14"
vpn_connection_ike_sa_lifetime_seconds    = 28800

# 高级IPSec配置
vpn_connection_ipsec_encrypt_algorithm   = "AES-CBC-256"
vpn_connection_ipsec_integrity_algorithm = "SHA-256"
vpn_connection_ipsec_sa_lifetime_seconds = 7200
vpn_connection_ipsec_pfs_dh_group        = "DH-GROUP14"

# 健康检查配置
vpn_connection_enable_health_check    = true
vpn_connection_health_check_local_ip  = "10.100.1.1"
vpn_connection_health_check_remote_ip = "192.168.100.1"

# CCN关联配置
attached_ccn_id          = "ccn-prod-main"
attached_ccn_region      = "ap-beijing"
attached_ccn_description = "生产环境IPSEC VPN网关关联"

# 路由表关联
route_table_id = "ccn-rtb-prod"

# 安全组策略
vpn_connection_security_group_policy = [
  {
    local_cidr_block  = "10.100.0.0/16"
    remote_cidr_block = ["192.168.100.0/24", "192.168.101.0/24"]
  }
]

# 标签配置
tags = {
  Environment = "production"
  VPNType     = "ipsec"
  Bandwidth   = "500Mbps"
  SLA         = "99.95%"
}
```

### 示例二：开发环境基础VPN网关

```hcl
# 开发环境VPN网关配置
name        = "dev-vpn-gateway"
bandwidth   = 50
zone        = "ap-shanghai-2"
type        = "IPSEC"

# 客户网关配置
customer_gateway_name              = "dev-office-gw"
customer_gateway_public_ip_address = "198.51.100.50"

# VPN连接配置
vpn_connection_name          = "dev-vpn-connection"
vpn_connection_pre_share_key = "DevPreShareKey123"

# CCN关联配置
attached_ccn_id     = "ccn-dev"
attached_ccn_region = "ap-shanghai"

# 开发环境标签
tags = {
  Environment = "development"
  Purpose     = "testing"
  CostCenter  = "rd"
}
```

### 示例三：高可用SSL VPN网关

```hcl
# 高可用SSL VPN网关配置
name           = "ha-ssl-vpn"
bandwidth      = 200
type           = "SSL_CCN"
max_connection = 50
charge_type    = "PREPAID"
prepaid_period = 24

# 客户网关配置
customer_gateway_name              = "ha-remote-access"
customer_gateway_public_ip_address = "203.0.113.200"

# VPN连接配置
vpn_connection_name          = "ha-ssl-connection"
vpn_connection_pre_share_key = "HASSLKeySecure"

# CCN关联配置
attached_ccn_id          = "ccn-ha-infra"
attached_ccn_region      = "ap-guangzhou"
attached_ccn_description = "高可用SSL VPN网关关联"

# 路由表关联
route_table_id = "ccn-rtb-ha"

# 高级配置
vpn_connection_health_check_config = {
  probe_interval  = 30
  probe_threshold = 3
  probe_timeout   = 10
  probe_type      = "ICMP"
}

# 高可用标签
tags = {
  Environment    = "production"
  VPNType        = "ssl-ccn"
  HighAvailability = "enabled"
  MaxConnections = "50"
}
```

---

## 配置说明

### VPN网关类型说明

| 网关类型 | 说明 | 适用场景 |
|----------|------|----------|
| **IPSEC** | IPSEC VPN网关 | 站点到站点VPN连接 |
| **SSL** | SSL VPN网关 | 远程访问VPN连接 |
| **CCN** | CCN VPN网关 | 云联网VPN连接 |
| **SSL_CCN** | SSL CCN VPN网关 | 远程访问+云联网 |

### 安全算法说明

#### IKE加密算法
- `3DES-CBC`, `AES-CBC-128`, `AES-CBC-192`, `AES-CBC-256`
- `DES-CBC`, `SM4`, `AES128GCM128`, `AES192GCM128`, `AES256GCM128`

#### IKE认证算法
- `MD5`, `SHA`, `SHA-256`

#### IPSec加密算法
- `3DES-CBC`, `AES-CBC-128`, `AES-CBC-192`, `AES-CBC-256`
- `DES-CBC`, `SM4`, `NULL`, `AES128GCM128`, `AES192GCM128`, `AES256GCM128`

### 输出说明

模块输出三个关键ID：
```hcl
vpn_gateway_id     = "vpngw-xxxxxx"
customer_gateway_id = "cgw-xxxxxx"
vpn_connection_id   = "vpnx-xxxxxx"
```

### 依赖关系

模块内部依赖关系：
1. 先创建VPN网关和客户网关
2. 然后建立VPN连接
3. 最后进行CCN关联和路由表关联

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **权限配置**
   - 确保执行账号具有VPN网关和CCN管理权限
   - 需要`QcloudVPNXFullAccess`和`QcloudCCNFullAccess`权限

2. **预共享密钥安全**
   - 预共享密钥是VPN连接的关键安全参数
   - 建议使用强密码（字母、数字、特殊字符组合）
   - 定期更换预共享密钥

3. **带宽选择**
   - 根据业务需求选择合适的带宽
   - 预付费模式下不支持带宽降级
   - 合理规划带宽避免资源浪费

4. **BGP配置**
   - BGP ASN范围：1-4294967295
   - 避免使用保留ASN：139341, 45090, 58835
   - 确保两端BGP配置一致

5. **安全策略**
   - 建议使用强加密算法（如AES-256）
   - 使用安全的认证算法（如SHA-256）
   - 合理设置SA生命周期

6. **健康检查配置**
   - 健康检查IP地址需要在两端网络可达
   - 合理设置检查间隔和超时时间
   - 监控健康检查状态

7. **CCN关联**
   - 确保CCN实例存在且状态正常
   - 确认CCN区域与VPN网关区域匹配
   - 了解网络路由策略

8. **路由表关联**
   - 路由表ID可选配置
   - 确保路由表存在且可用
   - 了解路由策略影响

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少VPN网关或CCN管理权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含`QcloudVPNXFullAccess`和`QcloudCCNFullAccess`权限

#### 错误二：预共享密钥错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid pre-shared key
```

**原因**：预共享密钥格式错误或不符合要求
**解决方案**：
- 检查预共享密钥长度和字符类型
- 确保两端使用相同的预共享密钥
- 使用强密码策略

#### 错误三：带宽不支持

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Unsupported bandwidth
```

**原因**：带宽值不在支持范围内
**解决方案**：
- 带宽值必须是：5,10,20,50,100,200,500,1000
- 预付费模式下不能降级带宽
- 选择合适的带宽值

#### 错误四：BGP ASN冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=BGP ASN conflict
```

**原因**：BGP ASN配置冲突或使用保留ASN
**解决方案**：
- 避免使用保留ASN：139341, 45090, 58835
- 确保ASN在有效范围内（1-4294967295）
- 检查ASN是否已被使用

#### 错误五：VPN连接建立失败

```
Error: [TencentCloudSDKError] Code=VpnConnectionError
Message=VPN connection establishment failed
```

**原因**：VPN隧道建立失败
**解决方案**：
- 检查对端网关可达性
- 验证预共享密钥一致性
- 检查安全策略配置
- 确认网络ACL和防火墙规则

#### 错误六：CCN关联失败

```
Error: [TencentCloudSDKError] Code=CcnAttachmentError
Message=CCN attachment failed
```

**原因**：CCN关联操作失败
**解决方案**：
- 确认CCN实例存在且状态正常
- 检查CCN区域匹配性
- 验证关联权限