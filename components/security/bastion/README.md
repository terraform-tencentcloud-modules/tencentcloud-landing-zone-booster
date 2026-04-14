# 腾讯云堡垒机模块

## 模块概述

本模块用于在腾讯云中部署和管理堡垒机（Bastion Host）服务，提供安全的远程访问管理能力，主要功能包括：

- **VPC网络集成** - 支持自动创建VPC或使用现有VPC
- **堡垒机部署** - 部署标准版堡垒机实例
- **访问控制** - 支持内网访问和外网访问配置
- **计费管理** - 支持包年包月计费模式
- **自动续费** - 支持自动续费功能
- **多节点部署** - 支持多节点高可用部署
- **标签管理** - 支持资源标签分类管理
- **资源输出** - 输出堡垒机资源ID便于后续管理

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
| `QcloudBastionHostFullAccess` | 堡垒机全权限 |
| `QcloudVPCFullAccess` | VPC网络全权限 |
| `QcloudFinanceFullAccess` | 财务管理权限 |
| `QcloudTagFullAccess` | 标签管理权限 |
| `QcloudBillingReadOnlyAccess` | 账单只读权限 |

### 其他要求

- 需要确定部署地域和可用区
- 需要规划VPC网络CIDR和子网划分
- 需要确定堡垒机规格和节点数量
- 需要确定计费周期和续费策略
- 需要规划访问控制策略（内网/外网）
- 需要准备标签分类方案

---

## 变量说明

### 主要配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `deploy_region` | `string` | 是 | - | 堡垒机部署地域 |
| `deploy_zone` | `string` | 是 | - | 堡垒机部署可用区 |
| `create_vpc` | `bool` | 否 | `false` | 是否自动创建VPC |

### 堡垒机配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `cidr_block` | `string` | 否 | `null` | 堡垒机CIDR块 |
| `resource_edition` | `string` | 否 | `null` | 堡垒机版本（如：standard） |
| `resource_node` | `number` | 否 | `null` | 堡垒机节点数量 |
| `time_unit` | `string` | 否 | `null` | 购买时间单位（m表示月） |
| `time_span` | `number` | 否 | `null` | 购买时长（如：1） |
| `pay_mode` | `number` | 否 | `1` | 付费模式（1表示包年包月） |
| `auto_renew_flag` | `number` | 否 | `1` | 自动续费标识（1表示启用） |
| `intranet_access` | `number` | 否 | `1` | 内网访问（1表示启用） |
| `external_access` | `number` | 否 | `1` | 外网访问（1表示启用） |

### 现有VPC配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpc_id` | `string` | 条件 | `null` | 现有VPC ID |
| `subnet_id` | `string` | 条件 | `null` | 现有子网ID |
| `vpc_cidr_block` | `string` | 条件 | `null` | 现有VPC CIDR块 |

### VPC创建配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpc_default_subnet_name` | `string` | 否 | `default_subnet` | 默认子网名称 |
| `vpc_availability_zones` | `list(string)` | 否 | `[]` | 可用区列表 |
| `vpc_common_tags` | `map(string)` | 否 | `null` | VPC通用标签 |
| `vpc_name` | `string` | 否 | `null` | VPC名称 |
| `vpc_cidr` | `string` | 否 | `null` | VPC CIDR块 |
| `vpc_is_multicast` | `bool` | 否 | `null` | 是否启用组播 |
| `vpc_tags` | `map(string)` | 否 | `null` | VPC标签 |

### 子网配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpc_subnet_cidrs` | `list(object)` | 否 | `[]` | 子网CIDR配置列表 |
| `vpc_subnet_tags` | `map(string)` | 否 | `null` | 子网标签 |

### 子网对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `subnet_name` | `string` | 是 | - | 子网名称（最多60字符） |
| `subnet_cidr` | `string` | 是 | - | 子网CIDR块 |
| `subnet_is_multicast` | `bool` | 否 | `true` | 是否启用组播 |
| `availability_zone` | `string` | 否 | - | 可用区，不设置时随机选择 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 基础配置
deploy_region = "ap-guangzhou"
deploy_zone   = "ap-guangzhou-1"
create_vpc    = true

