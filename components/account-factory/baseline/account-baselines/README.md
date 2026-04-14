# 腾讯云账号基线（Account Baselines）部署模块

## 模块概述

本模块用于在腾讯云组织（TCO）中批量配置和管理成员账号的安全基线，支持以下核心功能：

- **CAM密码策略** - 配置用户密码复杂度、长度、重用限制等安全策略
- **CAM安全策略** - 配置多因素认证（MFA）、会话超时等安全设置
- **账号联系人** - 配置账号的紧急联系人信息
- **预设标签** - 批量创建和管理资源标签
- **安全组** - 创建标准化的安全组规则
- **VPC网络** - 创建标准化的VPC和子网配置
- **批量应用** - 支持将基线配置批量应用到多个成员账号

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
| `QcloudCamFullAccess` | CAM权限管理全权限 |
| `QcloudVPCFullAccess` | VPC网络全权限 |
| `QcloudCVMFullAccess` | 云服务器全权限 |

### 其他要求

- 当前账号必须是腾讯云组织的**管理员账号（主账号）**
- 已完成腾讯云组织的初始化配置
- 目标成员账号必须已创建并加入组织

---

## 变量说明

### 必填变量

| 变量名 | 类型 | 说明 | 示例值 |
|--------|------|------|--------|
| `baseline_name` | `string` | 基线配置名称，用于标识基线策略 | `"prod-security-baseline"` |
| `member_list` | `list(object)` | 成员账号列表，包含UIN或名称 | `[{member_uin: 1000001}]` |

### 可选变量（按功能模块分组）

#### CAM密码策略 (`cam_password`)

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enabled` | `bool` | `false` | 是否启用密码策略 |
| `password_must_contain` | `string` | `"1!aA"` | 密码必须包含的字符类型 |
| `password_minimum_length` | `number` | `8` | 密码最小长度（1-32） |
| `password_force_change` | `number` | `0` | 强制密码变更周期（0-365天） |
| `password_reuse_limit` | `number` | `1` | 密码重用限制次数（0-24） |
| `password_retry_limit` | `number` | `10` | 密码重试限制次数（≥1） |

#### CAM安全策略 (`cam_security`)

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enabled` | `bool` | `false` | 是否启用安全策略 |
| `security_mfa_devices` | `list(string)` | `["Stoken", "U2FToken", "Phone", "Mail"]` | 支持的MFA设备类型 |
| `security_mfa_login_strategy` | `number` | `1` | 登录MFA策略（1:强制, 2:用户选择） |
| `security_mfa_action_strategy` | `number` | `2` | 操作MFA策略（2:用户选择） |
| `security_login_idle_timeout` | `number` | `900` | 会话空闲超时时间（秒） |
| `security_login_max_timeout` | `number` | `3600` | 会话最大超时时间（秒） |

#### 账号联系人 (`account_contact`)

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enabled` | `bool` | `false` | 是否启用联系人配置 |
| `contacts` | `list(object)` | `[]` | 联系人列表 |
| `↳ name` | `string` | - | 联系人姓名 |
| `↳ phone_num` | `string` | - | 联系电话 |
| `↳ email` | `string` | - | 邮箱地址 |
| `↳ remark` | `string` | - | 备注信息 |
| `↳ country_code` | `string` | - | 国家代码 |

#### 预设标签 (`tag_info`)

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enabled` | `bool` | `false` | 是否启用标签配置 |
| `tags` | `list(object)` | `[]` | 标签键值对列表 |
| `↳ Key` | `string` | - | 标签键 |
| `↳ Values` | `list(string)` | - | 标签值列表 |

#### 安全组 (`security_group`)

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enabled` | `bool` | `false` | 是否启用安全组配置 |
| `name` | `string` | - | 安全组名称 |
| `region` | `string` | - | 安全组所属地域 |
| `remark` | `string` | `""` | 安全组备注 |
| `ingress_rules` | `list(object)` | `[]` | 入站规则列表 |
| `egress_rules` | `list(object)` | `[]` | 出站规则列表 |

#### VPC网络 (`vpc_info`)

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enabled` | `bool` | `false` | 是否启用VPC配置 |
| `name` | `string` | - | VPC名称 |
| `cidr` | `string` | - | VPC CIDR网段 |
| `region` | `string` | - | VPC所属地域 |
| `subnets` | `list(object)` | - | 子网配置列表 |
| `↳ subnet_name` | `string` | - | 子网名称 |
| `↳ cidr_block` | `string` | - | 子网CIDR网段 |
| `↳ zone` | `string` | - | 子网可用区 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 必填配置
baseline_name = "prod-security-baseline"

