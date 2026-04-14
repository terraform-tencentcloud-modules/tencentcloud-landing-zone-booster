# 腾讯云CAM用户（CAM User）管理模块

## 模块概述

本模块用于在腾讯云中创建和管理CAM（Cloud Access Management）用户，支持以下核心功能：

- **用户创建** - 创建CAM用户，支持完整的用户信息配置
- **密码管理** - 自动生成强密码或使用自定义密码，支持首次登录重置
- **API密钥** - 自动生成API访问密钥（Access Key）
- **策略管理** - 支持预定义策略和自定义策略的关联
- **批量关联** - 自动将策略关联到创建的用户
- **标签管理** - 支持为用户和策略添加标签

---

## 前置要求

### 环境要求

| 工具 | 最低版本 | 说明 |
|------|----------|------|
| Terraform | `>= 1.3.0` | 基础设施即代码工具 |
| tencentcloud provider | `>= 1.81.0` | 腾讯云 Terraform Provider |
| random provider | `>= 3.5.0` | 随机数生成工具 |

### 权限要求

执行本模块需要具备以下腾讯云权限：

| 权限名称 | 说明 |
|----------|------|
| `QcloudCamFullAccess` | CAM权限管理全权限 |

### 其他要求

- 当前账号需要具有CAM管理权限
- 创建用户需要主账号权限或具有CAM管理权限的子账号

---

## 变量说明

### 必填变量

| 变量名 | 类型 | 说明 | 示例值 |
|--------|------|------|--------|
| `user_name` | `string` | CAM用户名，全局唯一 | `"dev-user"` |

### 可选变量

#### 用户基础配置

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `user_phone_number` | `string` | `null` | 用户手机号码 |
| `phone_country_code` | `string` | `null` | 手机国家代码（如：86） |
| `user_email` | `string` | `null` | 用户邮箱地址 |
| `user_remark` | `string` | `null` | 用户备注信息 |
| `console_login` | `bool` | `false` | 是否允许控制台登录 |
| `use_api` | `bool` | `true` | 是否生成API密钥 |
| `need_reset_password` | `bool` | `true` | 首次登录是否需要重置密码 |
| `user_password` | `string` | `null` | 用户密码（敏感信息） |
| `force_delete` | `bool` | `false` | 是否强制删除用户（存在API密钥时） |
| `tags` | `map(string)` | `null` | 用户标签键值对 |

#### 策略配置 (`cam_policy`)

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `pre_policies` | `list(string)` | `[]` | 预定义策略名称列表 |
| `custom_policies` | `list(object)` | `[]` | 自定义策略配置列表 |
| `↳ name` | `string` | - | 自定义策略名称 |
| `↳ document` | `string` | - | 策略文档（JSON格式） |
| `↳ description` | `string` | - | 策略描述 |
| `↳ tags` | `map(string)` | - | 策略标签 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 必填配置
user_name = "dev-user"

# 用户基础配置
user_phone_number = "13800138000"
phone_country_code = "86"
user_email        = "dev-user@example.com"
user_remark       = "开发环境用户"
console_login     = true
use_api           = true
need_reset_password = true
force_delete      = false

tags = {
  Environment = "Development"
  Team        = "Backend"
  Project     = "Microservice"
}

# 策略配置
cam_policy = {
  # 预定义策略
  pre_policies = [
    "QcloudCamReadOnlyAccess",
    "QcloudCVMReadOnlyAccess",
    "QcloudVPCReadOnlyAccess"
  ]
  
  # 自定义策略
  custom_policies = [
    {
      name        = "custom-dev-access"
      document    = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "action": [
                "cvm:*",
                "vpc:*",
                "clb:*"
              ],
              "resource": "*",
              "effect": "allow"
            }
          ]
        }
      EOT
      description = "开发环境全权限策略"
      tags = {
        Category = "Development"
      }
    }
  ]
}
```

### 密码配置说明

```hcl
# 自动生成密码（推荐）
user_password = null  # 不设置密码，自动生成强密码

# 自定义密码
user_password = "P@ssw0rd123!"  # 8-32字符，包含大小写字母、数字、特殊字符
```

---

## 使用示例

### 示例一：基础开发用户

```hcl
module "cam_user_basic" {
  source = "./modules/cam-user"

  user_name = "dev-basic-user"
  
  user_email    = "dev@example.com"
  console_login = true
  use_api       = true
  
  cam_policy = {
    pre_policies = ["QcloudCamReadOnlyAccess"]
  }
}
```

### 示例二：API专用用户

```hcl
module "cam_user_api" {
  source = "./modules/cam-user"

  user_name = "api-service-user"
  
  user_remark       = "API服务账号"
  console_login     = false  # 禁止控制台登录
  use_api           = true   # 启用API访问
  need_reset_password = false # 不需要重置密码
  
  cam_policy = {
    pre_policies = ["QcloudResourceFullAccess"]
  }
}
```

### 示例三：带自定义策略的用户

```hcl
module "cam_user_custom" {
  source = "./modules/cam-user"

  user_name = "custom-policy-user"
  
