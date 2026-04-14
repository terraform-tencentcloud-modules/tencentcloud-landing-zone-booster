# 腾讯云账号（Account）部署模块

## 模块概述

本模块用于在腾讯云组织（TCO）中创建和管理成员账号，支持以下核心功能：

- 在资源目录中创建组织成员账号
- 配置成员账号的权限策略
- 支持成员账号绑定邮箱及手机号
- 支持自定义账号所属节点（部门）
- 支持账号标签管理

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
| `QcloudOrganizationFullAccess` | 腾讯云组织全读写权限 |
| `QcloudOrganizationMemberFullAccess` | 组织成员管理权限 |

### 其他要求

- 当前账号必须是腾讯云组织的**管理员账号（主账号）**
- 已完成腾讯云组织的初始化配置
- 若需绑定邮箱，需确保邮箱地址未被其他账号占用

---

## 变量说明

### 必填变量

| 变量名 | 类型 | 说明 | 示例值 |
|--------|------|------|--------|
| `member_name` | `string` | 成员账号名称，组织内唯一 | `"business-prod"` |
| `permission_ids` | `list(number)` | 成员账号权限 ID 列表 | `[1, 2, 3]` |
| `policy_type` | `string` | 成员财务权限类型 | `"Financial"` |

### 可选变量

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `node_id` | `number` | `null` | 成员所属节点 ID，为空时使用根节点 |
| `pay_uin` | `string` | `null` | 代付账号 UIN |
| `force_delete_account` | `bool` | `false` | 是否强制删除账号 |
| `is_modify_nick_name` | `bool` | `null` | 是否允许修改昵称（1:同步, 0:不同步） |
| `record_id` | `number` | `null` | 注册记录 ID |
| `remark` | `string` | `null` | 账号备注信息 |
| `tags` | `map(string)` | `null` | 资源标签键值对 |

### 邮箱绑定变量

> 当 `enable_bound = true` 时，以下变量为必填项

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enable_bound` | `bool` | `false` | 是否启用邮箱绑定 |
| `email` | `string` | `null` | 绑定的邮箱地址 |
| `phone` | `string` | `null` | 绑定的手机号码（不含国家码） |
| `country_code` | `number` | `86` | 手机号国家/地区码 |

---

## 变量配置

### variables.tf

```hcl
# ============================================================
# 必填变量
# ============================================================

variable "member_name" {
  description = "成员账号名称，在组织内必须唯一"
  type        = string

  validation {
    condition     = length(var.member_name) >= 2 && length(var.member_name) <= 64
    error_message = "member_name 长度必须在 2 ~ 64 个字符之间。"
  }
}

variable "permission_ids" {
  description = "成员账号权限 ID 列表"
  type        = list(number)

  validation {
    condition     = length(var.permission_ids) > 0
    error_message = "permission_ids 至少需要配置一个权限 ID。"
  }
}

variable "policy_type" {
  description = "成员财务权限类型，支持 Financial"
  type        = string
  default     = "Financial"

  validation {
    condition     = contains(["Financial"], var.policy_type)
    error_message = "policy_type 目前仅支持：Financial。"
  }
}

# ============================================================
# 可选变量
# ============================================================

variable "node_id" {
  description = "成员所属节点（部门）ID，为 null 或 0 时自动使用根节点"
  type        = number
  default     = null
}

variable "pay_uin" {
  description = "代付账号 UIN，不填则由自身账号承担费用"
  type        = string
  default     = null
}

variable "force_delete_account" {
  description = "销毁资源时是否强制删除成员账号，谨慎开启"
  type        = bool
  default     = false
}

variable "is_modify_nick_name" {
  description = "是否允许成员修改昵称"
  type        = bool
  default     = true
}

variable "record_id" {
  description = "注册记录 ID"
  type        = number
  default     = null
}

variable "remark" {
  description = "成员账号备注信息"
  type        = string
  default     = null

  validation {
    condition     = var.remark == null || length(var.remark) <= 256
    error_message = "remark 长度不能超过 256 个字符。"
  }
}

variable "tags" {
  description = "资源标签键值对"
  type        = map(string)
  default     = {}
}

# ============================================================
# 邮箱绑定变量
# ============================================================