# 成员账号配置
member_list = [
  {
    member_uin  = 1000001
    member_name = "business-prod"
  },
  {
    member_uin  = 1000002  
    member_name = "business-dev"
  }
]

# CAM密码策略
cam_password = {
  enabled                  = true
  password_must_contain   = "1!aA"
  password_minimum_length = 12
  password_force_change   = 90
  password_reuse_limit    = 5
  password_retry_limit    = 5
}

# CAM安全策略
cam_security = {
  enabled                      = true
  security_mfa_devices         = ["Stoken", "U2FToken", "Phone"]
  security_mfa_login_strategy  = 1  # 强制MFA
  security_mfa_action_strategy = 2  # 用户选择
  security_login_idle_timeout  = 600
  security_login_max_timeout   = 7200
}

# 账号联系人
account_contact = {
  enabled = true
  contacts = [
    {
      name         = "张三"
      phone_num    = "13800138000"
      email        = "admin@example.com"
      remark       = "系统管理员"
      country_code = "86"
    }
  ]
}

# 预设标签
tag_info = {
  enabled = true
  tags = [
    {
      Key    = "Environment"
      Values = ["Production", "Development"]
    },
    {
      Key    = "Team"
      Values = ["Platform", "Business"]
    }
  ]
}

# 安全组配置
security_group = {
  enabled = true
  name    = "default-security-group"
  region  = "ap-guangzhou"
  remark  = "默认安全组规则"
  
  ingress_rules = [
    {
      cidr     = "0.0.0.0/0"
      protocol = "TCP"
      port     = "80"
      remark   = "HTTP访问"
      action   = "ACCEPT"
      type     = "CUSTOM"
    },
    {
      cidr     = "0.0.0.0/0"
      protocol = "TCP"
      port     = "443"
      remark   = "HTTPS访问"
      action   = "ACCEPT"
      type     = "CUSTOM"
    }
  ]
  
  egress_rules = [
    {
      cidr     = "0.0.0.0/0"
      protocol = "ALL"
      port     = "ALL"
      remark   = "允许所有出站"
      action   = "ACCEPT"
      type     = "CUSTOM"
    }
  ]
}

# VPC网络配置
vpc_info = {
  enabled = true
  name    = "main-vpc"
  cidr    = "10.0.0.0/16"
  region  = "ap-guangzhou"
  
  subnets = [
    {
      subnet_name = "subnet-a"
      cidr_block  = "10.0.1.0/24"
      zone        = "ap-guangzhou-3"
    },
    {
      subnet_name = "subnet-b"
      cidr_block  = "10.0.2.0/24"
      zone        = "ap-guangzhou-4"
    }
  ]
}
```

---

## 使用示例

### 示例一：基础安全基线配置

```hcl
module "account_baselines_basic" {
  source = "./modules/account-baselines"

  baseline_name = "basic-security-baseline"
  
  member_list = [
    { member_uin = 1000001 },
    { member_uin = 1000002 }
  ]

  # 启用密码策略
  cam_password = {
    enabled                  = true
    password_minimum_length = 10
    password_reuse_limit    = 3
  }

  # 启用安全策略
  cam_security = {
    enabled = true
  }
}
```

### 示例二：完整生产环境基线

```hcl
module "account_baselines_prod" {
  source = "./modules/account-baselines"

  baseline_name = "production-full-baseline"
  
  member_list = [
    { member_name = "business-prod" },
    { member_name = "business-staging" }
  ]

  # 完整的安全策略
  cam_password = {
    enabled                  = true
    password_must_contain   = "1!aA@"
    password_minimum_length = 12
    password_force_change   = 90
    password_reuse_limit    = 5
    password_retry_limit    = 3
  }

  cam_security = {
    enabled                      = true
    security_mfa_devices         = ["Stoken", "U2FToken"]
    security_mfa_login_strategy  = 1
    security_login_idle_timeout  = 300
    security_login_max_timeout   = 3600
  }

  # 网络基础设施
  security_group = {
    enabled = true
    name    = "prod-security-group"
    region  = "ap-guangzhou"
    
    ingress_rules = [
      {
        cidr     = "10.0.0.0/8"
        protocol = "ALL"
        port     = "ALL"
        remark   = "内部网络访问"
        action   = "ACCEPT"
        type     = "CUSTOM"
      }
    ]
  }