# 堡垒机配置
cidr_block       = "10.0.0.0/16"
resource_edition = "standard"
resource_node    = 2
time_unit        = "m"
time_span        = 12
pay_mode         = 1
auto_renew_flag  = 1
intranet_access  = 1
external_access  = 0

# VPC配置
vpc_default_subnet_name = "bastion_subnet"
vpc_availability_zones  = ["ap-guangzhou-1", "ap-guangzhou-2"]
vpc_common_tags = {
  Environment = "Production"
  Department = "Security"
}
vpc_name         = "bastion_vpc"
vpc_cidr         = "10.0.0.0/16"
vpc_is_multicast = true
vpc_tags = {
  Purpose = "Bastion Host"
  Owner   = "SecurityTeam"
}

# 子网配置
vpc_subnet_cidrs = [
  {
    subnet_name         = "bastion_subnet_1"
    subnet_cidr         = "10.0.1.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-guangzhou-1"
  },
  {
    subnet_name         = "bastion_subnet_2"
    subnet_cidr         = "10.0.2.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-guangzhou-2"
  }
]

vpc_subnet_tags = {
  Tier     = "Private"
  UseCase = "Bastion"
}
```

### 使用现有VPC配置示例

```hcl
# 基础配置
deploy_region = "ap-shanghai"
deploy_zone   = "ap-shanghai-1"
create_vpc    = false

# 现有VPC配置
vpc_id          = "vpc-12345678"
subnet_id       = "subnet-12345678"
vpc_cidr_block  = "192.168.0.0/16"

# 堡垒机配置
cidr_block       = "192.168.10.0/24"
resource_edition = "standard"
resource_node    = 1
time_unit        = "m"
time_span        = 6
pay_mode         = 1
auto_renew_flag  = 0
intranet_access  = 1
external_access  = 1
```

### 最小化配置示例

```hcl
# 基础配置
deploy_region = "ap-beijing"
deploy_zone   = "ap-beijing-1"
create_vpc    = true

# 最小VPC配置
vpc_name = "bastion_minimal_vpc"
vpc_cidr = "172.16.0.0/16"

# 最小堡垒机配置
# 使用默认值：包年包月、自动续费、启用内网访问、禁用外网访问
```

### 高可用配置示例

```hcl
# 基础配置
deploy_region = "ap-guangzhou"
deploy_zone   = "ap-guangzhou-1"
create_vpc    = true

# 高可用VPC配置
vpc_name         = "bastion_ha_vpc"
vpc_cidr         = "10.100.0.0/16"
vpc_is_multicast = true
vpc_availability_zones = ["ap-guangzhou-1", "ap-guangzhou-2", "ap-guangzhou-3"]

# 多子网配置
vpc_subnet_cidrs = [
  {
    subnet_name         = "bastion_subnet_az1"
    subnet_cidr         = "10.100.1.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-guangzhou-1"
  },
  {
    subnet_name         = "bastion_subnet_az2"
    subnet_cidr         = "10.100.2.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-guangzhou-2"
  },
  {
    subnet_name         = "bastion_subnet_az3"
    subnet_cidr         = "10.100.3.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-guangzhou-3"
  }
]

# 高可用堡垒机配置
resource_edition = "standard"
resource_node    = 3  # 3节点高可用
time_unit        = "m"
time_span        = 12
pay_mode         = 1
auto_renew_flag  = 1
intranet_access  = 1
external_access  = 0

# 标签配置
vpc_common_tags = {
  Environment = "Production"
  HA          = "Multi-AZ"
}
vpc_tags = {
  Criticality = "High"
  Backup      = "Enabled"
}
```

### 开发环境配置示例

```hcl
# 基础配置
deploy_region = "ap-shanghai"
deploy_zone   = "ap-shanghai-2"
create_vpc    = true

# 开发环境VPC配置
vpc_name = "bastion_dev_vpc"
vpc_cidr = "10.200.0.0/16"

# 单子网配置
vpc_subnet_cidrs = [
  {
    subnet_name         = "bastion_dev_subnet"
    subnet_cidr         = "10.200.1.0/24"
    subnet_is_multicast = false
    availability_zone   = "ap-shanghai-2"
  }
]

