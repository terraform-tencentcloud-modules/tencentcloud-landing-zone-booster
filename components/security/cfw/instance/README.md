# 腾讯云云防火墙（CFW）实例模块

## 模块概述

本模块用于在腾讯云中部署和管理云防火墙（Cloud Firewall，CFW）实例，提供全面的网络安全防护能力，主要功能包括：

- **实例创建** - 创建和管理云防火墙实例
- **版本选择** - 支持基础版、企业版、旗舰版三种版本
- **计费管理** - 支持预付费模式，灵活配置购买时长
- **带宽配置** - 配置南北向和VPC防火墙带宽
- **日志服务** - 配置日志分析和日志存储功能
- **扩展功能** - 支持全流量检测、网络蜜罐、地址模板等高级功能
- **自动续费** - 支持自动续费配置
- **多地域部署** - 支持在不同地域和可用区部署

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
| `QcloudFinanceFullAccess` | 财务管理权限 |
| `QcloudBillingReadOnlyAccess` | 账单只读权限 |
| `QcloudCFWFullAccess` | 云防火墙全权限 |
| `QcloudCFWReadOnlyAccess` | 云防火墙只读权限 |
| `QcloudVPCFullAccess` | VPC网络权限 |

### 其他要求

- 需要确定云防火墙版本（基础版、企业版、旗舰版）
- 需要规划带宽需求和日志存储需求
- 需要确定购买时长和续费策略
- 需要选择部署地域和可用区
- 需要配置扩展功能（如需要）
- 需要准备项目ID（如需要）

---

## 变量说明

### 必需配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `region` | `string` | 是 | - | 部署地域，如：ap-beijing |
| `zone` | `string` | 是 | - | 可用区，如：ap-beijing-1 |
| `pay_mode` | `string` | 否 | `PrePay` | 付费模式，仅支持预付费（PrePay） |

### 计费配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `period` | `number` | 否 | `1` | 购买时长，最大36，默认1 |
| `period_unit` | `string` | 否 | `m` | 时长单位：m(月), y(年) |
| `renew_flag` | `string` | 否 | `NOTIFY_AND_MANUAL_RENEW` | 续费标志：NOTIFY_AND_MANUAL_RENEW(手动续费), NOTIFY_AND_AUTO_RENEW(自动续费), DISABLE_NOTIFY_AND_MANUAL_RENEW(禁用续费) |

### 产品参数配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `parameter` | `object` | 是 | - | 产品详细参数配置对象 |

### 参数对象字段说明

#### 通用配置
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `goodsNum` | `number` | 否 | `1` | 商品数量 |

#### 版本选择
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `sv_cloudfirewall_basic_aeps` | `bool` | 否 | `false` | 高级版（Advanced Edition） |
| `sv_cloudfirewall_basic_eeps` | `bool` | 否 | `false` | 企业版（Enterprise Edition） |
| `sv_cloudfirewall_basic_ueps` | `bool` | 否 | `false` | 旗舰版（Ultimate Edition） |

#### 日志服务
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `sv_cloudfirewall_extended_clasps` | `bool` | 否 | `false` | 日志分析功能 |
| `sv_cloudfirewall_extended_clsesps` | `number` | 否 | `0` | 日志存储容量（单位：GB，步长1000） |

#### 带宽配置
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `sv_cloudfirewall_extended_ibtesps` | `number` | 否 | `0` | 南北向保护带宽（单位：Mbps，步长1） |
| `sv_cloudfirewall_extended_vpcbges` | `number` | 否 | `0` | VPC防火墙带宽（单位：Gbps，步长1） |
| `sv_cloudfirewall_extended_vpc` | `number` | 否 | `0` | VPC防火墙带宽（单位：Mbps，步长1） |
| `sv_cloudfirewall_extended_ndr` | `number` | 否 | `0` | 全流量检测和响应NDR带宽（单位：Gbps，步长1） |

#### 扩展功能
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `sv_cloudfirewall_extended_pcs` | `number` | 否 | `0` | 网络蜜罐（步长1） |
| `sv_cloudfirewall_extended_sub` | `number` | 否 | `0` | 通用实例（步长1） |
| `sv_cloudfirewall_extended_subs` | `number` | 否 | `0` | 通用规则（步长100） |
| `sv_cloudfirewall_extended_ates` | `number` | 否 | `0` | 地址模板（步长10） |
| `sv_cloudfirewall_extended_spt` | `bool` | 否 | `false` | 关键保护工具包 |

