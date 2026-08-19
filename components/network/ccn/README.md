# 腾讯云CCN（云联网）实例管理模块

## 模块概述

本模块用于在腾讯云中创建和管理CCN（Cloud Connect Network，云联网）实例，实现跨地域、跨VPC的网络互联，主要功能包括：

- **CCN实例创建** - 创建云联网实例实现网络互联
- **带宽限制配置** - 支持跨地域带宽限制管理
- **计费模式选择** - 支持预付费和后付费两种计费模式
- **服务质量控制** - 支持不同级别的服务质量配置
- **标签管理** - 支持为CCN实例添加标签进行资源管理
- **带宽限制策略** - 支持区域间带宽限制配置

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
| `QcloudCCNFullAccess` | CCN管理全权限 |
| `QcloudTagFullAccess` | 标签管理全权限 |
| `QcloudVPCFullAccess` | VPC管理全权限 |

### 其他要求

- 需要规划好CCN的网络互联策略
- 需要了解跨地域带宽需求
- 需要确定计费模式和服务质量要求
- 需要规划好CCN实例名称和描述

---

## 变量说明

### CCN基础配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `ccn_name` | `string` | 是 | - | CCN实例名称（最大60字节） |
| `ccn_description` | `string` | 否 | - | CCN实例描述（最大100字节） |
| `ccn_bandwidth_limit_type` | `string` | 否 | `OUTER_REGION_LIMIT` | 带宽限制类型：`INTER_REGION_LIMIT`（区域间限制），`OUTER_REGION_LIMIT`（出区域限制） |
| `ccn_charge_type` | `string` | 否 | `POSTPAID` | 计费模式：`PREPAID`（预付费），`POSTPAID`（后付费） |
| `ccn_qos` | `string` | 否 | `AU` | 服务质量：`PT`（白金），`AU`（金），`AG`（银） |
| `ccn_tags` | `map(string)` | 否 | `{}` | CCN实例标签 |

### CCN带宽限制配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `ccn_set_bandwith_limit` | `bool` | 否 | `false` | 是否设置CCN带宽限制 |
| `ccn_bandwidth_limit` | `number` | 否 | `0` | 带宽限制值（Mbps） |
| `ccn_region` | `string` | 否 | `null` | 源区域限制 |
| `ccn_dst_region` | `string` | 否 | `null` | 目标区域限制（OUTER_REGION_LIMIT类型不需要设置） |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# CCN基础配置示例
ccn_name        = "production-ccn"
ccn_description = "生产环境云联网实例，连接北京和上海区域"

# CCN高级配置
ccn_bandwidth_limit_type = "INTER_REGION_LIMIT"
ccn_charge_type          = "POSTPAID"
ccn_qos                  = "AU"

# CCN标签配置
ccn_tags = {
  Environment = "production"
  NetworkType = "cross-region"
  ManagedBy   = "terraform"
}

# CCN带宽限制配置
ccn_set_bandwith_limit = true
ccn_bandwidth_limit    = 100
ccn_region             = "ap-beijing"
ccn_dst_region         = "ap-shanghai"
```

### 简单配置示例

```hcl
# 基础CCN配置
ccn_name        = "basic-ccn"
ccn_description = "基础云联网实例"

# 使用默认配置
ccn_bandwidth_limit_type = "OUTER_REGION_LIMIT"
ccn_charge_type          = "POSTPAID"
ccn_qos                  = "AU"

# 不设置带宽限制
ccn_set_bandwith_limit = false
```

### 多地域带宽限制配置

```hcl
# 多地域互联CCN配置
ccn_name        = "multi-region-ccn"
ccn_description = "连接北京、上海、广州的云联网"

# 区域间带宽限制
ccn_bandwidth_limit_type = "INTER_REGION_LIMIT"
ccn_charge_type          = "PREPAID"
ccn_qos                  = "PT"

# 设置带宽限制
ccn_set_bandwith_limit = true
ccn_bandwidth_limit    = 500

# 源区域和目标区域
ccn_region     = "ap-beijing"
ccn_dst_region = "ap-shanghai"

# 高级标签配置
ccn_tags = {
  Environment  = "production"
  BusinessUnit = "ecommerce"
  CostCenter   = "network-infra"
  SLA          = "99.9%"
}
```

---

## 使用示例

### 示例一：生产环境跨地域CCN

```hcl
# 生产环境北京-上海跨地域CCN
ccn_name        = "prod-bj-sh-ccn"
ccn_description = "生产环境北京到上海云联网，带宽100Mbps"

# 配置区域间带宽限制
ccn_bandwidth_limit_type = "INTER_REGION_LIMIT"
ccn_charge_type          = "POSTPAID"
ccn_qos                  = "AU"

# 启用带宽限制
ccn_set_bandwith_limit = true
ccn_bandwidth_limit    = 100
ccn_region             = "ap-beijing"
ccn_dst_region         = "ap-shanghai"

# 生产环境标签
ccn_tags = {
  Environment = "production"
  RegionPair  = "bj-sh"
  Bandwidth   = "100Mbps"
  ManagedBy   = "terraform"
}
```

### 示例二：开发环境基础CCN

```hcl
# 开发环境基础CCN配置
ccn_name        = "dev-basic-ccn"
ccn_description = "开发环境基础云联网实例"

