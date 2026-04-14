# 腾讯云DMZ网络架构模块

## 模块概述

本模块用于在腾讯云中构建完整的DMZ（Demilitarized Zone，隔离区）网络架构，实现内外网隔离的安全网络环境，主要功能包括：

- **入站VPC创建** - 创建用于接收外部流量的入站VPC
- **出站VPC创建** - 创建用于内部业务访问的出站VPC
- **NAT网关配置** - 为出站VPC提供网络地址转换服务
- **CCN云联网关联** - 将VPC关联到云联网实现网络互通
- **子网管理** - 支持多可用区子网配置
- **安全隔离** - 实现内外网流量的安全隔离和管控

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
| `QcloudVPCFullAccess` | VPC管理全权限 |
| `QcloudCCNFullAccess` | CCN管理全权限 |
| `QcloudNATGatewayFullAccess` | NAT网关管理全权限 |
| `QcloudTagFullAccess` | 标签管理全权限 |

### 其他要求

- 需要规划好VPC的CIDR地址段
- 需要了解CCN实例的ID或名称
- 需要规划好子网划分策略
- 需要确定NAT网关的带宽需求
- 需要规划好网络流量走向

---

## 变量说明

### VPC通用配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpc_region` | `string` | 是 | - | VPC所在区域 |
| `vpc_default_subnet_name` | `string` | 否 | `default_subnet` | 默认子网名称 |
| `vpc_availability_zones` | `list(string)` | 否 | `[]` | 可用区列表 |
| `vpc_common_tags` | `map(string)` | 否 | `{}` | 通用资源标签 |

### 入站VPC配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpc_inbound_name` | `string` | 否 | `my-vpc` | 入站VPC名称 |
| `vpc_inbound_cidr` | `string` | 否 | `172.16.0.0/16` | 入站VPC CIDR |
| `vpc_inbound_is_multicast` | `bool` | 否 | `true` | 是否支持组播 |
| `vpc_inbound_tags` | `map(string)` | 否 | `{}` | 入站VPC标签 |
| `vpc_inbound_subnet_cidrs` | `list(object)` | 是 | - | 入站子网配置 |
| `vpc_inbound_subnet_tags` | `map(string)` | 否 | `{}` | 入站子网标签 |

### 出站VPC配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpc_outbound_name` | `string` | 否 | `my-vpc` | 出站VPC名称 |
| `vpc_outbound_cidr` | `string` | 否 | `172.16.0.0/16` | 出站VPC CIDR |
| `vpc_outbound_is_multicast` | `bool` | 否 | `true` | 是否支持组播 |
| `vpc_outbound_tags` | `map(string)` | 否 | `{}` | 出站VPC标签 |
| `vpc_outbound_subnet_cidrs` | `list(object)` | 是 | - | 出站子网配置 |
| `vpc_outbound_subnet_tags` | `map(string)` | 否 | `{}` | 出站子网标签 |

### NAT网关配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `nat_gateway_name` | `string` | 否 | `""` | NAT网关名称 |
| `nat_eips` | `list(string)` | 否 | `[]` | NAT网关EIP列表 |
| `nat_public_ips` | `list(string)` | 否 | `[]` | NAT网关公网IP列表 |
| `nat_internet_max_bandwidth_out` | `number` | 否 | `100` | 最大出带宽（Mbps） |
| `nat_product_version` | `number` | 否 | `1` | NAT网关版本（1:传统, 2:标准） |
| `nat_enable_flow_monitor` | `bool` | 否 | `false` | 是否启用流量监控 |
| `nat_tags` | `map(string)` | 否 | `{}` | NAT网关标签 |

### CCN关联配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `ccn_id` | `string` | 否 | `null` | CCN实例ID |
| `ccn_name` | `string` | 否 | `null` | CCN实例名称 |
| `attachment_description` | `string` | 否 | `""` | 关联描述 |
| `ccn_uin` | `string` | 否 | `null` | CCN所属账号UIN |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# VPC通用配置
vpc_region          = "ap-beijing"
vpc_default_subnet_name = "dmz-subnet"
vpc_availability_zones = ["ap-beijing-3", "ap-beijing-4"]
vpc_common_tags = {
  Environment = "production"
  NetworkType = "dmz"
  ManagedBy   = "terraform"
}

# 入站VPC配置
vpc_inbound_name         = "dmz-inbound-vpc"
vpc_inbound_cidr         = "10.0.0.0/16"
vpc_inbound_is_multicast = true
vpc_inbound_tags = {
  VPCType = "inbound"
  Purpose = "external-access"
}