#### 其他配置
| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `sv_cloudfirewall_extended_ex` | `number` | 否 | `0` | 扩展功能（未知） |
| `sv_cloudfirewall_extended_nats` | `number` | 否 | `0` | NAT相关（未知） |
| `sv_cloudfirewall_extended_sra` | `number` | 否 | `0` | SRA相关（未知） |
| `sv_cloudfirewall_extended_srb` | `number` | 否 | `0` | SRB相关（未知） |

### 可选配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `project_id` | `number` | 否 | `0` | 项目ID |
| `create_timeout` | `string` | 否 | `20m` | 创建超时时间 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 基础配置
region     = "ap-beijing"
zone       = "ap-beijing-1"
pay_mode   = "PrePay"

# 计费配置
period      = 12
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 产品参数配置
parameter = {
  # 版本选择 - 选择企业版
  sv_cloudfirewall_basic_eeps = true
  
  # 日志服务
  sv_cloudfirewall_extended_clasps  = true  # 启用日志分析
  sv_cloudfirewall_extended_clsesps = 1000  # 1TB日志存储
  
  # 带宽配置
  sv_cloudfirewall_extended_ibtesps = 100   # 100Mbps南北向带宽
  sv_cloudfirewall_extended_vpcbges = 1     # 1Gbps VPC防火墙带宽
  
  # 扩展功能
  sv_cloudfirewall_extended_pcs = 2         # 2个网络蜜罐
  sv_cloudfirewall_extended_ates = 10       # 10个地址模板
  sv_cloudfirewall_extended_spt  = true     # 启用关键保护工具包
}

# 可选配置
project_id = 123456
```

### 生产环境配置示例

```hcl
# 生产环境配置
region     = "ap-shanghai"
zone       = "ap-shanghai-2"

# 长期订阅
period      = 36
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 生产级参数
parameter = {
  # 选择旗舰版
  sv_cloudfirewall_basic_ueps = true
  
  # 完整的日志服务
  sv_cloudfirewall_extended_clasps  = true
  sv_cloudfirewall_extended_clsesps = 5000  # 5TB日志存储
  
  # 高带宽配置
  sv_cloudfirewall_extended_ibtesps = 1000  # 1Gbps南北向带宽
  sv_cloudfirewall_extended_vpcbges = 5     # 5Gbps VPC防火墙带宽
  sv_cloudfirewall_extended_ndr     = 2     # 2Gbps全流量检测
  
  # 高级安全功能
  sv_cloudfirewall_extended_pcs  = 5        # 5个网络蜜罐
  sv_cloudfirewall_extended_subs = 500      # 500条通用规则
  sv_cloudfirewall_extended_ates = 50       # 50个地址模板
  sv_cloudfirewall_extended_spt  = true     # 关键保护工具包
}

project_id = 789012
```

### 测试环境配置示例

```hcl
# 测试环境配置
region = "ap-guangzhou"
zone   = "ap-guangzhou-1"

# 短期订阅
period      = 1
period_unit = "m"

# 基础参数
parameter = {
  # 选择基础版
  sv_cloudfirewall_basic_aeps = true
  
  # 基础日志服务
  sv_cloudfirewall_extended_clsesps = 100  # 100GB日志存储
  
  # 基础带宽
  sv_cloudfirewall_extended_ibtesps = 10   # 10Mbps南北向带宽
  sv_cloudfirewall_extended_vpc     = 100  # 100Mbps VPC防火墙带宽
}
```

### 最小化配置示例

```hcl
# 最小化配置
region = "ap-beijing"
zone   = "ap-beijing-3"

parameter = {
  # 仅选择基础版
  sv_cloudfirewall_basic_aeps = true
  
  # 最小带宽配置
  sv_cloudfirewall_extended_ibtesps = 1  # 1Mbps南北向带宽
}
```

---

## 使用示例

### 示例一：企业级云防火墙部署

```hcl
# 企业级CFW配置
region     = "ap-shanghai"
zone       = "ap-shanghai-2"
period     = 24  # 2年
period_unit = "m"