# 开发环境堡垒机配置
resource_edition = "standard"
resource_node    = 1
time_unit        = "m"
time_span        = 1  # 1个月
pay_mode         = 1
auto_renew_flag  = 0  # 不自动续费
intranet_access  = 1
external_access  = 1  # 开发环境启用外网访问

# 开发环境标签
vpc_tags = {
  Environment = "Development"
  Purpose     = "Testing"
}
```

---

## 使用示例

### 示例一：生产环境堡垒机部署

```hcl
# 生产环境堡垒机配置
deploy_region = "ap-guangzhou"
deploy_zone   = "ap-guangzhou-3"
create_vpc    = true

# 生产VPC配置
vpc_name         = "prod_bastion_vpc"
vpc_cidr         = "10.10.0.0/16"
vpc_is_multicast = true
vpc_availability_zones = ["ap-guangzhou-3"]

# 生产子网配置
vpc_subnet_cidrs = [
  {
    subnet_name         = "prod_bastion_subnet"
    subnet_cidr         = "10.10.1.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-guangzhou-3"
  }
]

# 生产堡垒机配置
cidr_block       = "10.10.1.0/24"
resource_edition = "standard"
resource_node    = 2  # 双节点高可用
time_unit        = "m"
time_span        = 36  # 3年
pay_mode         = 1
auto_renew_flag  = 1  # 自动续费
intranet_access  = 1
external_access  = 0  # 生产环境禁用外网访问

# 生产环境标签
vpc_common_tags = {
  Environment = "Production"
  CostCenter  = "Security"
}
vpc_tags = {
  SLACritical = "Yes"
  Monitoring  = "Enabled"
}
vpc_subnet_tags = {
  SecurityZone = "DMZ"
}
```

### 示例二：混合云环境堡垒机

```hcl
# 混合云环境配置
deploy_region = "ap-beijing"
deploy_zone   = "ap-beijing-1"
create_vpc    = false

# 使用现有企业VPC
vpc_id          = "vpc-enterprise-123"
subnet_id       = "subnet-bastion-456"
vpc_cidr_block  = "172.16.0.0/16"

# 混合云堡垒机配置
cidr_block       = "172.16.100.0/24"
resource_edition = "standard"
resource_node    = 1
time_unit        = "m"
time_span        = 12
pay_mode         = 1
auto_renew_flag  = 1
intranet_access  = 1
external_access  = 1  # 混合云需要外网访问

# 企业环境标签（通过现有VPC标签管理）
```

### 示例三：安全加固堡垒机

```hcl
# 安全加固配置
deploy_region = "ap-shanghai"
deploy_zone   = "ap-shanghai-1"
create_vpc    = true

# 安全VPC配置
vpc_name = "secure_bastion_vpc"
vpc_cidr = "192.168.0.0/16"

# 最小权限子网
vpc_subnet_cidrs = [
  {
    subnet_name         = "secure_bastion_subnet"
    subnet_cidr         = "192.168.100.0/24"
    subnet_is_multicast = false  # 禁用组播增强安全
    availability_zone   = "ap-shanghai-1"
  }
]

# 安全堡垒机配置
resource_edition = "standard"
resource_node    = 1
time_unit        = "m"
time_span        = 12
pay_mode         = 1
auto_renew_flag  = 0  # 手动续费便于审计
intranet_access  = 1
external_access  = 0  # 严格禁用外网访问

