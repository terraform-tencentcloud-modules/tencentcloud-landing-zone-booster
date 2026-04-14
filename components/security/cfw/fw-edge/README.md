# 腾讯云云防火墙（CFW）边缘防火墙模块

## 模块概述

本模块用于在腾讯云中配置和管理云防火墙（Cloud Firewall，CFW）的边缘防火墙功能，主要提供以下核心能力：

- **资产同步** - 自动同步云上资产信息到防火墙
- **边缘开关管理** - 配置和管理边缘防火墙开关状态
- **入站策略** - 定义和管理入站流量访问控制策略
- **出站策略** - 定义和管理出站流量访问控制策略
- **多模式支持** - 支持旁路和串行两种工作模式
- **细粒度控制** - 基于IP、端口、协议、地域等多维度访问控制

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
| `QcloudCFWReadOnlyAccess` | 云防火墙只读权限 |
| `QcloudVPCFullAccess` | VPC网络权限 |
| `QcloudCVMFullAccess` | 云服务器权限 |
| `QcloudEIPFullAccess` | 弹性公网IP权限 |

### 其他要求

- 需要先创建云防火墙实例
- 需要确定边缘防火墙的工作模式（旁路/串行）
- 需要规划网络拓扑和流量路径
- 需要准备访问控制策略规则
- 需要确认子网和公网IP配置
- 需要确定策略生效范围

---

## 变量说明

### 边缘开关配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `switches` | `list(object)` | 是 | - | 边缘防火墙开关列表 |

#### 开关对象字段说明
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `switch_enable` | `number` | 是 | - | 开关状态：0-关闭，1-开启 |
| `switch_mode` | `number` | 是 | - | 工作模式：0-旁路模式，1-串行模式 |
| `switch_public_addr` | `string` | 是 | - | 公网IP地址 |
| `switch_subnet_id` | `string` | 否 | - | 子网ID（串行模式且开启时需要） |

### 入站策略配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `inbound_policies` | `list(object)` | 否 | `[]` | 入站访问控制策略列表 |

#### 入站策略对象字段说明
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `port` | `string` | 是 | - | 端口：-1/-1-所有端口，80-端口80 |
| `protocol` | `string` | 是 | - | 协议：TCP, UDP, ICMP, ANY, HTTP, HTTPS, SMTP, FTP, DNS等 |
| `rule_action` | `string` | 是 | - | 动作：accept-允许，drop-拒绝，log-记录 |
| `source_content` | `string` | 是 | - | 源地址：net:IP/CIDR(192.168.0.2) |
| `source_type` | `string` | 是 | - | 源类型：net, location, vendor, template |
| `target_content` | `string` | 是 | - | 目标地址：net:IP/CIDR(192.168.0.2) 或 domain:*.qq.com |
| `target_type` | `string` | 是 | - | 目标类型：net, instance, tag, template, group |
| `enable` | `string` | 否 | `true` | 规则状态：true-启用，false-禁用 |
| `scope` | `string` | 否 | `ALL` | 生效范围：ALL-全局，地域代码-地域生效，实例ID-实例生效 |
| `description` | `string` | 否 | `""` | 规则描述 |
| `param_template_id` | `string` | 否 | - | 参数模板ID |

### 出站策略配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `outbound_policies` | `list(object)` | 否 | `[]` | 出站访问控制策略列表 |

#### 出站策略对象字段说明
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `port` | `string` | 是 | - | 端口：-1/-1-所有端口，80-端口80 |
| `protocol` | `string` | 是 | - | 协议：TCP, UDP, ICMP, ANY, HTTP, HTTPS, SMTP, FTP, DNS等 |
| `rule_action` | `string` | 是 | - | 动作：accept-允许，drop-拒绝，log-记录 |
| `source_content` | `string` | 是 | - | 源地址：net:IP/CIDR(192.168.0.2) |
| `source_type` | `string` | 是 | - | 源类型：net, instance, tag, template, group |
| `target_content` | `string` | 是 | - | 目标地址：net:IP/CIDR(192.168.0.2) 或 domain:*.qq.com |
| `target_type` | `string` | 是 | - | 目标类型：net, location, vendor, template |
| `enable` | `string` | 否 | `true` | 规则状态：true-启用，false-禁用 |
| `scope` | `string` | 否 | `ALL` | 生效范围：ALL-全局，地域代码-地域生效，实例ID-实例生效 |
| `description` | `string` | 否 | `""` | 规则描述 |
| `param_template_id` | `string` | 否 | - | 参数模板ID |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 边缘防火墙开关配置
switches = [
  {
    switch_enable      = 1  # 开启
    switch_mode        = 1  # 串行模式
    switch_public_addr = "203.0.113.10"
    switch_subnet_id   = "subnet-abcdef123456"
  },
  {
    switch_enable      = 1  # 开启
    switch_mode        = 0  # 旁路模式
    switch_public_addr = "203.0.113.11"
  }
]

# 入站策略配置
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
    description    = "允许公网访问Web服务"
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
    description    = "允许内网SSH访问"
  }
]

