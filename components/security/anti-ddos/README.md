# 腾讯云DDoS高防模块

## 模块概述

本模块用于在腾讯云中部署和管理DDoS高防服务，提供专业的DDoS攻击防护能力，主要功能包括：

- **多套餐支持** - 支持企业版、标准版、标准版2.0三种防护套餐
- **灵活计费** - 支持包年包月和按量计费两种计费模式
- **弹性带宽** - 支持弹性带宽扩展应对突发流量
- **多IP防护** - 支持多IP地址同时防护
- **地域部署** - 支持多地域部署优化访问体验
- **标签管理** - 支持资源标签分类管理
- **自动配置** - 根据套餐类型自动配置相应参数
- **资源输出** - 输出高防实例ID便于后续管理

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
| `QcloudAntiDDoSFullAccess` | DDoS高防全权限 |
| `QcloudFinanceFullAccess` | 财务管理权限 |
| `QcloudTagFullAccess` | 标签管理权限 |
| `QcloudBillingReadOnlyAccess` | 账单只读权限 |

### 其他要求

- 需要了解DDoS防护的基本概念和需求
- 需要确定防护套餐类型和规格
- 需要规划防护IP数量和带宽需求
- 需要选择合适的地域部署
- 需要确定计费模式和周期
- 需要准备标签分类方案

---

## 变量说明

### 主要配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `instance_charge_type` | `string` | 是 | - | 计费模式：`PREPAID`(包年包月)/`POSTPAID_BY_MONTH`(按量计费) |
| `package_type` | `string` | 是 | - | 防护套餐：`Enterprise`(企业版)/`Standard`(标准版)/`StandardPlus`(标准版2.0) |
| `tag_info_list` | `list(object)` | 否 | `[]` | 标签信息列表 |

### 包年包月计费配置

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `instance_charge_prepaid_period` | `number` | 条件 | `null` | 购买时长（月数） |
| `instance_charge_prepaid_renew_flag` | `string` | 否 | `OTIFY_AND_MANUAL_RENEW` | 续费标识：`OTIFY_AND_MANUAL_RENEW`(通知不自动续费)/`NOTIFY_AND_AUTO_RENEW`(通知自动续费)/`DISABLE_NOTIFY_AND_MANUAL_RENEW`(不通知不自动续费) |

### 标准版配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `standard_region` | `string` | 条件 | `null` | 高防包购买地域 |
| `standard_protect_ip_count` | `number` | 条件 | `null` | 防护IP数量（如：1,10,50,100） |
| `standard_bandwidth` | `number` | 条件 | `null` | 防护服务带宽（Mbps） |
| `standard_elastic_bandwidth_flag` | `bool` | 否 | `false` | 是否启用弹性服务带宽 |

### 标准版2.0配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `standard_plus_region` | `string` | 条件 | `null` | 高防包购买地域 |
| `standard_plus_protect_count` | `string` | 条件 | `null` | 防护次数：`TWO_TIMES`(2次全力防护)/`UNLIMITED`(无限次防护) |
| `standard_plus_protect_ip_count` | `number` | 条件 | `null` | 防护IP数量（如：1,10,50,100） |
| `standard_plus_bandwidth` | `number` | 条件 | `null` | 防护服务带宽（Mbps） |
| `standard_plus_elastic_bandwidth_flag` | `bool` | 否 | `false` | 是否启用弹性服务带宽 |

### 企业版配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `enterprise_region` | `string` | 条件 | `null` | 高防包购买地域 |
| `enterprise_protect_ip_count` | `number` | 条件 | `null` | 防护IP数量（如：1,10,50,100） |
| `enterprise_basic_protect_bandwidth` | `number` | 条件 | `null` | 保底防护带宽（Gbps） |
| `enterprise_bandwidth` | `number` | 条件 | `null` | 服务带宽规模 |
| `enterprise_elastic_protect_bandwidth` | `number` | 否 | `0` | 弹性带宽（Gbps，可选：0,400,500,600,800,1000） |
| `enterprise_elastic_bandwidth_flag` | `bool` | 否 | `false` | 是否启用弹性服务带宽 |

### 标签对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `key` | `string` | 是 | - | 标签键 |
| `value` | `string` | 是 | - | 标签值 |

### 套餐类型对比

| 特性 | 企业版 | 标准版2.0 | 标准版 |
|------|--------|-----------|--------|
| **防护能力** | 最高 | 高 | 基础 |
| **防护次数** | 无限次 | 可选2次/无限次 | 基础防护 |
| **弹性带宽** | 支持 | 支持 | 支持 |
| **适用场景** | 大型企业 | 中型企业 | 小型企业 |
| **成本** | 高 | 中 | 低 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 基础配置
instance_charge_type = "PREPAID"
package_type        = "Enterprise"

# 包年包月配置
instance_charge_prepaid_period    = 12
instance_charge_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"

