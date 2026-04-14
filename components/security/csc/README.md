# 腾讯云云安全中心（CSC）模块

## 模块概述

本模块用于在腾讯云中部署和管理云安全中心（Cloud Security Center，CSC）服务，提供全面的云上安全防护能力，主要功能包括：

- **安全防护** - 提供多版本安全防护能力
- **计费管理** - 支持包年包月计费模式
- **自动续费** - 支持自动续费功能配置
- **多版本选择** - 支持基础版、高级版、企业版、旗舰版
- **扩展功能** - 支持日志分析、组织账户管理、资产扫描
- **标签管理** - 支持资源标签分类
- **资源输出** - 输出CSC实例ID便于后续管理

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
| `QcloudTagFullAccess` | 标签管理权限 |
| `QcloudCSCFullAccess` | 云安全中心全权限 |

### 其他要求

- 需要确定部署地域和可用区
- 需要选择合适的安全中心版本
- 需要确定计费周期和续费策略
- 需要规划扩展功能需求
- 需要准备标签分类方案
- 需要确认项目ID（如适用）

---

## 变量说明

### 必需配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `region` | `string` | 是 | - | 部署地域 |
| `zone` | `string` | 是 | - | 可用区 |
| `pay_mode` | `string` | 否 | `PrePay` | 付费模式（仅支持PrePay） |

### 产品参数配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `parameter` | `object` | 是 | - | 产品详细参数对象 |

### 参数对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `sv_soccloud_pc_ae` | `bool` | 否 | `false` | 高级版 |
| `sv_soccloud_pc_ee` | `bool` | 否 | `false` | 企业版 |
| `sv_soccloud_pc_fe` | `bool` | 否 | `false` | 旗舰版/终极版 |
| `sv_soccloud_pc_la` | `bool` | 否 | `false` | 日志分析功能 |
| `sv_soccloud_pc_ma` | `bool` | 否 | `false` | 组织账户限制版 |
| `sv_soccloud_pc_mas` | `bool` | 否 | `false` | 组织账户无限制版 |
| `sv_soccloud_pc_ss` | `bool` | 否 | `false` | 资产扫描功能 |
| `autoRenewFlag` | `number` | 否 | `0` | 自动续费标识 |
| `goodsNum` | `number` | 否 | `1` | 商品数量 |
| `tag` | `list(string)` | 否 | `[]` | 标签列表 |

### 可选配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `project_id` | `number` | 否 | `0` | 项目ID |
| `period` | `number` | 否 | `1` | 购买时长（最大36） |
| `period_unit` | `string` | 否 | `m` | 购买时间单位（m:月, y:年） |
| `renew_flag` | `string` | 否 | `NOTIFY_AND_MANUAL_RENEW` | 续费标志 |
| `create_timeout` | `string` | 否 | `20m` | 创建超时时间 |

### 续费标志选项

| 值 | 说明 |
|----|------|
| `NOTIFY_AND_MANUAL_RENEW` | 通知并手动续费 |
| `NOTIFY_AND_AUTO_RENEW` | 通知并自动续费 |
| `DISABLE_NOTIFY_AND_MANUAL_RENEW` | 禁用通知和手动续费 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 基础配置
region   = "ap-guangzhou"
zone     = "ap-guangzhou-1"
pay_mode = "PrePay"

# 计费配置
period      = 12
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 产品参数配置
parameter = {
  sv_soccloud_pc_ae  = true   # 启用高级版
  sv_soccloud_pc_la  = true   # 启用日志分析
  sv_soccloud_pc_ss  = true   # 启用资产扫描
  autoRenewFlag      = 1      # 启用自动续费
  goodsNum           = 1      # 商品数量
  tag                = ["security", "production"]
}

# 可选配置
project_id     = 123456
create_timeout = "30m"
```

### 企业版配置示例

```hcl
# 基础配置
region   = "ap-shanghai"
zone     = "ap-shanghai-2"
pay_mode = "PrePay"

# 企业版配置
parameter = {
  sv_soccloud_pc_ee  = true   # 启用企业版
  sv_soccloud_pc_la  = true   # 启用日志分析
  sv_soccloud_pc_ss  = true   # 启用资产扫描
  autoRenewFlag      = 1      # 启用自动续费
  goodsNum           = 2      # 2个实例
  tag                = ["enterprise", "security"]
}

# 长期订阅
period      = 36
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"
```

### 旗舰版配置示例

```hcl
# 基础配置
region   = "ap-beijing"
zone     = "ap-beijing-3"
pay_mode = "PrePay"

