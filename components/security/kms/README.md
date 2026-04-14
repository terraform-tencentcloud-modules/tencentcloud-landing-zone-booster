# 腾讯云密钥管理系统（KMS）模块

## 模块概述

本模块用于在腾讯云中部署和管理密钥管理系统（Key Management Service，KMS），提供安全可靠的密钥管理和数据加密服务，主要功能包括：

- **密钥管理** - 提供专业的密钥生命周期管理
- **数据加密** - 支持数据密钥的生成和管理
- **安全合规** - 符合金融级安全标准和合规要求
- **计费管理** - 支持包年包月计费模式
- **自动续费** - 支持自动续费功能配置
- **专业版本** - 提供专业版KMS服务
- **数据密钥配额** - 支持扩展数据密钥数量
- **资源输出** - 输出KMS实例ID便于后续管理

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
| `QcloudKMSFullAccess` | KMS全权限 |
| `QcloudTagFullAccess` | 标签管理权限 |

### 其他要求

- 需要确定部署地域和可用区
- 需要选择KMS专业版功能
- 需要确定数据密钥扩展数量
- 需要确定计费周期和续费策略
- 需要准备项目ID（如适用）
- 需要确认自动续费设置
- 需要规划实例数量

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
| `sv_kms_pg_pro` | `bool` | 否 | `true` | KMS专业版功能 |
| `sv_kms_exp_data_key` | `number` | 否 | `1000` | 扩展数据密钥数量 |
| `goodsNum` | `number` | 否 | `1` | 商品数量（实例数） |
| `autoRenewFlag` | `number` | 否 | `0` | 自动续费标识 |

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

### 自动续费标识说明

| 值 | 说明 |
|----|------|
| `0` | 不自动续费 |
| `1` | 自动续费 |

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
  sv_kms_pg_pro       = true    # 启用KMS专业版
  sv_kms_exp_data_key = 5000    # 5000个扩展数据密钥
  autoRenewFlag       = 1       # 启用自动续费
  goodsNum            = 1       # 1个实例
}

# 可选配置
project_id     = 123456
create_timeout = "30m"
```

### 生产环境配置示例

```hcl
# 生产环境配置
region   = "ap-shanghai"
zone     = "ap-shanghai-2"
pay_mode = "PrePay"

# 生产环境KMS配置
parameter = {
  sv_kms_pg_pro       = true    # 专业版KMS
  sv_kms_exp_data_key = 10000   # 10000个数据密钥配额
  autoRenewFlag       = 1       # 自动续费确保服务连续性
  goodsNum            = 2       # 2个实例冗余部署
}

# 长期订阅
period      = 36
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 项目关联
project_id = 10086
```

### 开发测试环境配置

```hcl
# 开发环境配置
region = "ap-beijing"
zone   = "ap-beijing-3"

# 开发环境KMS配置
parameter = {
  sv_kms_pg_pro       = true    # 启用专业版
  sv_kms_exp_data_key = 1000    # 默认1000个数据密钥
  autoRenewFlag       = 0       # 手动续费
  goodsNum            = 1       # 单实例
}

# 短期订阅
period      = 1
period_unit = "m"
renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
```

### 高可用配置示例

```hcl
# 高可用配置
region   = "ap-guangzhou"
zone     = "ap-guangzhou-1"
pay_mode = "PrePay"

# 高可用KMS配置
parameter = {
  sv_kms_pg_pro       = true    # 专业版
  sv_kms_exp_data_key = 20000   # 20000个数据密钥
  autoRenewFlag       = 1       # 自动续费
  goodsNum            = 3       # 3个实例高可用
}

# 年度订阅
period      = 2
period_unit = "y"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 延长创建超时时间
create_timeout = "45m"
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

# 使用所有默认值：专业版启用、1000数据密钥、手动续费、1个月、20分钟超时
```

---

## 使用示例

### 示例一：金融级安全配置

```hcl
# 金融级安全配置
region   = "ap-shanghai"
zone     = "ap-shanghai-2"
pay_mode = "PrePay"

# 金融级KMS配置
parameter = {
  sv_kms_pg_pro       = true    # 必须启用专业版
  sv_kms_exp_data_key = 50000   # 大量数据密钥支持
  autoRenewFlag       = 1       # 确保服务连续性
  goodsNum            = 2       # 冗余部署
}

# 长期稳定订阅
period      = 36
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 明确项目归属
project_id = 88888
```

### 示例二：多业务线共享配置

```hcl
# 多业务线共享配置
region   = "ap-beijing"
zone     = "ap-beijing-1"
pay_mode = "PrePay"