variable "enable_bound" {
  description = "是否启用邮箱绑定，启用后需同时配置 email、phone、country_code"
  type        = bool
  default     = false
}

variable "email" {
  description = "绑定的邮箱地址，enable_bound 为 true 时必填"
  type        = string
  default     = null

  validation {
    condition = (
      var.email == null ||
      can(regex("^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$", var.email))
    )
    error_message = "email 格式不正确，请输入有效的邮箱地址。"
  }
}

variable "phone" {
  description = "绑定的手机号码（不含国家码），enable_bound 为 true 时必填"
  type        = string
  default     = null

  validation {
    condition     = var.phone == null || can(regex("^[0-9]{7,15}$", var.phone))
    error_message = "phone 格式不正确，仅支持 7 ~ 15 位纯数字。"
  }
}

variable "country_code" {
  description = "手机号国家/地区码，默认为中国大陆（86）"
  type        = string
  default     = "86"

  validation {
    condition     = can(regex("^[0-9]{1,4}$", var.country_code))
    error_message = "country_code 格式不正确，仅支持 1 ~ 4 位纯数字。"
  }
}
```

### terraform.tfvars 示例

```hcl
# 必填配置
member_name    = "business-prod"
permission_ids = [1, 2]
policy_type    = "Financial"

# 可选配置
node_id              = 123456
pay_uin              = "100037718139"
force_delete_account = false
is_modify_nick_name  = 1
remark               = "生产环境业务账号"

tags = {
  environment = "production"
  team        = "platform"
  createdBy   = "terraform"
}

# 邮箱绑定配置
enable_bound = true
email        = "admin@example.com"
phone        = "13800138000"
country_code = 86
```

---

## 使用示例

### 示例一：创建基础成员账号（不绑定邮箱）

```hcl
module "org_member_basic" {
  source = "./modules/account"

  # 必填参数
  member_name    = "business-dev"
  permission_ids = [1, 2]
  policy_type    = "Financial"

  # 可选参数
  remark = "开发环境账号"
  tags = {
    environment = "development"
    createdBy   = "terraform"
  }
}
```

### 示例二：创建成员账号并绑定邮箱

```hcl
module "org_member_with_email" {
  source = "./modules/account"

  # 必填参数
  member_name    = "business-prod"
  permission_ids = [1, 2]
  policy_type    = "Financial"

  # 指定所属节点
  node_id = 123456

  # 启用邮箱绑定
  enable_bound = true
  email        = "prod-admin@example.com"
  phone        = "13800138000"
  country_code = 86

  remark = "生产环境核心业务账号"
  tags = {
    environment = "production"
    team        = "platform"
    createdBy   = "terraform"
  }
}
```

### 示例三：创建成员账号并指定代付账号

```hcl
module "org_member_with_pay" {
  source = "./modules/account"

  # 必填参数
  member_name    = "business-staging"
  permission_ids = [1, 2, 7]  # 包含代付权限
  policy_type    = "Financial"

  # 代付账号配置
  pay_uin = "100037718139"

  # 指定所属节点
  node_id = 654321

  remark = "预发布环境账号，费用由主账号代付"
  tags = {
    environment = "staging"
    createdBy   = "terraform"
  }
}
```

### 示例四：批量创建多个成员账号

```hcl
locals {
  members = {
    "business-dev" = {
      node_id      = 111111
      remark       = "开发环境账号"
      enable_bound = false
      email        = null
      phone        = null
    }
    "business-staging" = {
      node_id      = 222222
      remark       = "预发布环境账号"
      enable_bound = true
      email        = "staging@example.com"
      phone        = "13800138001"
    }
    "business-prod" = {
      node_id      = 333333
      remark       = "生产环境账号"
      enable_bound = true
      email        = "prod@example.com"
      phone        = "13800138002"
    }
  }
}

module "org_members" {
  source   = "./modules/account"
  for_each = local.members

  member_name    = each.key
  permission_ids = [1, 2]
  policy_type    = "Financial"
  node_id        = each.value.node_id
  remark         = each.value.remark
  enable_bound   = each.value.enable_bound
  email          = each.value.email
  phone          = each.value.phone
  country_code   = 86