# 入站子网配置
vpc_inbound_subnet_cidrs = [
  {
    subnet_name         = "inbound-subnet-1"
    subnet_cidr         = "10.0.1.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-3"
  },
  {
    subnet_name         = "inbound-subnet-2"
    subnet_cidr         = "10.0.2.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-4"
  }
]

vpc_inbound_subnet_tags = {
  SubnetType = "inbound"
}

# 出站VPC配置
vpc_outbound_name         = "dmz-outbound-vpc"
vpc_outbound_cidr         = "10.1.0.0/16"
vpc_outbound_is_multicast = true
vpc_outbound_tags = {
  VPCType = "outbound"
  Purpose = "internal-services"
}

# 出站子网配置
vpc_outbound_subnet_cidrs = [
  {
    subnet_name         = "outbound-subnet-1"
    subnet_cidr         = "10.1.1.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-3"
  },
  {
    subnet_name         = "outbound-subnet-2"
    subnet_cidr         = "10.1.2.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-4"
  }
]

vpc_outbound_subnet_tags = {
  SubnetType = "outbound"
}

# NAT网关配置
nat_gateway_name           = "dmz-nat-gateway"
nat_eips                   = ["eip-xxxxxx", "eip-yyyyyy"]
nat_internet_max_bandwidth_out = 500
nat_product_version        = 2
nat_enable_flow_monitor    = true
nat_tags = {
  GatewayType = "nat"
  Bandwidth   = "500Mbps"
}

# CCN关联配置
ccn_id                 = "ccn-abcdef"
attachment_description = "DMZ网络关联到生产环境CCN"
```

### 简单配置示例

```hcl
# 基础DMZ配置
vpc_region = "ap-shanghai"

# 入站VPC
vpc_inbound_name = "dmz-inbound"
vpc_inbound_cidr = "10.10.0.0/16"
vpc_inbound_subnet_cidrs = [
  {
    subnet_name = "inbound-subnet"
    subnet_cidr = "10.10.1.0/24"
  }
]

# 出站VPC
vpc_outbound_name = "dmz-outbound"
vpc_outbound_cidr = "10.11.0.0/16"
vpc_outbound_subnet_cidrs = [
  {
    subnet_name = "outbound-subnet"
    subnet_cidr = "10.11.1.0/24"
  }
]

# NAT网关
nat_gateway_name = "dmz-nat"
nat_internet_max_bandwidth_out = 200

# CCN关联
ccn_id = "ccn-123456"
```

### 多可用区高可用配置示例

```hcl
# 多可用区DMZ配置
vpc_region = "ap-guangzhou"
vpc_availability_zones = ["ap-guangzhou-3", "ap-guangzhou-4", "ap-guangzhou-6"]

# 入站VPC多子网
vpc_inbound_name = "ha-dmz-inbound"
vpc_inbound_cidr = "10.20.0.0/16"
vpc_inbound_subnet_cidrs = [
  {
    subnet_name       = "inbound-zone3"
    subnet_cidr       = "10.20.1.0/24"
    availability_zone = "ap-guangzhou-3"
  },
  {
    subnet_name       = "inbound-zone4"
    subnet_cidr       = "10.20.2.0/24"
    availability_zone = "ap-guangzhou-4"
  },
  {
    subnet_name       = "inbound-zone6"
    subnet_cidr       = "10.20.3.0/24"
    availability_zone = "ap-guangzhou-6"
  }
]

# 出站VPC多子网
vpc_outbound_name = "ha-dmz-outbound"
vpc_outbound_cidr = "10.21.0.0/16"
vpc_outbound_subnet_cidrs = [
  {
    subnet_name       = "outbound-zone3"
    subnet_cidr       = "10.21.1.0/24"
    availability_zone = "ap-guangzhou-3"
  },
  {
    subnet_name       = "outbound-zone4"
    subnet_cidr       = "10.21.2.0/24"
    availability_zone = "ap-guangzhou-4"
  }
]

# 高可用NAT网关
nat_gateway_name = "ha-dmz-nat"
nat_eips = ["eip-ha1", "eip-ha2", "eip-ha3"]
nat_internet_max_bandwidth_out = 1000
nat_product_version = 2
nat_enable_flow_monitor = true

# CCN关联
ccn_id = "ccn-ha-infra"
attachment_description = "高可用DMZ网络关联"

# 标签配置
vpc_common_tags = {
  Environment    = "production"
  HighAvailability = "enabled"
  MultiAZ        = "true"
}
```

---

## 使用示例

### 示例一：生产环境DMZ架构

```hcl
# 生产环境DMZ网络架构
vpc_region = "ap-beijing"
vpc_availability_zones = ["ap-beijing-3", "ap-beijing-4"]