# 出站策略配置
outbound_policies = [
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:192.168.1.0/24"
    source_type    = "net"
    target_content = "domain:*.tencent.com"
    target_type    = "domain"
    enable         = "true"
    scope          = "ALL"
    description    = "允许访问腾讯云服务"
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
    description    = "禁止特定子网出站访问"
  }
]
```

### 生产环境配置示例

```hcl
# 生产环境边缘防火墙配置
switches = [
  {
    switch_enable      = 1
    switch_mode        = 1  # 核心业务使用串行模式
    switch_public_addr = "203.0.113.100"
    switch_subnet_id   = "subnet-prod-core"
  },
  {
    switch_enable      = 1
    switch_mode        = 0  # 测试环境使用旁路模式
    switch_public_addr = "203.0.113.101"
  }
]

# 生产环境入站策略
inbound_policies = [
  # Web服务访问
  {
    port           = "80,443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:10.10.1.0/24"
    target_type    = "net"
    description    = "公网Web访问"
  },
  # 管理访问
  {
    port           = "22"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.0.0.0/8"
    source_type    = "net"
    target_content = "net:10.10.0.0/16"
    target_type    = "net"
    description    = "内网管理访问"
  }
]

# 生产环境出站策略
outbound_policies = [
  # 允许访问云服务
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.10.0.0/16"
    source_type    = "net"
    target_content = "domain:*.tencentcloudapi.com"
    target_type    = "domain"
    description    = "访问腾讯云API"
  },
  # 禁止危险出站
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "drop"
    source_content = "net:10.10.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    description    = "默认禁止所有出站"
  }
]
```

### 最小化配置示例

```hcl
# 最小化边缘防火墙配置
switches = [
  {
    switch_enable      = 1
    switch_mode        = 0  # 旁路模式
    switch_public_addr = "203.0.113.50"
  }
]

# 基础入站策略
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

# 基础出站策略
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

## 使用示例

### 示例一：企业Web服务防护

```hcl
# Web服务边缘防护
switches = [
  {
    switch_enable      = 1
    switch_mode        = 1  # 串行模式深度防护
    switch_public_addr = "203.0.113.80"
    switch_subnet_id   = "subnet-web-tier"
  }
]

inbound_policies = [
  # HTTP/HTTPS访问
  {
    port           = "80,443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:10.20.1.0/24"
    target_type    = "net"
    description    = "公网Web访问"
  },
  # 阻止常见攻击端口
  {
    port           = "22,23,135,139,445"
    protocol       = "TCP"
    rule_action    = "drop"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:10.20.0.0/16"
    target_type    = "net"
    description    = "阻止管理端口外网访问"
  }
]

outbound_policies = [
  # 允许必要出站
  {
    port           = "53"
    protocol       = "UDP"
    rule_action    = "accept"
    source_content = "net:10.20.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    description    = "DNS解析"
  },
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.20.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    description    = "HTTPS出站"
  }
]
```

### 示例二：多地域分布式防护

```hcl
# 多地域边缘防护
switches = [
  # 北京地域
  {
    switch_enable      = 1
    switch_mode        = 1
    switch_public_addr = "203.0.113.100"
    switch_subnet_id   = "subnet-bj-core"
  },
  # 上海地域
  {
    switch_enable      = 1
    switch_mode        = 1
    switch_public_addr = "203.0.113.101"
    switch_subnet_id   = "subnet-sh-core"
  },
  # 广州地域
  {
    switch_enable      = 1
    switch_mode        = 0  # 旁路模式监控
    switch_public_addr = "203.0.113.102"
  }
]

# 统一入站策略
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
    description    = "全局HTTPS访问"
  }
]

# 地域差异化出站策略
outbound_policies = [
  # 北京地域出站策略
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "accept"
    source_content = "net:10.1.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    scope          = "ap-beijing"
    description    = "北京地域全出站"
  },
  # 上海地域出站策略
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.2.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    scope          = "ap-shanghai"
    description    = "上海地域HTTPS出站"
  }
]
```

### 示例三：零信任网络访问

```hcl
# 零信任边缘防护
switches = [
  {
    switch_enable      = 1
    switch_mode        = 1  # 串行模式
    switch_public_addr = "203.0.113.200"
    switch_subnet_id   = "subnet-zero-trust"
  }
]

inbound_policies = [
  # 仅允许特定IP段访问
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "accept"
    source_content = "net:192.168.100.0/24"
    source_type    = "net"
    target_content = "net:10.100.0.0/16"
    target_type    = "net"
    description    = "信任网络访问"
  },
  # 默认拒绝所有入站
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "drop"
    source_content = "net:0.0.0.0/0"
    source_type    = "net"
    target_content = "net:10.100.0.0/16"
    target_type    = "net"
    description    = "默认拒绝所有入站"
  }
]

outbound_policies = [
  # 仅允许访问特定服务
  {
    port           = "443"
    protocol       = "TCP"
    rule_action    = "accept"
    source_content = "net:10.100.0.0/16"
    source_type    = "net"
    target_content = "domain:*.microsoft.com"
    target_type    = "domain"
    description    = "访问Microsoft服务"
  },
  # 默认拒绝所有出站
  {
    port           = "-1/-1"
    protocol       = "ANY"
    rule_action    = "drop"
    source_content = "net:10.100.0.0/16"
    source_type    = "net"
    target_content = "net:0.0.0.0/0"
    target_type    = "net"
    description    = "默认拒绝所有出站"
  }
]
```

