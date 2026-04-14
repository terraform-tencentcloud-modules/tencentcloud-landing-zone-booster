# 腾讯云云审计（CloudAudit）管理模块

## 模块概述

本模块用于在腾讯云中创建和管理云审计（CloudAudit）跟踪，支持以下核心功能：

- **审计跟踪创建** - 创建云审计跟踪，记录云资源操作日志
- **多存储类型** - 支持COS对象存储和CLS日志服务两种存储方式
- **组织级审计** - 支持组织内所有成员的审计跟踪
- **精细化过滤** - 支持按资源类型、操作类型、事件名称进行过滤
- **自动策略配置** - 自动为存储资源配置必要的访问策略
- **生命周期管理** - 支持存储资源的生命周期规则配置

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
| `QcloudCamFullAccess` | CAM权限管理全权限 |
| `QcloudAuditFullAccess` | 云审计全权限 |
| `QcloudCOSFullAccess` | COS对象存储全权限 |
| `QcloudCLSFullAccess` | CLS日志服务全权限 |

### 其他要求

- 当前账号需要具有云审计管理权限
- 需要提前创建好腾讯云组织（如使用组织级审计）
- 存储区域需要与审计跟踪区域一致

---

## 变量说明

### 必填变量

| 变量名 | 类型 | 说明 | 示例值 |
|--------|------|------|--------|
| `cloudaudit_storage_region` | `string` | 云审计存储区域 | `"ap-guangzhou"` |

### 可选变量

#### 通用配置

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `member_info` | `object` | `null` | 组织成员信息（uin或名称） |
| `↳ member_uin` | `number` | `null` | 组织成员uin |
| `↳ member_name` | `string` | `null` | 组织成员名称 |

#### 云审计跟踪配置

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `cloudaudit_track_name` | `string` | `"track_audit"` | 云审计跟踪名称 |
| `cloudaudit_track_for_all_members` | `number` | `1` | 是否为所有组织成员启用（0:否, 1:是） |
| `cloudaudit_track_status` | `number` | `1` | 跟踪状态（0:关闭, 1:开启） |
| `cloudaudit_storage_type` | `string` | `null` | 存储类型（cos/cls） |
| `cloudaudit_storage_name` | `string` | `"audit-log"` | 存储名称 |
| `cloudaudit_storage_prefix` | `string` | `"alog"` | 存储前缀 |
| `audit_filters` | `list(object)` | `[]` | 审计过滤规则 |
| `↳ resource_type` | `string` | - | 资源类型 |
| `↳ action_type` | `string` | - | 操作类型 |
| `↳ event_names` | `list(string)` | - | 事件名称列表 |

#### COS存储配置

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `cos_bucket_acl` | `string` | `"private"` | COS桶ACL（private/public-read/public-read-write） |
| `cos_multi_az` | `bool` | `false` | 是否启用多可用区 |
| `cos_force_clean` | `bool` | `true` | 是否强制清理 |
| `cos_versioning_enable` | `bool` | `true` | 是否启用版本控制 |
| `cos_lifecycle_rules` | `list(object)` | `[]` | 生命周期规则配置 |
| `↳ id` | `string` | - | 规则ID |
| `↳ filter_prefix` | `string` | - | 过滤前缀 |
| `↳ expiration` | `object` | - | 过期配置 |
| `↳ transition` | `list(object)` | - | 存储类型转换配置 |
| `↳ non_current_expiration` | `object` | - | 非当前版本过期配置 |
| `↳ non_current_transition` | `list(object)` | - | 非当前版本转换配置 |
| `↳ abort_incomplete_multipart_upload` | `object` | - | 分块上传中止配置 |

#### CLS存储配置

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `cls_logset_name` | `string` | - | CLS日志集名称 |
| `cls_logset_tags` | `map(string)` | `{}` | 日志集标签 |
| `cls_topic_name` | `string` | - | 日志主题名称 |
| `cls_auto_split` | `bool` | `true` | 是否启用自动分裂 |
| `cls_max_split_partitions` | `number` | `50` | 最大分裂分区数 |
| `cls_partition_count` | `number` | `1` | 分区数量（1-10） |
| `cls_period` | `number` | `30` | 生命周期天数（1-366） |
| `cls_storage_type` | `string` | `"hot"` | 存储类型（hot/cold） |
| `cls_describes` | `string` | `null` | 日志主题描述 |
| `cls_hot_period` | `number` | `null` | 热存储天数（0:关闭） |
| `cls_topic_tags` | `map(string)` | `null` | 日志主题标签 |
| `cls_create_index` | `bool` | `false` | 是否创建索引 |
| `cls_rules` | `set(object)` | `[]` | 索引规则配置 |
| `↳ full_text` | `list(object)` | - | 全文索引配置 |
| `↳ key_value` | `list(object)` | - | 键值索引配置 |
| `↳ tag` | `list(object)` | - | 标签索引配置 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 必填配置
cloudaudit_storage_region = "ap-guangzhou"