# 入站VPC - 外部访问区域
vpc_inbound_name = "prod-dmz-inbound"
vpc_inbound_cidr = "10.100.0.0/16"
vpc_inbound_subnet_cidrs = [
  {
    subnet_name       = "prod-inbound-web"
    subnet_cidr       = "10.100.1.0/24"
    availability_zone = "ap-beijing-3"
  },
  {
    subnet_name       = "prod-inbound-api"
    subnet_cidr       = "10.100.2.0/24"
    availability_zone = "ap-beijing-4"
  }
]

# 出站VPC - 内部服务区域
vpc_outbound_name = "prod-dmz-outbound"
vpc_outbound_cidr = "10.101.0.0/16"
vpc_outbound_subnet_cidrs = [
  {
    subnet_name       = "prod-outbound-app"
    subnet_cidr       = "10.101.1.0/24"
    availability_zone = "ap-beijing-3"
  },
  {
    subnet_name       = "prod-outbound-db"
    subnet_cidr       = "10.101.2.0/24"
    availability_zone = "ap-beijing-4"
  }
]

# NAT网关配置
nat_gateway_name = "prod-dmz-nat"
nat_eips = ["eip-prod-1", "eip-prod-2"]
nat_internet_max_bandwidth_out = 1000
nat_product_version = 2
nat_enable_flow_monitor = true

# CCN关联
ccn_id = "ccn-prod-main"
attachment_description = "生产环境DMZ网络关联"

# 生产环境标签
vpc_common_tags = {
  Environment = "production"
  NetworkType = "dmz"
  SLA         = "99.95%"
  CostCenter  = "infrastructure"
}

vpc_inbound_tags = {
  SecurityZone = "external"
  AccessLevel  = "public"
}

vpc_outbound_tags = {
  SecurityZone = "internal"
  AccessLevel  = "private"
}
```

### 示例二：开发测试环境DMZ

```hcl
# 开发测试环境DMZ
vpc_region = "ap-shanghai"

# 入站VPC
vpc_inbound_name = "dev-dmz-inbound"
vpc_inbound_cidr = "10.200.0.0/16"
vpc_inbound_subnet_cidrs = [
  {
    subnet_name = "dev-inbound"
    subnet_cidr = "10.200.1.0/24"
  }
]

# 出站VPC
vpc_outbound_name = "dev-dmz-outbound"
vpc_outbound_cidr = "10.201.0.0/16"
vpc_outbound_subnet_cidrs = [
  {
    subnet_name = "dev-outbound"
    subnet_cidr = "10.201.1.0/24"
  }
]

# NAT网关
nat_gateway_name = "dev-dmz-nat"
nat_internet_max_bandwidth_out = 100

# CCN关联
ccn_id = "ccn-dev"

# 开发环境标签
vpc_common_tags = {
  Environment = "development"
  Purpose     = "testing"
  CostCenter  = "rd"
}
```

### 示例三：金融级安全DMZ

```hcl
# 金融级安全DMZ架构
vpc_region = "ap-singapore"
vpc_availability_zones = ["ap-singapore-1", "ap-singapore-2"]

# 入站VPC - 严格安全控制
vpc_inbound_name = "finance-dmz-inbound"
vpc_inbound_cidr = "10.50.0.0/16"
vpc_inbound_subnet_cidrs = [
  {
    subnet_name       = "finance-inbound-web"
    subnet_cidr       = "10.50.1.0/24"
    availability_zone = "ap-singapore-1"
  },
  {
    subnet_name       = "finance-inbound-api"
    subnet_cidr       = "10.50.2.0/24"
    availability_zone = "ap-singapore-2"
  }
]

# 出站VPC - 内部核心服务
vpc_outbound_name = "finance-dmz-outbound"
vpc_outbound_cidr = "10.51.0.0/16"
vpc_outbound_subnet_cidrs = [
  {
    subnet_name       = "finance-outbound-app"
    subnet_cidr       = "10.51.1.0/24"
    availability_zone = "ap-singapore-1"
  },
  {
    subnet_name       = "finance-outbound-db"
    subnet_cidr       = "10.51.2.0/24"
    availability_zone = "ap-singapore-2"
  }
]

# 高安全NAT网关
nat_gateway_name = "finance-dmz-nat"
nat_eips = ["eip-finance-1", "eip-finance-2"]
nat_internet_max_bandwidth_out = 500
nat_product_version = 2
nat_enable_flow_monitor = true

# CCN关联
ccn_id = "ccn-finance"
attachment_description = "金融级DMZ网络关联"

# 金融级安全标签
vpc_common_tags = {
  Environment    = "production"
  Industry       = "finance"
  SecurityLevel  = "high"
  Compliance     = "pci-dss"
}

vpc_inbound_tags = {
  SecurityZone = "dmz"
  AccessType   = "restricted"
}