# 旗舰版全功能配置
parameter = {
  sv_soccloud_pc_fe  = true   # 启用旗舰版
  sv_soccloud_pc_la  = true   # 启用日志分析
  sv_soccloud_pc_ss  = true   # 启用资产扫描
  autoRenewFlag      = 1      # 启用自动续费
  goodsNum           = 1      # 商品数量
  tag                = ["ultimate", "security"]
}

# 年度订阅
period      = 2
period_unit = "y"
renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
```

### 组织账户管理配置示例

```hcl
# 基础配置
region   = "ap-guangzhou"
zone     = "ap-guangzhou-1"
pay_mode = "PrePay"

# 组织账户无限制版
parameter = {
  sv_soccloud_pc_mas = true   # 启用组织账户无限制版
  sv_soccloud_pc_la  = true   # 启用日志分析
  autoRenewFlag      = 0      # 禁用自动续费
  goodsNum           = 1      # 商品数量
  tag                = ["organization", "unlimited"]
}

# 月度订阅
period      = 1
period_unit = "m"
renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
```

### 最小化配置示例

```hcl
# 最小化基础配置
region = "ap-shanghai"
zone   = "ap-shanghai-1"

# 仅使用默认参数
parameter = {
  goodsNum = 1
}

# 使用所有默认值：1个月、手动续费、20分钟超时
```

---

## 使用示例

### 示例一：生产环境高级版配置

```hcl
# 生产环境配置
region   = "ap-guangzhou"
zone     = "ap-guangzhou-3"
pay_mode = "PrePay"

# 生产环境参数
parameter = {
  sv_soccloud_pc_ae  = true   # 高级版
  sv_soccloud_pc_la  = true   # 日志分析
  sv_soccloud_pc_ss  = true   # 资产扫描
  autoRenewFlag      = 1      # 自动续费
  goodsNum           = 1      # 单实例
  tag                = ["production", "high-availability"]
}

# 长期订阅确保稳定性
period      = 24
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 项目关联
project_id = 10086
```

### 示例二：多实例企业部署

```hcl
# 企业多实例配置
region   = "ap-beijing"
zone     = "ap-beijing-2"
pay_mode = "PrePay"

# 企业级部署
parameter = {
  sv_soccloud_pc_ee  = true   # 企业版
  sv_soccloud_pc_la  = true   # 日志分析
  sv_soccloud_pc_ss  = true   # 资产扫描
  autoRenewFlag      = 1      # 自动续费
  goodsNum           = 3      # 3个实例
  tag                = ["enterprise", "multi-instance"]
}

# 年度订阅
period      = 3
period_unit = "y"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 延长创建超时时间
create_timeout = "45m"
```

### 示例三：开发测试环境

```hcl
# 开发环境配置
region = "ap-shanghai"
zone   = "ap-shanghai-4"

# 基础功能配置
parameter = {
  sv_soccloud_pc_ae  = true   # 高级版
  sv_soccloud_pc_ss  = true   # 资产扫描
  autoRenewFlag      = 0      # 手动续费
  goodsNum           = 1      # 单实例
  tag                = ["development", "test"]
}

# 短期订阅便于测试
period      = 1
period_unit = "m"
renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
```

### 示例四：合规性要求配置

```hcl
# 合规性配置
region   = "ap-guangzhou"
zone     = "ap-guangzhou-1"
pay_mode = "PrePay"

# 全功能合规配置
parameter = {
  sv_soccloud_pc_fe  = true   # 旗舰版
  sv_soccloud_pc_la  = true   # 日志分析（合规要求）
  sv_soccloud_pc_ss  = true   # 资产扫描（合规要求）
  autoRenewFlag      = 1      # 确保服务连续性
  goodsNum           = 2      # 冗余部署
  tag                = ["compliance", "audit", "security"]
}

