# 腾讯云CCN-VPC关联管理模块

## 模块概述

本模块用于在腾讯云中创建VPC（Virtual Private Cloud）并将其关联到CCN（Cloud Connect Network，云联网），实现VPC与云联网的互联互通，主要功能包括：

- **VPC创建与管理** - 创建新的VPC网络或使用现有VPC
- **子网配置** - 支持多子网创建和配置
- **CCN关联** - 将VPC关联到指定的云联网实例
- **路由表关联** - 支持CCN路由表与VPC的关联配置
- **跨账号支持** - 支持关联其他账号的CCN实例
- **标签管理** - 支持为VPC和子网添加标签进行资源管理

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
| `QcloudTagFullAccess` | 标签管理全权限 |

### 其他要求

- 需要提前规划好VPC的CIDR地址块
- 需要了解CCN实例的ID或名称
- 需要确定VPC所在的区域
- 需要规划好子网的划分策略
- 需要了解网络互联的需求和拓扑

---

## 变量说明

### VPC基础配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `region` | `string` | 是 | - | VPC所在区域 |
| `name` | `string` | 否 | `my-vpc` | VPC名称 |
| `cidr` | `string` | 否 | `172.16.0.0/16` | VPC CIDR地址块 |
| `is_multicast` | `bool` | 否 | `true` | 是否启用组播 |
| `default_subnet_name` | `string` | 否 | `default_subnet` | 默认子网名称 |
| `availability_zones` | `list(string)` | 否 | `[]` | 可用区列表 |

### 子网配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `subnet_cidrs` | `list(object)` | 否 | - | 子网配置列表 |
| `↳ subnet_name` | `string` | 是 | - | 子网名称（最大60字节） |
| `↳ subnet_cidr` | `string` | 是 | - | 子网CIDR地址块 |
| `↳ subnet_is_multicast` | `bool` | 否 | `true` | 子网是否启用组播 |
| `↳ availability_zone` | `string` | 否 | - | 子网所在可用区 |
| `subnet_tags` | `map(string)` | 否 | `{}` | 子网标签 |

### 标签配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `common_tags` | `map(string)` | 否 | `{}` | 所有资源的通用标签 |
| `tags` | `map(string)` | 否 | `{}` | VPC额外标签 |

### CCN关联配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `ccn_id` | `string` | 否 | `null` | CCN实例ID |
| `ccn_name` | `string` | 否 | `null` | CCN实例名称 |
| `attachment_desc` | `string` | 否 | `null` | CCN关联描述（最大100字节） |
| `ccn_uin` | `string` | 否 | `null` | CCN所属账号UIN（跨账号关联时使用） |

### CCN路由表关联配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `route_table_id` | `string` | 否 | `null` | CCN路由表ID |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# VPC基础配置
region = "ap-beijing"
name   = "production-vpc"
cidr   = "10.0.0.0/16"

# 子网配置
subnet_cidrs = [
  {
    subnet_name         = "web-subnet"
    subnet_cidr         = "10.0.1.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-3"
  },
  {
    subnet_name         = "app-subnet"
    subnet_cidr         = "10.0.2.0/24"
    subnet_is_multicast = true
    availability_zone   = "ap-beijing-4"
  },
  {
    subnet_name         = "db-subnet"
    subnet_cidr         = "10.0.3.0/24"
    subnet_is_multicast = false
    availability_zone   = "ap-beijing-5"
  }
]

# 标签配置
common_tags = {
  Environment = "production"
  Project     = "ecommerce"
  ManagedBy   = "terraform"
}

tags = {
  NetworkTier = "core"
  SLA         = "99.9%"
}

# CCN关联配置
ccn_name        = "production-ccn"
attachment_desc = "生产环境VPC关联到CCN"
ccn_uin         = null

# CCN路由表关联
route_table_id = "ccn-rtb-xxxxxx"
```

### 简单配置示例

```hcl
# 基础VPC配置
region = "ap-shanghai"
name   = "development-vpc"
cidr   = "192.168.0.0/16"

# 默认子网配置
subnet_cidrs = [
  {
    subnet_name = "default-subnet"
    subnet_cidr = "192.168.1.0/24"
  }
]