vpc_outbound_tags = {
  SecurityZone = "internal"
  AccessType   = "controlled"
}
```

---

## 配置说明

### DMZ网络架构说明

| 组件 | 说明 | 安全级别 |
|------|------|----------|
| **入站VPC** | 接收外部流量，部署Web服务器、API网关等 | 中等安全 |
| **出站VPC** | 内部业务服务，部署应用服务器、数据库等 | 高安全 |
| **NAT网关** | 提供出站网络地址转换 | 网络边界 |
| **CCN关联** | 实现VPC间网络互通 | 内部网络 |

### 子网配置对象说明

子网配置对象包含以下字段：
```hcl
{
  subnet_name         = "subnet-name"        # 子网名称（最多60字符）
  subnet_cidr         = "10.0.1.0/24"        # 子网CIDR
  subnet_is_multicast = true                 # 是否支持组播（可选，默认true）
  availability_zone   = "ap-beijing-3"       # 可用区（可选）
}
```

### NAT网关版本说明

| 版本 | 说明 | 适用场景 |
|------|------|----------|
| **版本1** | 传统NAT网关 | 基础网络地址转换 |
| **版本2** | 标准NAT网关 | 高性能、高可用场景 |

### 输出说明

模块输出三个关键ID：
```hcl
inbound_vpc_id   = "vpc-xxxxxx"    # 入站VPC ID
outbound_vpc_id  = "vpc-yyyyyy"    # 出站VPC ID
nat_gateway_id   = "nat-zzzzzz"    # NAT网关ID
```

### 依赖关系

模块内部依赖关系：
1. 先创建入站VPC和出站VPC
2. 然后创建NAT网关（依赖出站VPC）
3. 最后进行CCN关联（依赖两个VPC）

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **网络规划**
   - 确保入站VPC和出站VPC的CIDR不重叠
   - 合理规划子网大小，预留扩展空间
   - 考虑多可用区部署提高可用性

2. **安全策略**
   - 入站VPC应配置严格的安全组规则
   - 出站VPC应限制外部访问
   - 使用网络ACL进行流量控制

3. **NAT网关配置**
   - 根据业务需求选择合适的带宽
   - 考虑使用标准NAT网关（版本2）获得更好性能
   - 启用流量监控以便故障排查

4. **CCN关联**
   - 确保CCN实例存在且状态正常
   - 了解CCN的路由策略和带宽限制
   - 考虑跨账号关联时的权限配置

5. **成本优化**
   - 合理选择NAT网关带宽避免资源浪费
   - 使用标签进行成本分摊和监控
   - 考虑预付费模式降低成本

6. **监控告警**
   - 配置NAT网关流量监控
   - 设置VPC网络流量告警
   - 监控CCN带宽使用情况

7. **备份恢复**
   - 定期备份网络配置
   - 制定网络故障恢复预案
   - 测试网络切换流程

8. **合规要求**
   - 确保网络架构符合安全合规要求
   - 记录网络变更操作
   - 定期进行安全审计

---

## 故障排除

### 常见错误及解决方案

#### 错误一：VPC CIDR冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=VPC CIDR conflict
```

**原因**：VPC CIDR地址段冲突或重叠
**解决方案**：
- 检查入站VPC和出站VPC的CIDR是否重叠
- 确保CIDR在VPC区域内唯一
- 使用不同的私有地址段

#### 错误二：子网CIDR超出VPC范围

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Subnet CIDR out of VPC range
```

**原因**：子网CIDR不在VPC CIDR范围内
**解决方案**：
- 确保子网CIDR是VPC CIDR的子集
- 检查子网掩码设置是否正确
- 重新规划子网划分

#### 错误三：NAT网关创建失败

```
Error: [TencentCloudSDKError] Code=NatGatewayError
Message=NAT gateway creation failed
```

**原因**：NAT网关创建失败
**解决方案**：
- 检查VPC ID是否正确
- 验证EIP是否可用
- 确认带宽设置是否合理

#### 错误四：CCN关联失败

```
Error: [TencentCloudSDKError] Code=CcnAttachmentError
Message=CCN attachment failed
```

**原因**：CCN关联操作失败
**解决方案**：
- 确认CCN实例存在且状态正常
- 检查CCN区域匹配性
- 验证关联权限

#### 错误五：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少必要权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含VPC、CCN、NAT网关管理权限
- 验证跨账号操作的权限配置

#### 错误六：资源配额限制

```
Error: [TencentCloudSDKError] Code=QuotaExceeded
Message=Resource quota exceeded
```

**原因**：达到资源配额限制
**解决方案**：
- 检查VPC、子网、NAT网关的配额限制
- 申请提高配额或删除无用资源
- 合理规划资源使用