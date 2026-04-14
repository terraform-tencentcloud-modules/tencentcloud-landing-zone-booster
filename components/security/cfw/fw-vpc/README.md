# 腾讯云云防火墙（CFW）VPC防火墙模块

## 模块概述

本模块用于在腾讯云中配置和管理云防火墙（Cloud Firewall，CFW）的VPC防火墙功能，主要提供以下核心能力：

- **VPC防火墙实例管理** - 创建和管理VPC防火墙实例组
- **网络模式支持** - 支持私有网络模式和云联网模式
- **交换机模式** - 支持单点互通、多点通信、自定义路由三种交换机模式
- **多地域部署** - 支持跨地域防火墙实例部署
- **策略控制** - 定义和管理VPC间访问控制策略
- **自动网络规划** - 自动或手动配置防火墙网络段
- **云联网集成** - 支持云联网环境下的防火墙部署

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
| `QcloudCFWFullAccess` | 云防火墙全权限 |
| `QcloudVPCFullAccess` | VPC网络权限 |
| `QcloudCCNFullAccess` | 云联网权限（云联网模式） |

### 其他要求

- 需要规划VPC防火墙的工作模式（私有网络/云联网）
- 需要确定交换机模式（单点/多点/自定义路由）
- 需要准备VPC ID列表
- 需要规划防火墙实例的地域部署
- 需要准备访问控制策略规则
- 云联网模式需要准备CCN ID

---

## 变量说明

### 必需配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `name` | `string` | 是 | - | VPC防火墙（组）名称 |
| `mode` | `number` | 是 | - | 工作模式：0-私有网络模式，1-云联网模式 |
| `switch_mode` | `number` | 是 | - | 交换机模式：1-单点互通，2-多点通信，4-自定义路由 |
| `fw_instances` | `list(object)` | 是 | - | 防火墙实例列表 |

### 可选配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `fw_cidr` | `string` | 否 | `auto` | 防火墙网络段：auto-自动选择，或用户指定CIDR |
| `ccn_id` | `string` | 否 | `null` | 云联网ID（云联网模式） |
| `vpc_fw_group_id` | `string` | 否 | `null` | 防火墙实例组ID |
| `vpc_fw_policies` | `list(object)` | 否 | `[]` | VPC防火墙策略列表 |

### 详细变量说明

#### 防火墙实例对象字段
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `name` | `string` | 是 | - | 防火墙实例名称 |
| `fw_deploy` | `list(object)` | 是 | - | 防火墙部署配置 |
| `vpc_ids` | `set(string)` | 否 | - | VPC ID集合 |

#### 防火墙部署对象字段
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `deploy_region` | `string` | 是 | - | 部署地域 |
| `width` | `number` | 是 | - | 带宽规格（Mbps） |
| `zone_set` | `set(string)` | 是 | - | 可用区集合 |
| `cross_a_zone` | `number` | 否 | - | 跨可用区部署：0-不启用，1-启用 |

#### 策略对象字段
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `description` | `string` | 是 | - | 策略描述 |
| `source_type` | `string` | 是 | - | 源类型：net, template |
| `source_content` | `string` | 是 | - | 源内容 |
| `dest_type` | `string` | 是 | - | 目标类型：net, template, domain |
| `dest_content` | `string` | 是 | - | 目标内容 |
| `protocol` | `string` | 是 | - | 协议：TCP, UDP, ICMP, ANY, HTTP, HTTPS等 |
| `port` | `string` | 是 | - | 端口 |
| `rule_action` | `string` | 是 | - | 动作：accept-允许，drop-拒绝，log-记录 |
| `enable` | `string` | 否 | `true` | 启用状态：true-启用，false-禁用 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 基本配置
name        = "prod-vpc-fw"
mode        = 0  # 私有网络模式
switch_mode = 1  # 单点互通
fw_cidr     = "auto"  # 自动选择网络段