parameter = {
  # 企业版
  sv_cloudfirewall_basic_eeps = true
  
  # 企业级日志
  sv_cloudfirewall_extended_clasps  = true  # 日志分析
  sv_cloudfirewall_extended_clsesps = 2000  # 2TB存储
  
  # 企业带宽
  sv_cloudfirewall_extended_ibtesps = 500   # 500Mbps南北向
  sv_cloudfirewall_extended_vpcbges = 2     # 2Gbps VPC防火墙
  
  # 企业安全功能
  sv_cloudfirewall_extended_pcs  = 3        # 3个蜜罐
  sv_cloudfirewall_extended_ates = 20       # 20个地址模板
  sv_cloudfirewall_extended_spt  = true     # 关键保护
}

project_id = 100001
```

### 示例二：金融行业高安全配置

```hcl
# 金融行业CFW配置
region     = "ap-beijing"
zone       = "ap-beijing-1"
period     = 36  # 3年最长订阅

parameter = {
  # 旗舰版最高安全
  sv_cloudfirewall_basic_ueps = true
  
  # 完整的审计日志
  sv_cloudfirewall_extended_clasps  = true
  sv_cloudfirewall_extended_clsesps = 10000 # 10TB日志存储
  
  # 高带宽配置
  sv_cloudfirewall_extended_ibtesps = 2000  # 2Gbps南北向
  sv_cloudfirewall_extended_vpcbges = 10    # 10Gbps VPC防火墙
  sv_cloudfirewall_extended_ndr     = 5     # 5Gbps全流量检测
  
  # 高级威胁防护
  sv_cloudfirewall_extended_pcs  = 10       # 10个网络蜜罐
  sv_cloudfirewall_extended_subs = 1000     # 1000条规则
  sv_cloudfirewall_extended_ates = 100      # 100个地址模板
  sv_cloudfirewall_extended_spt  = true     # 关键保护工具包
}

project_id = 200002
```

### 示例三：多VPC网络防护

```hcl
# 多VPC环境CFW配置
region = "ap-guangzhou"
zone   = "ap-guangzhou-3"

parameter = {
  # 企业版支持多VPC
  sv_cloudfirewall_basic_eeps = true
  
  # VPC防火墙配置
  sv_cloudfirewall_extended_vpcbges = 3     # 3Gbps总带宽
  sv_cloudfirewall_extended_vpc     = 500   # 500Mbps per VPC
  
  # 集中日志管理
  sv_cloudfirewall_extended_clasps  = true
  sv_cloudfirewall_extended_clsesps = 3000  # 3TB存储
  
  # 统一安全策略
  sv_cloudfirewall_extended_subs = 300      # 300条统一规则
  sv_cloudfirewall_extended_ates = 30       # 30个共享地址模板
}

project_id = 300003
```

### 示例四：开发测试环境

```hcl
# 开发测试CFW配置
region = "ap-shanghai"
zone   = "ap-shanghai-4"

# 月度订阅便于调整
period      = 1
period_unit = "m"