# 长期订阅满足合规周期
period      = 36
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 明确项目归属
project_id = 20010
```

---

## 配置说明

### 版本选择指南

#### 高级版（Advanced Edition）
- **适用场景**：中小型企业基础安全需求
- **功能**：基础安全防护、漏洞扫描
- **成本**：中等
- **推荐**：适合大多数业务场景

#### 企业版（Enterprise Edition）
- **适用场景**：中大型企业综合安全需求
- **功能**：增强安全防护、高级威胁检测
- **成本**：较高
- **推荐**：对安全要求较高的企业

#### 旗舰版（Flagship Edition）
- **适用场景**：大型企业、金融、政府等高安全要求
- **功能**：全面安全防护、高级别威胁情报
- **成本**：最高
- **推荐**：关键业务、合规要求严格的场景

#### 组织账户版本
- **限制版（MA）**：有限制的组织账户管理
- **无限制版（MAS）**：无限制的组织账户管理
- **适用场景**：多账户环境、集团企业

### 功能模块说明

#### 日志分析（Log Analytical）
- **功能**：安全日志收集、分析和审计
- **价值**：满足合规要求、安全事件调查
- **推荐**：生产环境建议启用

#### 资产扫描（Asset Scan）
- **功能**：自动化资产发现和漏洞扫描
- **价值**：资产清点、风险识别
- **推荐**：所有环境建议启用

### 计费策略说明

#### 包年包月模式（PrePay）
- **计费方式**：预付费
- **优势**：长期使用成本较低
- **适用**：稳定业务环境

#### 自动续费配置
- **自动续费（1）**：避免服务中断，确保连续性
- **手动续费（0）**：更灵活的成本控制
- **推荐**：生产环境建议自动续费

#### 订阅周期选择
- **月度（m）**：灵活性高，适合测试环境
- **年度（y）**：成本优势，适合生产环境
- **最大周期**：36个月

### 部署建议

#### 单实例部署
- **适用场景**：开发测试、中小业务
- **优势**：成本低，部署简单
- **风险**：单点故障

#### 多实例部署
- **适用场景**：生产环境、高可用要求
- **优势**：冗余备份，高可用性
- **成本**：较高

#### 地域选择建议

| 地域 | 编码 | 适用场景 | 延迟 |
|------|------|----------|------|
| **华南地区** | ap-guangzhou | 华南用户访问 | 低 |
| **华东地区** | ap-shanghai | 华东用户访问 | 低 |
| **华北地区** | ap-beijing | 华北用户访问 | 低 |
| **西南地区** | ap-chongqing | 西南用户访问 | 中 |

### 安全最佳实践

1. **版本选择**：根据业务需求选择合适的版本
2. **功能启用**：生产环境启用日志分析和资产扫描
3. **自动续费**：生产环境启用自动续费避免中断
4. **标签管理**：使用标签进行成本分摊和管理
5. **多实例部署**：生产环境考虑多实例高可用
6. **定期评估**：定期评估安全需求和配置

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **版本兼容性**
   - 确保选择的版本符合业务需求
   - 不同版本功能差异较大
   - 升级版本可能需要重新购买

2. **地域限制**
   - CSC服务有地域属性
   - 确认目标地域支持CSC服务
   - 跨地域功能可能受限

3. **权限验证**
   - 确认有足够的权限创建CSC实例
   - 检查账户额度限制
   - 验证财务权限

4. **计费确认**
   - 包年包月需要预付费用
   - 确认自动续费设置
   - 注意实例数量对费用的影响

5. **功能选择**
   - 仔细选择需要的功能模块
   - 不必要的功能会增加成本
   - 考虑未来的扩展需求

6. **标签管理**
   - 遵循统一的标签命名规范
   - 使用标签进行成本分摊
   - 利用标签进行资源管理

7. **测试验证**
   - 部署后测试CSC功能
   - 验证配置是否正确生效
   - 检查账单信息

8. **监控配置**
   - 配置CSC服务监控
   - 设置服务状态告警
   - 监控安全事件

9. **续费管理**
   - 关注续费时间和费用
   - 设置续费提醒
   - 定期评估续费策略

10. **合规性考虑**
    - 确保配置符合安全合规要求
    - 保留必要的审计日志
    - 遵循数据保护规范

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
- 检查CSC相关权限
- 申请QcloudCSCFullAccess权限
- 验证财务相关权限

#### 错误二：额度限制

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Resource limit exceeded
```

**原因**：达到资源数量或额度限制
**解决方案**：
- 检查当前CSC实例数量
- 申请提高资源额度
- 选择更低的配置

#### 错误三：地域不可用

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**原因**：选择的地域不支持CSC
**解决方案**：
- 检查地域可用性
- 选择支持的地域
- 联系腾讯云支持

#### 错误四：参数错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid parameter
```

**原因**：参数配置错误
**解决方案**：
- 检查parameter对象格式
- 验证参数值有效性
- 参考示例配置

#### 错误五：计费模式不支持

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Pay mode not supported
```

**原因**：使用了不支持的计费模式
**解决方案**：
- 确认使用PrePay模式
- 检查pay_mode参数

#### 错误六：超时错误

```
Error: timeout while waiting for state to become 'success'
```

**原因**：创建操作超时
**解决方案**：
- 增加create_timeout值
- 检查网络连接
- 联系腾讯云支持