# 防火墙实例配置
fw_instances = [
  {
    name = "vpc-fw-instance-1"
    fw_deploy = [
      {
        deploy_region = "ap-beijing"
        width         = 1000  # 1Gbps
        zone_set      = ["ap-beijing-1", "ap-beijing-2"]
        cross_a_zone  = 0  # 不启用跨可用区
      }
    ]
    vpc_ids = ["vpc-123456", "vpc-789012"]
  }
]

# VPC防火墙策略
vpc_fw_policies = [
  {
    description    = "允许VPC间HTTP访问"
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
    description    = "禁止VPC间数据库访问"
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

### 云联网模式配置示例

```hcl
# 云联网模式配置
name        = "ccn-vpc-fw"
mode        = 1  # 云联网模式
switch_mode = 2  # 多点通信
fw_cidr     = "10.10.10.0/24"  # 手动指定网络段
ccn_id      = "ccn-abcdef"  # 云联网ID

# 多地域防火墙实例
fw_instances = [
  {
    name = "ccn-fw-beijing"
    fw_deploy = [
      {
        deploy_region = "ap-beijing"
        width         = 2000  # 2Gbps
        zone_set      = ["ap-beijing-1", "ap-beijing-2"]
        cross_a_zone  = 1  # 启用跨可用区
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
        cross_a_zone  = 1  # 启用跨可用区
      }
    ]
  }
]

# 云联网策略配置
vpc_fw_policies = [
  {
    description    = "允许云联网内HTTPS访问"
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

### 自定义路由模式配置示例

```hcl
# 自定义路由模式
name        = "custom-route-fw"
mode        = 0  # 私有网络模式
switch_mode = 4  # 自定义路由
fw_cidr     = "auto"

# 防火墙实例配置
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

# 精细化策略配置
vpc_fw_policies = [
  {
    description    = "Web层到应用层访问"
    source_type    = "net"
    source_content = "vpc:10.1.0.0/16"
    dest_type      = "net"
    dest_content   = "vpc:10.2.0.0/16"
    protocol       = "TCP"
    port           = "8080"
    rule_action    = "accept"
  },
  {
    description    = "应用层到数据库访问"
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

## 使用示例

### 示例一：企业多VPC互通

```hcl
# 企业多VPC环境
name        = "enterprise-vpc-fw"
mode        = 0
switch_mode = 2  # 多点通信
fw_cidr     = "auto"

# 多VPC防火墙实例
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

# 企业级策略
vpc_fw_policies = [
  # 生产环境访问控制
  {
    description    = "生产环境严格隔离"
    source_type    = "net"
    source_content = "vpc:10.10.0.0/16"
    dest_type      = "net"
    dest_content   = "vpc:10.20.0.0/16"
    protocol       = "ANY"
    port           = "-1/-1"
    rule_action    = "drop"
  },
  # 开发测试环境互通
  {
    description    = "开发测试环境互通"
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

### 示例二：云联网多地域部署

```hcl
# 云联网多地域部署
name        = "multi-region-ccn-fw"
mode        = 1
switch_mode = 1  # 单点互通
fw_cidr     = "10.20.30.0/24"
ccn_id      = "ccn-global"

# 多地域防火墙部署
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

# 全局策略配置
vpc_fw_policies = [
  {
    description    = "全局HTTPS访问"
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

## 配置说明

### 工作模式说明

#### 私有网络模式（Mode 0）
- **特点**：在私有网络内部部署防火墙
- **优势**：VPC内部流量精细控制
- **适用**：单一VPC或多VPC互通场景
- **网络拓扑**：VPC内部流量 → VPC防火墙 → 目标VPC

#### 云联网模式（Mode 1）
- **特点**：在云联网环境中部署防火墙
- **优势**：跨地域、跨账号流量控制
- **适用**：多云联网环境，跨地域访问控制
- **要求**：需要配置云联网ID
- **网络拓扑**：云联网流量 → VPC防火墙 → 目标网络

### 交换机模式说明

#### 单点互通（Switch Mode 1）
- **特点**：所有流量通过单一防火墙实例
- **优势**：配置简单，管理方便
- **适用**：中小规模环境
- **限制**：单点故障风险

#### 多点通信（Switch Mode 2）
- **特点**：流量通过多个防火墙实例负载均衡
- **优势**：高可用性，性能更好
- **适用**：大规模环境，高可用要求
- **部署**：多实例部署

#### 自定义路由（Switch Mode 4）
- **特点**：根据路由策略选择防火墙路径
- **优势**：灵活的路由控制
- **适用**：复杂网络拓扑
- **要求**：需要配置路由策略

### 网络段配置

- **自动选择（auto）**：系统自动分配防火墙网络段
- **手动指定**：用户自定义CIDR块（如：10.10.10.0/24）
- **注意事项**：确保网络段不与现有VPC冲突

### 策略配置指南

#### 协议支持
- **基础协议**：TCP, UDP, ICMP, ANY
- **应用协议**：HTTP, HTTPS, SMTP, FTP, DNS等
- **协议组合**：HTTP/HTTPS, SMTP/SMTPS

#### 地址类型
- **网络地址（net）**：IP/CIDR格式，vpc:10.0.0.0/8
- **模板（template）**：参数模板
- **域名（domain）**：域名规则（仅目标类型）

#### 动作类型
- **允许（accept）**：允许流量通过
- **拒绝（drop）**：静默丢弃流量
- **记录（log）**：记录流量但不阻止

### 最佳实践

1. **模式选择**：根据网络架构选择合适模式
2. **高可用设计**：多可用区、多地域部署
3. **带宽规划**：按业务流量峰值规划
4. **策略最小化**：按需配置最小必要权限
5. **网络隔离**：合理规划VPC和网络段
6. **监控告警**：配置流量监控和异常检测
7. **定期审计**：定期审查策略和访问日志

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **模式兼容性**
   - 私有网络模式需要VPC ID列表
   - 云联网模式需要CCN ID
   - 模式选择后不能修改

2. **网络配置错误**
   - 确认VPC ID是否正确
   - 验证CCN ID配置
   - 检查网络段是否冲突

3. **交换机模式**
   - 单点模式有单点故障风险
   - 多点模式需要多实例部署
   - 自定义模式需要路由配置

4. **防火墙实例**
   - 确保地域部署符合业务需求
   - 按业务需求选择合适带宽
   - 考虑跨可用区高可用

5. **策略配置**
   - 避免过于宽松的策略
   - 按业务需求最小化开放
   - 测试策略避免业务中断

6. **依赖关系**
   - 策略配置依赖防火墙实例创建
   - 确保网络资源权限充足
   - 检查依赖资源状态

7. **性能影响**
   - 复杂策略可能影响性能
   - 监控防火墙性能指标
   - 按需调整带宽规格

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足
```
Error: [TencentCloudSDKError] Code=PermissionDenied
Message=Insufficient permissions
```

**原因**：当前账号权限不足
**解决方案**：
- 检查CFW、VPC、CCN相关权限
- 申请必要权限
- 验证资源操作权限

#### 错误二：网络配置错误
```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Network configuration error
```

**原因**：VPC、CCN或网络段配置错误
**解决方案**：
- 检查VPC ID是否正确
- 验证CCN ID配置
- 检查网络段是否冲突

#### 错误三：模式配置错误
```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Mode configuration error
```

**原因**：工作模式或交换机模式参数错误
**解决方案**：
- 检查mode值（0或1）
- 检查switch_mode值（1,2,4）
- 确认模式对应的参数已配置

#### 错误四：资源不存在
```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Resource not found
```

**原因**：引用的资源不存在
**解决方案**：
- 检查VPC、CCN是否存在
- 确认地域配置正确
- 验证资源ID格式

#### 错误五：策略配置错误
```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy configuration error
```

**原因**：策略参数格式或值错误
**解决方案**：
- 检查策略对象格式
- 确认参数值符合要求
- 验证协议和地址类型