# CCN关联（使用CCN ID）
ccn_id        = "ccn-abcdef"
attachment_desc = "开发环境VPC关联"
```

### 跨账号关联配置示例

```hcl
# VPC配置
region = "ap-guangzhou"
name   = "shared-services-vpc"
cidr   = "172.16.0.0/16"

# 多可用区子网配置
subnet_cidrs = [
  {
    subnet_name       = "shared-subnet-1"
    subnet_cidr       = "172.16.1.0/24"
    availability_zone = "ap-guangzhou-2"
  },
  {
    subnet_name       = "shared-subnet-2"
    subnet_cidr       = "172.16.2.0/24"
    availability_zone = "ap-guangzhou-3"
  }
]

# 跨账号CCN关联
ccn_id        = "ccn-123456"
ccn_uin       = "123456789"  # 其他账号的UIN
attachment_desc = "跨账号共享服务VPC关联"

# 路由表关联
route_table_id = "ccn-rtb-yyyyyy"

# 标签配置
common_tags = {
  Environment   = "shared"
  BusinessUnit  = "infrastructure"
  CostCenter    = "shared-services"
}
```

---

## 使用示例

### 示例一：生产环境多子网VPC关联CCN

```hcl
# 生产环境北京区域VPC
region = "ap-beijing"
name   = "prod-ecommerce-vpc"
cidr   = "10.100.0.0/16"

# 多可用区子网配置
availability_zones = ["ap-beijing-3", "ap-beijing-4", "ap-beijing-5"]

subnet_cidrs = [
  # Web层子网
  {
    subnet_name         = "prod-web-subnet"
    subnet_cidr         = "10.100.1.0/24"
    availability_zone   = "ap-beijing-3"
    subnet_is_multicast = true
  },
  # App层子网
  {
    subnet_name         = "prod-app-subnet"
    subnet_cidr         = "10.100.2.0/24"
    availability_zone   = "ap-beijing-4"
    subnet_is_multicast = true
  },
  # DB层子网
  {
    subnet_name         = "prod-db-subnet"
    subnet_cidr         = "10.100.3.0/24"
    availability_zone   = "ap-beijing-5"
    subnet_is_multicast = false  # 数据库层禁用组播
  },
  # 管理子网
  {
    subnet_name         = "prod-mgmt-subnet"
    subnet_cidr         = "10.100.254.0/24"
    availability_zone   = "ap-beijing-3"
    subnet_is_multicast = true
  }
]

# 子网标签
subnet_tags = {
  ManagedBy = "terraform"
}

# CCN关联
ccn_name        = "prod-cross-region-ccn"
attachment_desc = "生产环境电商VPC关联到跨地域CCN"

# 路由表关联
route_table_id = "ccn-rtb-prod-main"

# 生产环境标签
common_tags = {
  Environment = "production"
  Project     = "ecommerce"
  Tier        = "core"
  Owner       = "platform-team"
}

tags = {
  DataClassification = "restricted"
  Compliance         = "pci-dss"
}
```

### 示例二：开发环境简单VPC关联

```hcl
# 开发环境简单配置
region = "ap-shanghai"
name   = "dev-test-vpc"
cidr   = "192.168.100.0/24"

# 单子网配置
subnet_cidrs = [
  {
    subnet_name = "dev-default-subnet"
    subnet_cidr = "192.168.100.0/24"
  }
]

# CCN关联（使用CCN ID）
ccn_id        = "ccn-dev-test"
attachment_desc = "开发测试VPC关联"

# 开发环境标签
common_tags = {
  Environment = "development"
  Purpose     = "testing"
  CostCenter  = "rd"
}
```

### 示例三：共享服务VPC跨账号关联

```hcl
# 共享服务VPC配置
region = "ap-guangzhou"
name   = "shared-infra-vpc"
cidr   = "172.20.0.0/16"

# 多可用区子网
subnet_cidrs = [
  {
    subnet_name       = "shared-networking-1"
    subnet_cidr       = "172.20.1.0/24"
    availability_zone = "ap-guangzhou-2"
  },
  {
    subnet_name       = "shared-networking-2"
    subnet_cidr       = "172.20.2.0/24"
    availability_zone = "ap-guangzhou-3"
  }
]