parameter = {
  # 基础版足够
  sv_cloudfirewall_basic_aeps = true
  
  # 基础带宽
  sv_cloudfirewall_extended_ibtesps = 50    # 50Mbps
  sv_cloudfirewall_extended_vpc     = 50    # 50Mbps
  
  # 基础日志
  sv_cloudfirewall_extended_clsesps = 500   # 500GB存储
  
  # 测试功能
  sv_cloudfirewall_extended_pcs = 1         # 1个蜜罐测试
}
```

---

## 配置说明

### 版本功能对比

| 版本 | 编码 | 防护能力 | 适用场景 | 价格等级 |
|------|------|----------|----------|----------|
| **基础版** | sv_cloudfirewall_basic_aeps | 基础防护 | 小型业务、测试环境 | 低 |
| **企业版** | sv_cloudfirewall_basic_eeps | 增强防护+多VPC | 中型企业、生产环境 | 中 |
| **旗舰版** | sv_cloudfirewall_basic_ueps | 全面防护+高级功能 | 大型企业、金融级 | 高 |

### 带宽配置指南

#### 南北向带宽（sv_cloudfirewall_extended_ibtesps）
- **单位**：Mbps
- **步长**：1
- **建议**：根据互联网出口带宽的50-70%配置
- **示例**：100Mbps出口带宽 → 配置50-70Mbps

#### VPC防火墙带宽（sv_cloudfirewall_extended_vpcbges）
- **单位**：Gbps
- **步长**：1
- **建议**：根据VPC间流量峰值配置
- **示例**：多VPC环境 → 配置1-5Gbps

#### 全流量检测带宽（sv_cloudfirewall_extended_ndr）
- **单位**：Gbps
- **步长**：1
- **功能**：深度流量分析和威胁检测
- **适用**：高安全要求场景

### 日志存储配置

#### 日志分析（sv_cloudfirewall_extended_clasps）
- **功能**：启用智能日志分析和威胁检测
- **建议**：生产环境必选
- **成本**：额外费用

#### 日志存储（sv_cloudfirewall_extended_clsesps）
- **单位**：GB
- **步长**：1000（1TB起）
- **保留时间**：根据存储容量决定
- **建议**：按30天流量预估

### 高级功能说明

#### 网络蜜罐（sv_cloudfirewall_extended_pcs）
- **功能**：部署诱饵系统检测攻击者
- **适用**：高威胁环境
- **数量**：根据网络规模配置

#### 地址模板（sv_cloudfirewall_extended_ates）
- **功能**：自定义IP地址组用于策略
- **步长**：10
- **适用**：复杂网络策略管理

#### 关键保护工具包（sv_cloudfirewall_extended_spt）
- **功能**：增强的关键资产保护功能
- **包含**：高级威胁情报、零信任访问等
- **适用**：关键业务系统

### 计费模式说明

#### 预付费模式（PrePay）
- **优势**：折扣优惠，成本可控
- **时长**：1-36个月
- **续费**：支持自动续费
- **适用**：长期稳定业务

#### 续费策略
- **自动续费**：业务连续性要求高
- **手动续费**：需要灵活控制
- **禁用续费**：临时测试用途

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **版本选择**
   - 确认版本符合业务需求和合规要求
   - 旗舰版提供最全面的安全功能
   - 基础版适合测试和小型应用

2. **带宽规划**
   - 准确预估南北向和VPC间流量
   - 留出20-30%的带宽余量
   - 监控带宽使用情况及时调整

3. **日志存储**
   - 根据合规要求确定保留时间
   - 考虑日志分析需求
   - 监控存储使用情况

4. **地域选择**
   - 选择离业务最近的地域
   - 确认地域支持所需功能
   - 考虑跨地域流量成本

5. **权限验证**
   - 确认有足够的CFW操作权限
   - 检查财务相关权限
   - 验证VPC网络权限

6. **网络配置**
   - 确认VPC网络配置正确
   - 检查路由表配置
   - 验证网络连通性

7. **成本控制**
   - 合理配置带宽避免过度配置
   - 选择合适订阅时长
   - 监控实际资源使用

8. **功能兼容性**
   - 确认所选功能在版本中可用
   - 检查功能之间的依赖关系
   - 验证地域功能支持情况

9. **安全合规**
   - 确保配置符合安全标准
   - 保留足够的日志用于审计
   - 遵循行业合规要求

10. **变更管理**
    - 生产环境变更前充分测试
    - 制定回滚计划
    - 记录变更操作日志

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
- 验证财务权限

#### 错误二：地域不支持

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**原因**：选择的地域不支持CFW
**解决方案**：
- 检查地域可用性
- 选择支持的地域
- 联系腾讯云支持

#### 错误三：参数配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid parameter configuration
```

**原因**：参数配置格式或值错误
**解决方案**：
- 检查parameter对象格式
- 确认参数值符合要求
- 验证步长和单位

#### 错误四：版本冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Version conflict
```

**原因**：同时选择了多个版本
**解决方案**：
- 只选择一个版本（aeps/eeps/ueps）
- 检查参数配置

#### 错误五：资源配额不足

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Resource quota exceeded
```

**原因**：超过资源配额限制
**解决方案**：
- 检查当前资源使用情况
- 申请配额扩容
- 调整配置参数

#### 错误六：网络配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Network configuration error
```

**原因**：VPC或网络配置错误
**解决方案**：
- 检查VPC配置
- 验证网络连通性
- 检查安全组规则

#### 错误七：财务账户问题

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Payment account issue
```

**原因**：财务账户状态异常
**解决方案**：
- 检查账户余额
- 验证支付方式
- 联系财务支持