# 使用默认出区域限制
ccn_bandwidth_limit_type = "OUTER_REGION_LIMIT"
ccn_charge_type          = "POSTPAID"
ccn_qos                  = "AG"

# 不设置带宽限制
ccn_set_bandwith_limit = false

# 开发环境标签
ccn_tags = {
  Environment = "development"
  Purpose     = "testing"
  CostCenter  = "dev-ops"
}
```

### 示例三：高可用多地域CCN

```hcl
# 高可用多地域CCN配置
ccn_name        = "ha-multi-region-ccn"
ccn_description = "高可用多地域云联网，连接北京、上海、广州"

# 白金级服务质量
ccn_bandwidth_limit_type = "INTER_REGION_LIMIT"
ccn_charge_type          = "PREPAID"
ccn_qos                  = "PT"

# 设置高带宽限制
ccn_set_bandwith_limit = true
ccn_bandwidth_limit    = 1000

# 主要区域间带宽限制
ccn_region     = "ap-beijing"
ccn_dst_region = "ap-shanghai"

# 高可用标签
ccn_tags = {
  Environment    = "production"
  HA             = "multi-region"
  Bandwidth      = "1Gbps"
  ServiceLevel   = "platinum"
  DisasterRecovery = "enabled"
}
```

---

## 配置说明

### 带宽限制类型说明

| 限制类型 | 说明 | 适用场景 |
|----------|------|----------|
| **INTER_REGION_LIMIT** | 区域间带宽限制 | 控制两个特定区域间的带宽 |
| **OUTER_REGION_LIMIT** | 出区域带宽限制 | 控制从某个区域到所有其他区域的带宽 |

### 计费模式说明

| 计费模式 | 说明 | 适用场景 |
|----------|------|----------|
| **PREPAID** | 预付费 | 长期稳定使用，成本可预测 |
| **POSTPAID** | 后付费 | 弹性使用，按实际用量计费 |

### 服务质量等级说明

| 服务质量 | 说明 | 网络性能 |
|----------|------|----------|
| **PT** | 白金级 | 最高性能，最低延迟 |
| **AU** | 金级 | 高性能，平衡成本 |
| **AG** | 银级 | 标准性能，成本优化 |

### 输出说明

模块输出CCN实例ID：
```hcl
ccn_id = "ccn-xxxxxx"
```

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **权限配置**
   - 确保执行账号具有CCN管理相关权限
   - 需要`QcloudCCNFullAccess`权限

2. **名称长度限制**
   - CCN名称最大60字节
   - CCN描述最大100字节
   - 避免使用过长的名称和描述

3. **带宽限制配置**
   - 带宽限制值单位为Mbps
   - 合理规划带宽需求，避免过度配置
   - 区域选择使用标准地域代码（如ap-beijing）

4. **计费模式选择**
   - 预付费模式需要提前支付费用
   - 后付费模式按实际使用量计费
   - 根据业务需求选择合适的计费模式

5. **服务质量选择**
   - 白金级提供最佳性能但成本最高
   - 金级平衡性能和成本
   - 银级成本最优但性能相对较低

6. **区域配置约束**
   - `OUTER_REGION_LIMIT`类型不需要设置`ccn_dst_region`
   - `INTER_REGION_LIMIT`类型需要同时设置源和目标区域
   - 确保地域代码正确无误

7. **带宽限制启用**
   - 只有`ccn_set_bandwith_limit=true`时带宽限制才生效
   - 带宽限制值为0表示无限制
   - 合理设置带宽避免网络瓶颈

8. **标签管理**
   - 建议添加环境、业务单元等标签
   - 便于资源分类和成本分摊
   - 使用一致的标签命名规范

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少CCN管理权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含`QcloudCCNFullAccess`权限

#### 错误二：名称长度超限

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Name length exceeds limit
```

**原因**：CCN名称或描述超过长度限制
**解决方案**：
- CCN名称不超过60字节
- CCN描述不超过100字节
- 简化名称和描述内容

#### 错误三：地域代码错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid region code
```

**原因**：地域代码格式不正确
**解决方案**：
- 使用标准地域代码（如ap-beijing、ap-shanghai）
- 检查地域代码拼写是否正确
- 确认地域在腾讯云中可用

#### 错误四：带宽限制配置冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Bandwidth limit configuration conflict
```

**原因**：带宽限制配置不一致
**解决方案**：
- `OUTER_REGION_LIMIT`类型不要设置`ccn_dst_region`
- `INTER_REGION_LIMIT`类型需要设置源和目标区域
- 检查带宽限制类型和区域配置是否匹配

#### 错误五：计费模式不支持

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Unsupported charge type
```

**原因**：计费模式配置错误
**解决方案**：
- 只支持`PREPAID`和`POSTPAID`两种计费模式
- 检查计费模式拼写是否正确

#### 错误六：服务质量等级错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid QoS level
```

**原因**：服务质量等级配置错误
**解决方案**：
- 只支持`PT`、`AU`、`AG`三种服务质量等级
- 检查服务质量等级拼写是否正确