# 云审计跟踪配置
cloudaudit_track_name            = "prod-audit-track"
cloudaudit_track_for_all_members = 1
cloudaudit_track_status          = 1
cloudaudit_storage_type          = "cos"
cloudaudit_storage_name          = "prod-audit-logs"
cloudaudit_storage_prefix        = "audit"

# 审计过滤规则
audit_filters = [
  {
    resource_type = "*"
    action_type   = "*"
    event_names   = ["*Create*", "*Delete*", "*Modify*"]
  },
  {
    resource_type = "cam"
    action_type   = "write"
    event_names   = ["CreateUser", "DeleteUser", "AttachUserPolicy"]
  }
]

# COS存储配置
cos_bucket_acl        = "private"
cos_multi_az          = true
cos_force_clean       = true
cos_versioning_enable = true

# COS生命周期规则
cos_lifecycle_rules = [
  {
    id            = "transition-to-ia"
    filter_prefix = ""
    
    transition = [
      {
        days          = 30
        storage_class = "STANDARD_IA"
      },
      {
        days          = 60
        storage_class = "ARCHIVE"
      }
    ]
  },
  {
    id            = "expire-old-versions"
    filter_prefix = ""
    
    non_current_expiration = {
      non_current_days = 90
    }
  }
]

# CLS存储配置（当使用CLS时）
cls_logset_name = "audit-logset"
cls_topic_name  = "audit-topic"
cls_auto_split  = true
cls_period      = 90
cls_storage_type = "hot"
```

### 组织成员配置示例

```hcl
# 指定组织成员进行审计
member_info = {
  member_uin  = 100000000001  # 使用uin
  # 或
  member_name = "dev-user"     # 使用成员名称
}
```

---

## 使用示例

### 示例一：基础COS存储审计

```hcl
module "cloud_audit_cos" {
  source = "./modules/cloud-audit"

  cloudaudit_storage_region = "ap-guangzhou"
  
  cloudaudit_track_name            = "basic-audit-track"
  cloudaudit_track_for_all_members = 1
  cloudaudit_storage_type          = "cos"
  cloudaudit_storage_name          = "basic-audit-logs"
  
  # 审计所有写操作
audit_filters = [
  {
    resource_type = "*"
    action_type   = "write"
    event_names   = ["*"]
  }
]
}
```

### 示例二：精细化CLS存储审计

```hcl
module "cloud_audit_cls" {
  source = "./modules/cloud-audit"

  cloudaudit_storage_region = "ap-beijing"
  
  cloudaudit_track_name            = "detailed-audit-track"
  cloudaudit_track_for_all_members = 0  # 仅审计指定成员
  cloudaudit_storage_type          = "cls"
  
  # 指定组织成员
  member_info = {
    member_name = "admin-user"
  }
  
  # CLS配置
  cls_logset_name = "security-audit"
  cls_topic_name  = "admin-operations"
  cls_period      = 180  # 6个月存储
  cls_storage_type = "hot"
  
  # 精细化审计规则
audit_filters = [
  {
    resource_type = "cam"
    action_type   = "*"
    event_names   = ["*User*", "*Policy*", "*Role*"]
  },
  {
    resource_type = "cvm"
    action_type   = "write"
    event_names   = ["RunInstances", "TerminateInstances", "ModifyInstances"]
  },
  {
    resource_type = "vpc"
    action_type   = "write"
    event_names   = ["CreateVpc", "DeleteVpc", "ModifyVpc"]
  }
]
}
```

### 示例三：生产环境完整配置

```hcl
module "cloud_audit_prod" {
  source = "./modules/cloud-audit"

  cloudaudit_storage_region = "ap-shanghai"
  
  cloudaudit_track_name            = "production-audit"
  cloudaudit_track_for_all_members = 1
  cloudaudit_storage_type          = "cos"
  cloudaudit_storage_name          = "prod-audit-${formatdate("YYYYMMDD", timestamp())}"
  
  # COS高可用配置
  cos_multi_az          = true
  cos_versioning_enable = true
  
  # 生命周期管理
  cos_lifecycle_rules = [
    {
      id            = "auto-archive"
      filter_prefix = ""
      
      transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "ARCHIVE"
        }
      ]
    }
  ]
  
  # 全面审计配置
audit_filters = [
  {
    resource_type = "*"
    action_type   = "*"
    event_names   = ["*"]
  }
]
}
```

### 示例四：安全合规审计

```hcl
module "cloud_audit_compliance" {
  source = "./modules/cloud-audit"

  cloudaudit_storage_region = "ap-guangzhou"
  