  vpc_info = {
    enabled = true
    name    = "prod-vpc"
    cidr    = "172.16.0.0/16"
    region  = "ap-guangzhou"
    
    subnets = [
      {
        subnet_name = "prod-subnet-1"
        cidr_block  = "172.16.1.0/24"
        zone        = "ap-guangzhou-3"
      }
    ]
  }
}
```

### 示例三：仅配置标签和联系人

```hcl
module "account_baselines_tags" {
  source = "./modules/account-baselines"

  baseline_name = "tagging-baseline"
  
  member_list = [
    { member_uin = 1000001 }
  ]

  # 预设标签
  tag_info = {
    enabled = true
    tags = [
      {
        Key    = "Environment"
        Values = ["Production"]
      },
      {
        Key    = "CostCenter"
        Values = ["IT", "Platform"]
      }
    ]
  }

  # 账号联系人
  account_contact = {
    enabled = true
    contacts = [
      {
        name         = "李四"
        phone_num    = "13900139000"
        email        = "ops@example.com"
        remark       = "运维负责人"
        country_code = "86"
      }
    ]
  }
}
```

---

## 配置说明

### 成员账号识别逻辑

```
成员账号识别流程：
┌─────────────────────────────────────┐
│  var.member_list 配置检查           │
│         │                           │
│   成员同时提供 UIN 和名称 → 优先使用 UIN │
│   仅提供 UIN        → 使用 UIN        │
│   仅提供名称        → 查询组织获取 UIN  │
└─────────────────────────────────────┘
```

### 基线配置启用逻辑

```hcl
# 每个基线配置项都包含 enabled 标志
baseline_items = concat(
  var.cam_password.enabled ? [配置项] : [],
  var.cam_security.enabled ? [配置项] : [],
  # ... 其他配置项
)
```

> 只有当 `enabled = true` 时，对应的基线配置才会被创建和应用

### 资源依赖关系

```
tencentcloud_account_baseline_config (基线配置创建)
          │
          │ depends_on
          ▼
tencentcloud_account_baseline_batch_apply (批量应用到成员账号)
          │
          │ count = length(member_list) > 0 ? 1 : 0
          ▼
     有成员时创建，无成员时跳过
```

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **权限要求**
   - 执行本模块需要**组织管理员权限**和相应的产品权限
   - 确保Provider配置的密钥具有足够权限

2. **成员账号要求**
   - 目标成员账号必须已创建并加入腾讯云组织
   - 成员账号UIN和名称至少提供一个

3. **配置生效时间**
   - 基线配置创建后需要一定时间才能生效到所有成员账号
   - 批量应用操作是异步执行的

4. **MFA策略限制**
   - `security_mfa_action_strategy` 目前仅支持值 `2`（用户选择）
   - `security_mfa_login_strategy` 支持 `1`（强制）和 `2`（用户选择）

5. **密码策略限制**
   - 密码最小长度：1-32字符
   - 强制变更周期：0-365天（0表示无限制）
   - 重用限制：0-24次（0表示无限制）

6. **网络配置**
   - VPC和子网配置会在指定地域创建实际的网络资源
   - 安全组规则会应用到指定地域

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=The current account is not the organization administrator
```

**原因**：执行账号不是组织管理员或缺少相应权限
**解决方案**：
- 确认Provider配置的密钥属于组织管理员账号
- 检查CAM策略是否包含所需权限

#### 错误二：成员账号不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Member not found
```

**原因**：指定的成员UIN或名称在组织中不存在
**解决方案**：
```bash
# 查询组织成员列表确认UIN和名称
terraform console
> data.tencentcloud_organization_members.members.items
```

#### 错误三：地域不支持

```
Error: [TencentCloudSDKError] Code=InvalidParameterValue
Message=Region not supported
```

**原因**：指定的地域不在支持列表中
**解决方案**：
```bash
# 查询支持的地域列表
terraform console  
> data.tencentcloud_regions.regions.region_list
```

#### 错误四：配置验证失败

```
Error: Validation failed for variable
Message=security_mfa_login_strategy must be 1 or 2
```

**原因**：变量值不符合验证条件
**解决方案**：
- 检查变量值是否在允许范围内
- 参考变量说明中的有效值范围

#### 错误五：批量应用超时

**现象**：基线配置创建成功，但批量应用状态长时间未完成
**原因**：批量应用到大量账号需要较长时间
**解决方案**：
- 等待异步操作完成（通常需要几分钟到几十分钟）
- 通过腾讯云控制台查看批量应用状态
- 分批应用减少单次操作量