# 企业版配置
enterprise_region                    = "ap-guangzhou"
enterprise_protect_ip_count          = 10
enterprise_basic_protect_bandwidth   = 100
enterprise_bandwidth                 = 200
enterprise_elastic_protect_bandwidth = 500
enterprise_elastic_bandwidth_flag    = true

# 标签配置
tag_info_list = [
  {
    key   = "Environment"
    value = "Production"
  },
  {
    key   = "Department"
    value = "Security"
  },
  {
    key   = "Project"
    value = "AntiDDoS"
  }
]
```

### 标准版配置示例

```hcl
# 基础配置
instance_charge_type = "POSTPAID_BY_MONTH"
package_type        = "Standard"

# 标准版配置
standard_region                 = "ap-beijing"
standard_protect_ip_count       = 5
standard_bandwidth              = 50
standard_elastic_bandwidth_flag = true

# 标签配置
tag_info_list = [
  {
    key   = "Environment"
    value = "Development"
  },
  {
    key   = "Team"
    value = "DevOps"
  }
]
```

### 标准版2.0配置示例

```hcl
# 基础配置
instance_charge_type = "PREPAID"
package_type        = "StandardPlus"

# 包年包月配置
instance_charge_prepaid_period    = 6
instance_charge_prepaid_renew_flag = "OTIFY_AND_MANUAL_RENEW"

# 标准版2.0配置
standard_plus_region                 = "ap-shanghai"
standard_plus_protect_count          = "UNLIMITED"
standard_plus_protect_ip_count       = 20
standard_plus_bandwidth              = 100
standard_plus_elastic_bandwidth_flag = false

# 标签配置
tag_info_list = [
  {
    key   = "Environment"
    value = "Staging"
  },
  {
    key   = "Business"
    value = "E-commerce"
  }
]
```

### 混合配置示例

```hcl
# 基础配置
instance_charge_type = "PREPAID"
package_type        = "Enterprise"

# 包年包月配置
instance_charge_prepaid_period    = 24
instance_charge_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"

# 企业版高级配置
enterprise_region                    = "ap-guangzhou"
enterprise_protect_ip_count          = 50
enterprise_basic_protect_bandwidth   = 200
enterprise_bandwidth                 = 500
enterprise_elastic_protect_bandwidth = 1000
enterprise_elastic_bandwidth_flag    = true

# 详细标签配置
tag_info_list = [
  {
    key   = "Environment"
    value = "Production"
  },
  {
    key   = "CostCenter"
    value = "Security"
  },
  {
    key   = "Application"
    value = "WebService"
  },
  {
    key   = "Owner"
    value = "SecurityTeam"
  },
  {
    key   = "Compliance"
    value = "PCI-DSS"
  },
  {
    key   = "Backup"
    value = "Enabled"
  }
]
```

### 按量计费配置示例

```hcl
# 基础配置
instance_charge_type = "POSTPAID_BY_MONTH"
package_type        = "Standard"

# 标准版配置（按量计费）
standard_region                 = "ap-beijing"
standard_protect_ip_count       = 3
standard_bandwidth              = 30
standard_elastic_bandwidth_flag = false

# 简单标签配置
tag_info_list = [
  {
    key   = "Billing"
    value = "PayAsYouGo"
  },
  {
    key   = "Tier"
    value = "Standard"
  }
]
```

---

## 使用示例

### 示例一：企业生产环境防护

```hcl
# 企业生产环境DDoS防护配置
instance_charge_type = "PREPAID"
package_type        = "Enterprise"

# 包年包年配置（2年自动续费）
instance_charge_prepaid_period    = 24
instance_charge_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"

# 企业版高级防护配置
enterprise_region                    = "ap-guangzhou"
enterprise_protect_ip_count          = 25
enterprise_basic_protect_bandwidth   = 150
enterprise_bandwidth                 = 300
enterprise_elastic_protect_bandwidth = 800
enterprise_elastic_bandwidth_flag    = true

# 生产环境标签
tag_info_list = [
  {
    key   = "Env"
    value = "Prod"
  },
  {
    key   = "Criticality"
    value = "High"
  },
  {
    key   = "SLACritical"
    value = "Yes"
  }
]
```

### 示例二：开发测试环境防护

```hcl
# 开发测试环境DDoS防护配置
instance_charge_type = "POSTPAID_BY_MONTH"
package_type        = "Standard"

# 标准版基础配置（按量计费）
standard_region                 = "ap-shanghai"
standard_protect_ip_count       = 2
standard_bandwidth              = 20
standard_elastic_bandwidth_flag = false

# 开发环境标签
tag_info_list = [
  {
    key   = "Env"
    value = "Dev"
  },
  {
    key   = "Purpose"
    value = "Testing"
  }
]
```

### 示例三：电商业务防护

```hcl
# 电商业务DDoS防护配置
instance_charge_type = "PREPAID"
package_type        = "StandardPlus"

# 包年包月配置（1年自动续费）
instance_charge_prepaid_period    = 12
instance_charge_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"

