# 腾讯云云防火墙（CFW）NAT防火墙模块

## 模块概述

本模块用于在腾讯云中配置和管理云防火墙（Cloud Firewall，CFW）的NAT防火墙功能，提供NAT实例管理、工作模式支持、带宽配置、多可用区部署、开关管理和策略控制等核心能力。

---

## 前置要求

### 环境要求
- Terraform `>= 1.3.0`
- tencentcloud provider `>= 1.81.0`

### 权限要求
- `QcloudCFWFullAccess` - 云防火墙全权限
- `QcloudVPCFullAccess` - VPC网络权限
- `QcloudNATGatewayFullAccess` - NAT网关权限

---

## 变量说明

### 必需变量
| 变量名 | 类型 | 说明 |
|--------|------|------|
| `mode` | `number` | 工作模式：0-新模式，1-接入模式 |
| `name` | `string` | 防火墙实例名称 |
| `width` | `number` | 带宽规格（Mbps） |
| `zone_set` | `set(string)` | 可用区集合 |
| `switches` | `list(object)` | NAT防火墙开关列表 |

### 可选变量
| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `cross_a_zone` | `number` | `0` | 异地灾备：0-不启用，1-启用 |
| `nat_gw_list` | `set(string)` | `[]` | NAT网关列表（接入模式） |
| `new_mode_items` | `list(object)` | `[]` | 新模式配置参数 |
| `inbound_policies` | `list(object)` | `[]` | 入站访问控制策略 |
| `outbound_policies` | `list(object)` | `[]` | 出站访问控制策略 |

---

## 变量配置示例

### 基础配置
```hcl
mode        = 1  # 接入模式
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

### 新模式配置
```hcl
mode        = 0  # 新模式
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

## 使用示例

### 企业多NAT网关接入
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

### 异地灾备部署
```hcl
mode        = 1
name        = "dr-nat-fw"
width       = 3000
zone_set    = ["ap-beijing-1", "ap-shanghai-1"]
cross_a_zone = 1  # 启用异地灾备

nat_gw_list = ["nat-bj-1", "nat-sh-1"]
```

---

## 配置说明

### 工作模式
- **接入模式（Mode 1）**：基于现有NAT网关部署
- **新模式（Mode 0）**：直接使用弹性公网IP部署

### 灾备模式
- **本地高可用**：单地域多可用区部署
- **异地灾备**：跨地域灾备部署

### 策略配置
- **端口**：-1/-1（所有端口），80（端口80）
- **协议**：TCP, UDP, ICMP, ANY, HTTP, HTTPS等
- **动作**：accept（允许），drop（拒绝），log（记录）
- **地址类型**：net, instance, tag, template, group等

---

## 注意事项

1. **模式选择**：接入模式需要已存在的NAT网关，新模式需要弹性公网IP
2. **带宽规划**：按业务峰值流量选择合适带宽
3. **网络规划**：确认VPC、子网、NAT网关配置正确
4. **策略配置**：按最小权限原则配置访问策略
5. **灾备考虑**：异地灾备增加跨地域带宽成本

---

## 故障排除

### 常见错误
- **权限不足**：检查CFW、VPC、NAT网关权限
- **网络配置错误**：验证NAT网关、VPC、子网配置
- **资源不存在**：确认引用的资源ID正确
- **带宽超限**：检查带宽配额，申请扩容
- **可用区不可用**：选择其他可用区