  tags = {
    environment = "multi"
    createdBy   = "terraform"
  }
}
```

---

## 配置说明

### node_id 节点选择逻辑

```
node_id 配置逻辑：
┌─────────────────────────────────────┐
│  var.node_id != null                │
│  && var.node_id != 0                │
│         │                           │
│    YES  ▼              NO           │
│  使用指定节点 ID  →  使用根节点 ID  │
│  (var.node_id)      (local.root_node_id) │
└─────────────────────────────────────┘
```

### 邮箱绑定生命周期说明

```hcl
lifecycle {
  ignore_changes = [ email, phone ]
}
```

> 邮箱和手机号在首次绑定后，后续 Terraform 执行将**忽略**对这两个字段的变更，
> 避免因配置文件修改导致意外解绑。如需修改，请在腾讯云控制台手动操作。

### 资源依赖关系

```
tencentcloud_organization_org_member (成员账号)
          │
          │ depends_on
          ▼
tencentcloud_organization_org_member_email (邮箱绑定)
          │
          │ count = var.enable_bound ? 1 : 0
          ▼
     启用绑定时创建，禁用时不创建
```

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **账号删除风险**
   - `force_delete_account = true` 会在 `terraform destroy` 时**强制注销**成员账号
   - 账号注销后**数据不可恢复**，生产环境请保持默认值 `false`

2. **邮箱绑定限制**
   - 同一邮箱地址只能绑定**一个**腾讯云账号
   - 邮箱绑定后，Terraform 不会追踪 `email` 和 `phone` 的变更（`ignore_changes` 已配置）
   - 如需修改绑定邮箱，请前往腾讯云控制台手动操作

3. **节点 ID 说明**
   - `node_id` 为 `null` 或 `0` 时，成员账号将自动归属到组织**根节点**
   - 请确保指定的 `node_id` 在组织中已存在

4. **权限要求**
   - 执行本模块的账号必须是组织**管理员账号**
   - 普通成员账号无权创建其他成员账号

5. **代付账号限制**
   - `pay_uin` 指定的代付账号必须与当前组织存在财务关联关系
   - 代付关系需提前在腾讯云控制台完成配置

6. **权限ID要求**
   - `permission_ids` 必须至少包含权限 1（查看账单）和 2（查看余额）
   - 如需代付功能，需要包含权限 7（代付）

---

## 故障排除

### 常见错误及解决方案

#### 错误一：成员账号名称已存在

```
Error: [TencentCloudSDKError] Code=ResourceInUse,
Message=Member name already exists
```

**原因**：组织内已存在同名成员账号
**解决方案**：
```hcl
# 修改 member_name 为唯一名称
member_name = "business-prod-v2"
```

---

#### 错误二：节点 ID 不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound,
Message=Node not found
```

**原因**：指定的 `node_id` 在组织中不存在
**解决方案**：
```bash
# 查询组织节点列表
terraform console
> data.tencentcloud_organization_org_nodes.nodes
```
```hcl
# 或置空使用根节点
node_id = null
```

---

#### 错误三：邮箱已被占用

```
Error: [TencentCloudSDKError] Code=ResourceInUse,
Message=Email already bound to another account
```

**原因**：该邮箱已绑定其他腾讯云账号
**解决方案**：
```hcl
# 更换未被占用的邮箱地址
email = "new-admin@example.com"
```

---

#### 错误四：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation,
Message=The current account is not the organization administrator
```

**原因**：执行账号不是组织管理员
**解决方案**：
- 确认 Provider 配置的 `secret_id` / `secret_key` 属于组织管理员账号
- 检查 CAM 策略是否包含 `QcloudOrganizationFullAccess`

```hcl
# 检查 Provider 配置
provider "tencentcloud" {
  secret_id  = var.secret_id   # 确认为管理员账号密钥
  secret_key = var.secret_key
  region     = var.region
}
```

---

#### 错误五：ignore_changes 导致邮箱未更新

**现象**：修改了 `email` 或 `phone`，但 `terraform plan` 显示无变更
**原因**：`lifecycle.ignore_changes` 配置忽略了这两个字段的变更
**解决方案**：
```bash
# 方式一：通过腾讯云控制台手动修改邮箱绑定
# 方式二：先销毁邮箱绑定资源，再重新创建
terraform destroy -target="module.org_member.tencentcloud_organization_org_member_email.org_member_emails"
terraform apply
```