# 标准版2.0无限防护配置
standard_plus_region                 = "ap-beijing"
standard_plus_protect_count          = "UNLIMITED"
standard_plus_protect_ip_count       = 15
standard_plus_bandwidth              = 80
standard_plus_elastic_bandwidth_flag = true

# 电商业务标签
tag_info_list = [
  {
    key   = "Business"
    value = "E-commerce"
  },
  {
    key   = "PeakHours"
    value = "9-21"
  },
  {
    key   = "RevenueCritical"
    value = "Yes"
  }
]
```

---

## 配置说明

### 计费模式选择

#### 包年包月（PREPAID）
- **适用场景**：长期稳定的业务
- **优势**：成本较低，资源保障
- **注意事项**：需要预付费用，灵活性较低

#### 按量计费（POSTPAID_BY_MONTH）
- **适用场景**：临时或测试环境
- **优势**：按使用付费，灵活性高
- **注意事项**：成本相对较高，资源可能受限

### 套餐类型选择指南

#### 企业版（Enterprise）
- **适用场景**：大型企业、金融、游戏等高安全要求业务
- **防护能力**：最高级别防护，无限次防护
- **带宽支持**：支持大带宽和弹性带宽
- **成本**：较高

#### 标准版2.0（StandardPlus）
- **适用场景**：中型企业、电商、在线服务等
- **防护能力**：高强度防护，可选2次或无限次防护
- **带宽支持**：适中带宽，支持弹性带宽
- **成本**：中等

#### 标准版（Standard）
- **适用场景**：小型企业、个人网站、测试环境
- **防护能力**：基础防护
- **带宽支持**：基础带宽，可选弹性带宽
- **成本**：较低

### 地域选择建议

| 地域 | 编码 | 适用场景 | 延迟 |
|------|------|----------|------|
| **华南地区** | ap-guangzhou | 华南用户访问 | 低 |
| **华东地区** | ap-shanghai | 华东用户访问 | 低 |
| **华北地区** | ap-beijing | 华北用户访问 | 低 |
| **西南地区** | ap-chongqing | 西南用户访问 | 中 |

### 弹性带宽配置

弹性带宽用于应对突发的大流量攻击：
- **启用时机**：业务有突发流量需求时
- **成本考虑**：按实际使用量计费
- **配置建议**：根据业务峰值流量配置

### 标签管理最佳实践

1. **环境标识**：使用Env标签标识环境（Prod/Dev/Test）
2. **业务分类**：使用Business标签标识业务类型
3. **成本中心**：使用CostCenter标签进行成本分摊
4. **安全等级**：使用Criticality标签标识安全等级
5. **负责人**：使用Owner标签标识资源负责人

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **计费模式**
   - 包年包月需要预付费用，请确保账户余额充足
   - 按量计费会按小时扣费，注意费用控制

2. **套餐选择**
   - 选择适合业务规模的套餐，避免过度配置
   - 企业版和标准版2.0支持更高防护能力

3. **地域限制**
   - 高防包有地域属性，请选择正确的地域
   - 跨地域防护需要额外配置

4. **IP数量**
   - 防护IP数量需要提前规划
   - 增加IP数量可能涉及套餐变更

5. **带宽配置**
   - 基础带宽要满足日常业务需求
   - 弹性带宽用于应对突发流量

6. **续费设置**
   - 包年包月务必设置合适的续费策略
   - 避免服务到期导致防护中断

7. **标签规范**
   - 遵循统一的标签命名规范
   - 确保标签键值对的唯一性

8. **权限验证**
   - 确认有足够的权限创建高防实例
   - 检查账户额度限制

9. **测试验证**
   - 部署后测试防护效果
   - 验证标签是否正确应用

10. **监控告警**
    - 设置资源使用监控
    - 配置费用超支告警

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
- 检查AntiDDoS相关权限
- 申请QcloudAntiDDoSFullAccess权限

#### 错误二：额度限制

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Resource limit exceeded
```

**原因**：达到资源数量限制
**解决方案**：
- 检查当前高防实例数量
- 申请提高资源额度

#### 错误三：地域不可用

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**原因**：选择的地域不支持该套餐
**解决方案**：
- 检查地域可用性
- 选择支持的地域

#### 错误四：套餐冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Package type conflict
```

**原因**：配置了不匹配的套餐参数
**解决方案**：
- 检查package_type与具体配置的匹配性
- 确保只配置当前套餐类型的参数

#### 错误五：计费错误

```
Error: [TencentCloudSDKError] Code=BillingError
Message=Billing configuration error
```

**原因**：计费配置错误
**解决方案**：
- 检查instance_charge_type配置
- 确认预付费参数是否正确

#### 错误六：标签格式错误

```
Error: [TerraformError] Code=ValidationError
Message=Invalid tag format
```

**原因**：标签格式不符合要求
**解决方案**：
- 检查标签键值对格式
- 确保键值不为空