  cloudaudit_track_name            = "compliance-audit"
  cloudaudit_track_for_all_members = 1
  cloudaudit_storage_type          = "cls"
  
  # CLS配置
  cls_logset_name = "compliance-logs"
  cls_topic_name  = "security-events"
  cls_period      = 365  # 1年存储
  cls_create_index = true
  
  # 安全相关事件审计
audit_filters = [
  {
    resource_type = "cam"
    action_type   = "write"
    event_names   = [
      "CreateUser", "DeleteUser", "UpdateUser",
      "CreatePolicy", "DeletePolicy", "AttachUserPolicy", "DetachUserPolicy"
    ]
  },
  {
    resource_type = "kms"
    action_type   = "*"
    event_names   = ["*"]
  },
  {
    resource_type = "security"
    action_type   = "*"
    event_names   = ["*"]
  }
]
}
```

---

## 配置说明

### 存储类型选择逻辑

```
存储类型选择流程：
┌─────────────────────────────────────┐
│  cloudaudit_storage_type 检查       │
│         │                           │
│    storage_type = "cos" → 创建COS桶  │
│    storage_type = "cls" → 创建CLS    │
│    storage_type = null  → 使用现有存储 │
└─────────────────────────────────────┘
```

### 模块依赖关系

```hcl
# 主审计跟踪模块
module "tencentcloud_audit_track"
│
├─ module "tencentcloud_audit_track_cos" (COS存储，可选)
│  └─ module "tencentcloud_audit_track_cos_policy" (COS策略，可选)
│
└─ module "tencentcloud_audit_track_cls" (CLS存储，可选)
```

### 审计过滤规则语法

```json
{
  "resource_type": "cam",       // 资源类型：* 或具体服务
  "action_type": "write",       // 操作类型：read/write/*
  "event_names": ["CreateUser"] // 事件名称列表，支持通配符
}
```

### 资源创建顺序

```
tencentcloud_audit_track (审计跟踪创建)
          │
          ├─ tencentcloud_audit_track_cos (COS存储创建，可选)
          │       │
          │       └─ tencentcloud_audit_track_cos_policy (COS策略配置，可选)
          │
          └─ tencentcloud_audit_track_cls (CLS存储创建，可选)
```

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **存储区域一致性**
   - 存储区域必须与审计跟踪区域一致
   - 跨区域存储需要额外配置跨区域复制

2. **组织成员审计**
   - `cloudaudit_track_for_all_members=1`时审计所有组织成员
   - 需要提前创建腾讯云组织架构

3. **存储类型限制**
   - 目前支持COS和CLS两种存储类型
   - CKafka存储类型暂未实现

4. **COS访问策略**
   - 模块会自动为COS桶配置云审计服务访问权限
   - 手动修改策略可能导致审计失败

5. **CLS索引配置**
   - `cls_create_index=true`时自动创建索引
   - 索引规则需要根据审计需求精细配置

6. **审计数据量**
   - 全量审计会产生大量日志数据
   - 建议根据实际需求配置过滤规则

7. **成本考虑**
   - COS存储成本与存储量和访问频率相关
   - CLS成本与日志量和索引配置相关
   - 长期存储建议使用生命周期规则

8. **合规要求**
   - 审计日志需要满足合规存储期限要求
   - 敏感操作建议配置更长的存储时间

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少云审计或存储服务权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含`QcloudAuditFullAccess`、`QcloudCOSFullAccess`、`QcloudCLSFullAccess`权限

#### 错误二：存储区域不匹配

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region does not match
```

**原因**：存储区域与审计跟踪区域不一致
**解决方案**：
- 确保`cloudaudit_storage_region`与审计跟踪区域一致
- 检查腾讯云服务区域可用性

#### 错误三：存储桶已存在

```
Error: [TencentCloudSDKError] Code=ResourceInUse
Message=Bucket already exists
```

**原因**：COS桶名称已被使用
**解决方案**：
- 修改`cloudaudit_storage_name`为唯一名称
- 删除已存在的同名存储桶

#### 错误四：组织成员不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Member not found
```

**原因**：指定的组织成员不存在
**解决方案**：
- 确认组织成员uin或名称正确
- 检查腾讯云组织架构

#### 错误五：CLS配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid CLS configuration
```

**原因**：CLS配置参数不正确
**解决方案**：
- 检查`cls_period`在1-366天范围内
- 确认`cls_partition_count`在1-10范围内
- 验证`cls_storage_type`为hot或cold

#### 错误六：审计过滤规则错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid audit filter
```

**原因**：审计过滤规则格式不正确
**解决方案**：
- 检查`audit_filters`数组格式
- 确认资源类型、操作类型、事件名称格式正确
- 使用腾讯云支持的资源类型和事件名称