# 共享KMS配置
parameter = {
  sv_kms_pg_pro       = true    # 专业版
  sv_kms_exp_data_key = 30000   # 支持多业务线
  autoRenewFlag       = 1       # 自动续费
  goodsNum            = 1       # 集中管理
}

# 年度订阅便于预算管理
period      = 1
period_unit = "y"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 成本中心项目
project_id = 99999
```

### 示例三：合规性要求配置

```hcl
# 合规性配置
region   = "ap-guangzhou"
zone     = "ap-guangzhou-3"
pay_mode = "PrePay"

# 合规KMS配置
parameter = {
  sv_kms_pg_pro       = true    # 专业版满足合规
  sv_kms_exp_data_key = 15000   # 充足的数据密钥
  autoRenewFlag       = 1       # 确保服务不中断
  goodsNum            = 2       # 高可用部署
}

# 长期订阅满足审计要求
period      = 24
period_unit = "m"
renew_flag  = "NOTIFY_AND_AUTO_RENEW"

# 合规项目标识
project_id = 77777
```

### 示例四：成本优化配置

```hcl
# 成本优化配置
region = "ap-chongqing"
zone   = "ap-chongqing-1"

# 成本优化KMS配置
parameter = {
  sv_kms_pg_pro       = true    # 保持专业版
  sv_kms_exp_data_key = 1000    # 最小数据密钥数量
  autoRenewFlag       = 0       # 手动续费控制成本
  goodsNum            = 1       # 单实例
}

# 月度订阅灵活调整
period      = 1
period_unit = "m"
renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
```

---

## 配置说明

### 功能版本说明

#### KMS专业版（Professional Edition）
- **功能**：提供完整的密钥管理功能，包括密钥轮换、访问控制、审计日志等
- **适用场景**：生产环境、合规要求、金融级安全
- **默认值**：启用（true）
- **推荐**：所有环境都应启用专业版

#### 数据密钥扩展（Extended Data Keys）
- **功能**：增加可管理的数据密钥数量
- **默认值**：1000个
- **扩展范围**：可根据业务需求增加
- **成本影响**：数量越多费用越高
- **推荐**：根据实际加密需求配置

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

1. **专业版启用**：所有环境启用KMS专业版
2. **自动续费**：生产环境启用自动续费避免中断
3. **充足配额**：根据业务需求配置足够的数据密钥数量
4. **高可用部署**：生产环境考虑多实例部署
5. **定期审计**：定期检查KMS使用情况和安全配置
6. **访问控制**：严格管理KMS访问权限

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **版本兼容性**
   - KMS专业版是推荐配置
   - 确认功能版本符合业务需求
   - 不同版本功能差异可能影响加密方案

2. **地域限制**
   - KMS服务有地域属性
   - 确认目标地域支持KMS服务
   - 跨地域密钥管理需要特殊配置

3. **权限验证**
   - 确认有足够的权限创建KMS实例
   - 检查账户额度限制
   - 验证财务权限和KMS权限

4. **计费确认**
   - 包年包月需要预付费用
   - 数据密钥数量影响费用
   - 确认自动续费设置

5. **配额规划**
   - 合理规划数据密钥数量
   - 避免过度配置造成浪费
   - 考虑业务增长需求

6. **密钥管理**
   - 制定密钥管理策略
   - 定期轮换加密密钥
   - 备份重要密钥材料

7. **测试验证**
   - 部署后测试KMS功能
   - 验证加密解密操作
   - 检查权限控制

8. **监控配置**
   - 配置KMS服务监控
   - 设置使用量告警
   - 监控安全事件

9. **续费管理**
   - 关注续费时间和费用
   - 设置续费提醒
   - 定期评估续费策略

10. **合规性考虑**
    - 确保配置符合安全合规要求
    - 保留密钥操作审计日志
    - 遵循数据加密规范

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
- 检查KMS相关权限
- 申请QcloudKMSFullAccess权限
- 验证财务相关权限

#### 错误二：额度限制

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Resource limit exceeded
```

**原因**：达到资源数量或额度限制
**解决方案**：
- 检查当前KMS实例数量
- 申请提高资源额度
- 减少数据密钥数量配置

#### 错误三：地域不可用

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**原因**：选择的地域不支持KMS
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

#### 错误七：数据密钥数量超限

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Data key count exceeded
```

**原因**：数据密钥数量超过限制
**解决方案**：
- 减少sv_kms_exp_data_key值
- 联系腾讯云申请更高配额
- 检查当前配额使用情况