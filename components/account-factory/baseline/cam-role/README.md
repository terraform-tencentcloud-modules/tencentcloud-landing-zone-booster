# 腾讯云CAM角色（CAM Role）管理模块

## 模块概述

本模块用于在腾讯云中创建和管理CAM（Cloud Access Management）角色，支持以下核心功能：

- **角色创建** - 创建自定义CAM角色，支持控制台登录和临时密钥有效期配置
- **主体配置** - 支持账户主体和服务主体两种类型的角色信任关系
- **策略管理** - 支持预定义策略和自定义策略的关联
- **批量关联** - 自动将策略关联到创建的角色
- **标签管理** - 支持为角色和策略添加标签

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
| `QcloudOrganizationReadOnlyAccess` | 组织只读权限（用于查询成员信息） |

### 其他要求

- 当前账号需要具有CAM管理权限
- 如需使用组织成员信息，需要是腾讯云组织成员

---

## 变量说明

### 必填变量

| 变量名 | 类型 | 说明 | 示例值 |
|--------|------|------|--------|
| `role_name` | `string` | CAM角色名称，全局唯一 | `"readonly-role"` |
| `principal` | `object` | 角色信任主体配置 | 见下方详细说明 |

### 可选变量

#### 角色基础配置

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `description` | `string` | `null` | 角色描述信息 |
| `console_login` | `bool` | `false` | 是否允许控制台登录 |
| `session_duration` | `number` | `7200` | 临时密钥最大有效期（秒） |
| `tags` | `map(string)` | `null` | 角色标签键值对 |

#### 主体配置 (`principal`)

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `type` | `number` | - | 主体类型：1-账户，2-服务 |
| `account_uin` | `string` | - | 账户UIN（与account_name二选一） |
| `account_name` | `string` | - | 账户名称（组织成员名或CAM用户名） |
| `service_name` | `string` | - | 服务名称（type=2时必填） |

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
role_name = "readonly-role"

# 主体配置 - 账户类型
principal = {
  type        = 1  # 账户类型
  account_uin = "1000000000"  # 使用UIN
  # account_name = "member-account"  # 或使用账户名称
}

# 主体配置 - 服务类型  
# principal = {
#   type        = 2  # 服务类型
#   service_name = "cloudaudit"  # 服务名称
# }

# 角色基础配置
description      = "只读访问角色"
console_login    = false
session_duration = 3600
tags = {
  Environment = "Production"
  Team        = "Platform"
}

# 策略配置
cam_policy = {
  # 预定义策略
  pre_policies = [
    "QcloudCamReadOnlyAccess",
    "QcloudCVMReadOnlyAccess"
  ]
  
  # 自定义策略
  custom_policies = [
    {
      name        = "custom-readonly-policy"
      document    = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "action": [
                "cvm:Describe*",
                "vpc:Describe*"
              ],
              "resource": "*",
              "effect": "allow"
            }
          ]
        }
      EOT
      description = "自定义只读策略"
      tags = {
        Category = "Custom"
      }
    }
  ]
}
```

---

## 使用示例

### 示例一：基础只读角色

```hcl
module "cam_role_basic" {
  source = "./modules/cam-role"

  role_name = "basic-readonly-role"
  
  principal = {
    type        = 1
    account_uin = "1000000000"
  }
  
  description = "基础只读访问角色"
  
  cam_policy = {
    pre_policies = ["QcloudCamReadOnlyAccess"]
  }
}
```

### 示例二：服务角色

```hcl
module "cam_role_service" {
  source = "./modules/cam-role"

  role_name = "cloudaudit-service-role"
  
  principal = {
    type         = 2
    service_name = "cloudaudit"
  }
  
  description = "云审计服务角色"
  
  cam_policy = {
    pre_policies = ["QcloudAuditFullAccess"]
  }
}
```

### 示例三：带自定义策略的角色

```hcl
module "cam_role_custom" {
  source = "./modules/cam-role"

  role_name = "custom-database-role"
  
  principal = {
    type        = 1
    account_name = "database-admin"
  }
  
  description = "数据库管理自定义角色"
  
  cam_policy = {
    pre_policies = ["QcloudCamReadOnlyAccess"]
    
    custom_policies = [
      {
        name        = "database-admin-policy"
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

### 示例四：允许控制台登录的角色

```hcl
module "cam_role_console" {
  source = "./modules/cam-role"

  role_name = "console-admin-role"
  
  principal = {
    type        = 1
    account_uin = "1000000000"
  }
  
  description      = "控制台管理角色"
  console_login    = true
  session_duration = 14400  # 4小时
  
  cam_policy = {
    pre_policies = ["QcloudResourceFullAccess"]
  }
}
```

---

## 配置说明

### 主体识别逻辑

```
主体识别流程：
┌─────────────────────────────────────┐
│  var.principal 配置检查             │
│         │                           │
│   提供 account_uin    → 使用指定UIN  │
│   提供 account_name   → 查询组织或CAM │
│   两者都未提供        → 使用当前账号  │
│   type=2             → 使用服务名称  │
└─────────────────────────────────────┘
```

### 策略关联逻辑

```hcl
# 策略关联包含预定义策略和自定义策略
user_policies = concat(
  [预定义策略配置],
  [自定义策略配置]
)

# 自动创建策略关联
resource "tencentcloud_cam_role_policy_attachment" "role_policy_attachment" {
  for_each = { for policy in local.user_policies : policy.policy_name => policy}
  
  role_id   = tencentcloud_cam_role.role.id
  policy_id = each.value.policy_id
}
```

### 资源依赖关系

```
tencentcloud_cam_role.role (角色创建)
          │
tencentcloud_cam_policy.policies (自定义策略创建，可选)
          │
          │ depends_on
          ▼
tencentcloud_cam_role_policy_attachment.role_policy_attachment (策略关联)
```

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **角色名称唯一性**
   - CAM角色名称在腾讯云账号内必须全局唯一
   - 建议使用有意义的命名规范

2. **主体配置要求**
   - `type=1`（账户类型）时，必须提供`account_uin`或`account_name`
   - `type=2`（服务类型）时，必须提供`service_name`
   - 两者都未提供时，默认使用当前账号UIN

3. **控制台登录限制**
   - `console_login=true`时，角色可以登录控制台
   - 生产环境建议设置为`false`以增强安全性

4. **会话有效期**
   - `session_duration`设置临时密钥的最大有效期（秒）
   - 默认7200秒（2小时），最大43200秒（12小时）

5. **策略文档格式**
   - 自定义策略的`document`必须是有效的JSON格式
   - 必须符合腾讯云CAM策略文档规范

6. **权限要求**
   - 执行模块需要CAM管理权限
   - 查询组织成员需要组织只读权限

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
- 检查CAM策略是否包含所需权限

#### 错误二：角色已存在

```
Error: [TencentCloudSDKError] Code=ResourceInUse
Message=Role already exists
```

**原因**：角色名称已被使用
**解决方案**：
- 修改`role_name`为唯一名称
- 删除已存在的同名角色

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

#### 错误四：账户不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Account not found
```

**原因**：指定的账户UIN或名称不存在
**解决方案**：
- 确认账户UIN或名称正确
- 检查账户是否已加入组织（如果是组织成员）

#### 错误五：策略文档格式错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid policy document
```

**原因**：自定义策略文档格式不正确
**解决方案**：
- 检查JSON格式是否正确
- 验证策略语法是否符合腾讯云规范
- 使用在线JSON验证工具检查