---

## 配置说明

### 工作模式说明

#### 旁路模式（Switch Mode 0）
- **特点**：流量不经过防火墙直接转发
- **优势**：零延迟，不影响网络性能
- **适用**：监控模式，日志记录，测试环境
- **限制**：无法实时阻断攻击

#### 串行模式（Switch Mode 1）
- **特点**：流量必须经过防火墙检测
- **优势**：实时防护，可阻断攻击
- **适用**：生产环境，高安全要求
- **要求**：需要指定子网创建私有连接
- **影响**：可能增加网络延迟

### 策略配置指南

#### 端口配置
- **所有端口**：`-1/-1`
- **单个端口**：`80`、`443`、`22`
- **端口范围**：`1000-2000`
- **多个端口**：`80,443,8080`

#### 协议选择
- **入站协议**：TCP, UDP, ICMP, ANY, HTTP, HTTPS, SMTP, FTP, DNS等
- **出站协议**：TCP, UDP, ANY
- **协议组合**：HTTP/HTTPS, SMTP/SMTPS

#### 动作类型
- **允许（accept）**：允许流量通过
- **拒绝（drop）**：静默丢弃流量
- **记录（log）**：记录流量但不阻止

#### 地址类型
- **网络地址（net）**：IP/CIDR格式
- **实例（instance）**：云服务器实例
- **标签（tag）**：资源标签
- **模板（template）**：参数模板
- **分组（group）**：安全组
- **地域（location）**：地理区域
- **厂商（vendor）**：云服务商
- **域名（domain）**：域名规则

#### 生效范围
- **全局（ALL）**：所有实例生效
- **地域级**：特定地域生效（如：ap-beijing）
- **实例级**：特定实例生效（如：cfwnat-xxx）

### 最佳实践

1. **最小权限原则**：只开放必要的端口和协议
2. **默认拒绝**：配置默认拒绝规则，显式允许必要流量
3. **分层防护**：结合网络ACL、安全组、CFW多层防护
4. **日志监控**：启用日志记录，定期审计策略
5. **测试验证**：在生产环境前充分测试策略
6. **版本控制**：使用Terraform管理策略版本
7. **定期审查**：定期审查和优化策略规则

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **模式选择**
   - 串行模式需要指定子网ID
   - 旁路模式适合监控，串行模式适合防护
   - 生产环境推荐使用串行模式

2. **网络规划**
   - 确认公网IP地址正确配置
   - 检查子网路由表配置
   - 验证网络连通性

3. **策略配置**
   - 避免过于宽松的策略
   - 按业务需求最小化开放
   - 测试策略避免业务中断

4. **依赖关系**
   - 策略配置依赖资产同步
   - 确保CFW实例已创建
   - 检查网络资源权限

5. **性能影响**
   - 串行模式可能增加延迟
   - 复杂策略可能影响性能
   - 监控防火墙性能指标

6. **合规要求**
   - 确保配置符合安全标准
   - 保留足够的审计日志
   - 遵循行业合规要求

7. **变更管理**
   - 生产环境变更前充分测试
   - 制定回滚计划
   - 记录变更操作日志

8. **监控告警**
   - 配置防火墙监控告警
   - 监控策略命中情况
   - 设置异常流量告警

9. **备份恢复**
   - 定期备份防火墙配置
   - 测试配置恢复流程
   - 保留历史配置版本

10. **技术支持**
    - 遇到问题联系腾讯云支持
    - 提供详细的错误信息
    - 准备网络拓扑图和相关配置

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
- 检查CFW相关权限
- 申请QcloudCFWFullAccess权限
- 验证网络资源权限

#### 错误二：网络配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Network configuration error
```

**原因**：子网或公网IP配置错误
**解决方案**：
- 检查公网IP地址是否正确
- 验证子网ID是否存在
- 检查网络连通性

#### 错误三：策略配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy configuration error
```

**原因**：策略参数格式或值错误
**解决方案**：
- 检查策略对象格式
- 确认参数值符合要求
- 验证协议和端口格式

#### 错误四：资源不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Resource not found
```

**原因**：引用的资源不存在
**解决方案**：
- 检查子网、公网IP是否存在
- 确认CFW实例已创建
- 验证地域配置正确

#### 错误五：模式冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Mode conflict
```

**原因**：工作模式配置冲突
**解决方案**：
- 检查switch_mode值（0或1）
- 确认串行模式已指定子网
- 验证配置一致性

#### 错误六：资产未同步

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Asset not synchronized
```

**原因**：资产信息未同步到防火墙
**解决方案**：
- 等待资产同步完成
- 检查sync_asset资源状态
- 验证网络资源权限

#### 错误七：配额限制

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Quota exceeded
```

**原因**：超过资源配额限制
**解决方案**：
- 检查当前资源使用情况
- 申请配额扩容
- 优化策略配置