# 跨账号CCN关联
ccn_id        = "ccn-shared-services"
ccn_uin       = "987654321"  # 其他账号UIN
attachment_desc = "共享基础设施VPC跨账号关联"

# 路由表关联
route_table_id = "ccn-rtb-shared"

# 共享服务标签
common_tags = {
  Environment   = "shared"
  BusinessUnit  = "infrastructure"
  ServiceType   = "networking"
  CostModel     = "chargeback"
}
```

---

## 配置说明

### CCN关联优先级

CCN关联支持两种方式指定CCN实例：
- **CCN ID优先** - 如果同时提供`ccn_id`和`ccn_name`，优先使用`ccn_id`
- **名称查找** - 如果只提供`ccn_name`，会自动查找对应的CCN实例ID

### 跨账号关联说明

支持关联其他腾讯云账号的CCN实例：
- 需要提供目标账号的UIN（`ccn_uin`参数）
- 当前账号需要具有关联权限
- 目标账号的CCN需要允许跨账号关联

### 路由表关联说明

- 可选功能，通过`route_table_id`参数启用
- 用于将VPC关联到特定的CCN路由表
- 如果不设置，使用CCN默认路由表

### 输出说明

模块输出VPC ID：
```hcl
vpc_id = "vpc-xxxxxx"
```

### 依赖关系

模块内部依赖关系：
1. 先创建VPC和子网
2. 然后进行CCN关联
3. 最后进行路由表关联（如果配置）

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **权限配置**
   - 确保执行账号具有VPC和CCN管理权限
   - 需要`QcloudVPCFullAccess`和`QcloudCCNFullAccess`权限
   - 跨账号关联需要额外权限

2. **区域一致性**
   - VPC区域和CCN区域需要匹配
   - 确保区域代码正确（如ap-beijing）
   - 跨地域关联需要通过CCN实现

3. **CIDR规划**
   - 合理规划VPC和子网的CIDR地址块
   - 避免CIDR冲突
   - 预留足够的IP地址空间

4. **CCN标识**
   - CCN ID和CCN名称至少提供一个
   - CCN ID优先于CCN名称
   - 确保CCN实例存在且状态正常

5. **跨账号关联**
   - 需要目标账号的UIN
   - 需要目标账号授权关联权限
   - 确认网络连通性需求

6. **路由表关联**
   - 路由表ID可选配置
   - 确保路由表存在且可用
   - 了解路由策略影响

7. **名称长度限制**
   - VPC名称无特殊长度限制
   - 子网名称最大60字节
   - CCN关联描述最大100字节

8. **组播配置**
   - 默认启用VPC和子网组播
   - 可根据安全需求禁用组播
   - 数据库等敏感子网建议禁用组播

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少VPC或CCN管理权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含`QcloudVPCFullAccess`和`QcloudCCNFullAccess`权限

#### 错误二：CCN不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=CCN not found
```

**原因**：指定的CCN ID或名称不存在
**解决方案**：
- 确认CCN ID或名称正确
- 检查CCN是否已被删除
- 确认CCN处于可用状态

#### 错误三：区域不匹配

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region mismatch
```

**原因**：VPC区域和操作区域不匹配
**解决方案**：
- 确认VPC所在区域正确
- 检查region参数配置
- 确保区域代码格式正确

#### 错误四：CIDR冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=CIDR conflict
```

**原因**：CIDR地址块冲突或格式错误
**解决方案**：
- 检查CIDR格式是否正确
- 确认CIDR地址块不冲突
- 使用标准的CIDR表示法

#### 错误五：跨账号权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=Cross account operation not allowed
```

**原因**：跨账号操作权限不足
**解决方案**：
- 确认目标账号已授权
- 检查ccn_uin参数是否正确
- 确认当前账号有关联权限

#### 错误六：路由表不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Route table not found
```

**原因**：指定的路由表不存在
**解决方案**：
- 确认路由表ID正确
- 检查路由表是否属于指定的CCN
- 确认路由表处于可用状态