# 安全标签
vpc_tags = {
  SecurityLevel = "High"
  Compliance    = "PCI-DSS"
}
vpc_subnet_tags = {
  AccessControl = "Restricted"
  Logging       = "Enabled"
}
```

---

## 配置说明

### VPC创建模式选择

#### 自动创建VPC（create_vpc = true）
- **适用场景**：新建环境或独立部署
- **优势**：自动化部署，完整控制网络配置
- **注意事项**：需要配置完整的VPC参数

#### 使用现有VPC（create_vpc = false）
- **适用场景**：已有网络环境集成
- **优势**：复用现有网络资源，快速部署
- **注意事项**：需要提供正确的VPC和子网ID

### 访问控制策略

#### 内网访问（intranet_access = 1）
- **默认启用**：建议生产环境启用
- **安全等级**：较高，仅限内网访问
- **适用场景**：内部管理、跳板访问

#### 外网访问（external_access = 1）
- **默认禁用**：生产环境建议禁用
- **安全等级**：较低，暴露公网风险
- **适用场景**：临时访问、开发测试

### 计费模式说明

#### 包年包月（pay_mode = 1）
- **计费方式**：预付费
- **成本优势**：长期使用成本较低
- **适用场景**：稳定业务环境

#### 自动续费（auto_renew_flag = 1）
- **便利性**：自动续费避免服务中断
- **成本控制**：需要注意费用预算
- **审计要求**：某些环境可能需要手动续费

### 高可用部署

#### 单节点部署
- **适用场景**：开发测试环境
- **成本**：较低
- **可用性**：单点故障风险

#### 多节点部署
- **适用场景**：生产环境
- **成本**：较高
- **可用性**：高可用，故障自动切换

### 地域选择建议

| 地域 | 编码 | 适用场景 | 延迟 |
|------|------|----------|------|
| **华南地区** | ap-guangzhou | 华南用户访问 | 低 |
| **华东地区** | ap-shanghai | 华东用户访问 | 低 |
| **华北地区** | ap-beijing | 华北用户访问 | 低 |
| **西南地区** | ap-chongqing | 西南用户访问 | 中 |

### 安全最佳实践

1. **网络隔离**：堡垒机部署在独立VPC或专用子网
2. **访问控制**：生产环境禁用外网访问
3. **日志审计**：启用堡垒机操作日志
4. **定期轮换**：定期更换访问凭证
5. **权限最小化**：遵循最小权限原则
6. **监控告警**：设置异常访问告警

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **网络规划**
   - 提前规划VPC CIDR，避免IP冲突
   - 确保子网CIDR在VPC CIDR范围内
   - 考虑未来的扩展需求

2. **地域限制**
   - 堡垒机服务有地域属性
   - VPC和堡垒机必须在同一地域
   - 跨地域访问需要额外配置

3. **权限验证**
   - 确认有足够的权限创建堡垒机
   - 检查账户额度限制
   - 验证网络权限

4. **计费确认**
   - 包年包月需要预付费用
   - 确认自动续费设置
   - 注意节点数量对费用的影响

5. **访问策略**
   - 生产环境建议禁用外网访问
   - 配置严格的安全组规则
   - 启用多因素认证

6. **高可用考虑**
   - 生产环境建议多节点部署
   - 考虑跨可用区部署
   - 配置自动故障转移

7. **标签管理**
   - 遵循统一的标签命名规范
   - 使用标签进行成本分摊
   - 利用标签进行资源管理

8. **测试验证**
   - 部署后测试堡垒机连接
   - 验证网络连通性
   - 测试访问控制策略

9. **监控配置**
   - 配置堡垒机监控
   - 设置性能阈值告警
   - 监控异常访问行为

10. **备份策略**
    - 定期备份堡垒机配置
    - 制定灾难恢复计划
    - 测试恢复流程

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
- 检查BastionHost相关权限
- 申请QcloudBastionHostFullAccess权限
- 验证VPC相关权限

#### 错误二：额度限制

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Resource limit exceeded
```

**原因**：达到资源数量限制
**解决方案**：
- 检查当前堡垒机实例数量
- 申请提高资源额度
- 选择更低配置

#### 错误三：网络冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=CIDR block conflict
```

**原因**：CIDR块冲突
**解决方案**：
- 检查VPC CIDR是否冲突
- 修改CIDR块配置
- 使用不同的IP段

#### 错误四：地域不可用

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**原因**：选择的地域不支持堡垒机
**解决方案**：
- 检查地域可用性
- 选择支持的地域
- 联系腾讯云支持

#### 错误五：VPC不存在

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=VPC not found
```

**原因**：指定的VPC不存在
**解决方案**：
- 检查VPC ID是否正确
- 确认VPC在目标地域存在
- 使用自动创建VPC模式

#### 错误六：子网不存在

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Subnet not found
```

**原因**：指定的子网不存在
**解决方案**：
- 检查子网ID是否正确
- 确认子网在目标VPC中存在
- 使用自动创建VPC模式