  user_phone_number = "13900139000"
  phone_country_code = "86"
  console_login     = true
  
  cam_policy = {
    pre_policies = ["QcloudCamReadOnlyAccess"]
    
    custom_policies = [
      {
        name        = "database-access-policy"
        document    = <<-EOT
          {
            "version": "2.0",
            "statement": [
              {
                "action": [
                  "cdb:*",
                  "mariadb:*",
                  "cynosdb:*"
                ],
                "resource": "*",
                "effect": "allow"
              }
            ]
          }
        EOT
        description = "数据库全权限策略"
      }
    ]
  }
}
```

### 示例四：只读监控用户

```hcl
module "cam_user_monitor" {
  source = "./modules/cam-user"

  user_name = "monitor-readonly-user"
  
  user_email    = "monitor@example.com"
  console_login = true
  
  cam_policy = {
    pre_policies = [
      "QcloudCamReadOnlyAccess",
      "QcloudMonitorReadOnlyAccess",
      "QcloudCLSReadOnlyAccess"
    ]
  }
}
```

---

## 配置说明

### 密码生成逻辑

```
密码生成流程：
┌─────────────────────────────────────┐
│  console_login = true 检查          │
│         │                           │
│   提供 user_password    → 使用指定密码 │
│   user_password = null  → 自动生成强密码│
│  console_login = false → 不设置密码   │
└─────────────────────────────────────┘
```

### API密钥生成逻辑

```hcl
# use_api = true 时生成API密钥
resource "tencentcloud_cam_access_key" "aksk" {
  count = var.use_api ? 1 : 0

  target_uin = tencentcloud_cam_user.user.uin
  status     = "Active"
}
```

### 策略关联逻辑

```hcl
# 策略关联包含预定义策略和自定义策略
user_policies = concat(
  [预定义策略配置],
  [自定义策略配置]
)

# 自动创建策略关联
resource "tencentcloud_cam_user_policy_attachment" "user_policy_attachment" {
  for_each = { for policy in local.user_policies : policy.policy_name => policy}
  
  user_name = tencentcloud_cam_user.user.name
  policy_id = each.value.policy_id
}
```

### 资源依赖关系

```
random_password.pwd (密码生成，可选)
          │
tencentcloud_cam_user.user (用户创建)
          │
          ├─ tencentcloud_cam_access_key.aksk (API密钥生成，可选)
          │
tencentcloud_cam_policy.policies (自定义策略创建，可选)
          │
          │ depends_on
          ▼
tencentcloud_cam_user_policy_attachment.user_policy_attachment (策略关联)
```

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **用户名唯一性**
   - CAM用户名在腾讯云账号内必须全局唯一
   - 建议使用有意义的命名规范

2. **密码复杂度要求**
   - 密码长度8-32字符
   - 必须包含：大写字母、小写字母、数字、特殊字符
   - 特殊字符仅支持：`!#$%&*()-_=+[]{}<>:?`

3. **控制台登录限制**
   - `console_login=true`时，用户可以通过控制台登录
   - 生产环境建议为服务账号设置为`false`

4. **API密钥安全**
   - `use_api=true`时自动生成API密钥
   - API密钥需要妥善保管，建议使用密钥管理系统

5. **密码重置**
   - `need_reset_password=true`时，用户首次登录需要重置密码
   - 增强安全性，推荐启用此选项

6. **强制删除**
   - `force_delete=false`时，如果用户存在API密钥，删除会失败
   - `force_delete=true`时，强制删除用户（包括API密钥）

7. **敏感信息输出**
   - 密码和API密钥在Terraform输出中标记为敏感信息
   - 实际使用时需要妥善处理这些敏感信息

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少CAM管理权限
**解决方案**：
- 确认Provider配置的密钥具有CAM管理权限
- 检查CAM策略是否包含`QcloudCamFullAccess`权限

#### 错误二：用户已存在

```
Error: [TencentCloudSDKError] Code=ResourceInUse
Message=User already exists
```

**原因**：用户名已被使用
**解决方案**：
- 修改`user_name`为唯一名称
- 删除已存在的同名用户

#### 错误三：策略不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Policy not found
```

**原因**：指定的预定义策略不存在
**解决方案**：
```bash
# 查询可用的预定义策略
terraform console
> data.tencentcloud_cam_policies.all.policy_list
```

#### 错误四：密码复杂度不足

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Password does not meet complexity requirements
```

**原因**：自定义密码不符合复杂度要求
**解决方案**：
- 确保密码包含大小写字母、数字、特殊字符
- 密码长度在8-32字符之间
- 使用自动生成的密码（不设置`user_password`）

#### 错误五：API密钥存在

```
Error: [TencentCloudSDKError] Code=ResourceInUse
Message=Access key exists
```

**原因**：用户存在API密钥，无法直接删除
**解决方案**：
- 设置`force_delete=true`强制删除
- 先手动删除API密钥，再删除用户

#### 错误六：策略文档格式错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid policy document
```

**原因**：自定义策略文档格式不正确
**解决方案**：
- 检查JSON格式是否正确
- 验证策略语法是否符合腾讯云规范
- 使用在线JSON验证工具检查