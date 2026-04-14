# 腾讯云组织合规性预防控制模块

## 模块概述

本模块用于在腾讯云TCO（Tencent Cloud Organization）中创建和管理服务控制策略（Service Control Policy），实现组织级别的合规性预防控制，主要功能包括：

- **策略配置管理** - 启用和配置组织级别的服务控制策略
- **策略文件管理** - 基于JSON策略文件创建服务控制策略
- **多目标绑定** - 支持将策略绑定到组织节点（部门）和成员
- **自动发现** - 自动发现组织结构和成员信息
- **依赖管理** - 自动处理策略配置、创建和绑定的依赖关系

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
| `QcloudOrganizationFullAccess` | 组织管理全权限 |
| `QcloudCamFullAccess` | CAM权限管理全权限 |

### 其他要求

- 需要提前创建好腾讯云组织（TCO）
- 需要获取组织ID（organization_id）
- 需要准备好服务控制策略JSON文件
- 需要了解组织结构和成员信息

---

## 变量说明

### 主要配置变量

| 变量名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| `organization_id` | `string` | 是 | 组织ID |

### 服务控制策略配置变量

| 变量名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| `org_service_policies` | `list(object)` | 是 | 组织管理策略配置列表 |
| `↳ name` | `string` | 是 | 策略名称（1-128字符，支持中文、英文、数字、下划线） |
| `↳ path` | `string` | 是 | 策略文件路径 |
| `↳ description` | `string` | 否 | 策略描述 |
| `↳ targets` | `list(object)` | 是 | 策略绑定目标列表 |
| `↳↳ target_id` | `number` | 否 | 绑定目标ID（成员Uin或部门ID） |
| `↳↳ target_name` | `string` | 否 | 绑定目标名称（成员名称或部门名称） |
| `↳↳ target_type` | `string` | 是 | 目标类型（NODE: 部门, MEMBER: 成员） |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 组织ID配置
organization_id = "org-xxxxxx"

# 服务控制策略配置
org_service_policies = [
  {
    name        = "deny-high-risk-services"
    path        = "./policies/deny-high-risk-services.json"
    description = "禁止使用高风险云服务"
    
    targets = [
      {
        target_name = "研发部"
        target_type = "NODE"
      },
      {
        target_name = "测试部"
        target_type = "NODE"
      }
    ]
  },
  {
    name        = "require-mfa"
    path        = "./policies/require-mfa.json"
    description = "要求所有操作启用MFA"
    
    targets = [
      {
        target_name = "所有成员"
        target_type = "MEMBER"
      }
    ]
  },
  {
    name        = "region-restriction"
    path        = "./policies/region-restriction.json"
    description = "限制资源创建区域"
    
    targets = [
      {
        target_id   = 100000000001  # 部门ID
        target_type = "NODE"
      },
      {
        target_id   = 200000000001  # 成员Uin
        target_type = "MEMBER"
      }
    ]
  }
]
```

### 简单配置示例

```hcl
# 基础配置示例
organization_id = "your-organization-id"

org_service_policies = [
  {
    name        = "basic-compliance"
    path        = "./compliance-policy.json"
    description = "基础合规策略"
    
    targets = [
      {
        target_name = "所有部门"
        target_type = "NODE"
      }
    ]
  }
]
```

---

## 使用示例

### 示例一：高风险服务禁止策略

```hcl
# 禁止研发部门使用高风险服务
org_service_policies = [
  {
    name        = "deny-high-risk-services"
    path        = "./policies/deny-high-risk.json"
    description = "禁止使用加密货币挖矿、DDoS攻击等高风险服务"
    
    targets = [
      {
        target_name = "研发部"
        target_type = "NODE"
      },
      {
        target_name = "测试部"
        target_type = "NODE"
      }
    ]
  }
]
```

**策略文件示例 (deny-high-risk.json):**
```json
{
  "version": "2.0",
  "statement": [
    {
      "effect": "deny",
      "action": [
        "cvm:RunInstances",
        "vpc:CreateNatGateway",
        "vpc:CreateDirectConnectGateway"
      ],
      "resource": "*",
      "condition": {
        "string_equal": {
          "cvm:InstanceType": ["cryptocurrency-mining", "ddos-attack"]
        }
      }
    }
  ]
}
```

### 示例二：MFA强制要求策略

```hcl
# 要求所有成员启用MFA
org_service_policies = [
  {
    name        = "require-mfa-global"
    path        = "./policies/require-mfa.json"
    description = "全局MFA要求策略"
    
    targets = [
      {
        target_name = "所有成员"
        target_type = "MEMBER"
      }
    ]
  }
]
```

**策略文件示例 (require-mfa.json):**
```json
{
  "version": "2.0",
  "statement": [
    {
      "effect": "deny",
      "action": "*",
      "resource": "*",
      "condition": {
        "null": {
          "mfa": "true"
        }
      }
    }
  ]
}
```

### 示例三：区域限制策略

```hcl
# 限制财务部门只能在特定区域创建资源
org_service_policies = [
  {
    name        = "region-restriction-finance"
    path        = "./policies/region-restriction.json"
    description = "财务部门区域限制策略"
    
    targets = [
      {
        target_name = "财务部"
        target_type = "NODE"
      }
    ]
  }
]
```

**策略文件示例 (region-restriction.json):**
```json
{
  "version": "2.0",
  "statement": [
    {
      "effect": "deny",
      "action": [
        "cvm:RunInstances",
        "vpc:CreateVpc",
        "cos:PutBucket"
      ],
      "resource": "*",
      "condition": {
        "string_not_equal": {
          "cvm:Region": ["ap-beijing", "ap-shanghai"]
        }
      }
    }
  ]
}
```

### 示例四：多策略组合配置

```hcl
# 组合多个合规策略
org_service_policies = [
  {
    name        = "security-baseline"
    path        = "./policies/security-baseline.json"
    description = "安全基线策略"
    
    targets = [
      {
        target_name = "所有部门"
        target_type = "NODE"
      }
    ]
  },
  {
    name        = "data-protection"
    path        = "./policies/data-protection.json"
    description = "数据保护策略"
    
    targets = [
      {
        target_name = "数据部"
        target_type = "NODE"
      },
      {
        target_name = "研发部"
        target_type = "NODE"
      }
    ]
  },
  {
    name        = "compliance-audit"
    path        = "./policies/compliance-audit.json"
    description = "合规审计策略"
    
    targets = [
      {
        target_name = "审计部"
        target_type = "NODE"
      }
    ]
  }
]
```

---

## 配置说明

### 策略执行流程

```
策略执行流程：
┌─────────────────────────────────────┐
│  1. 启用服务控制策略配置            │
│         │                           │
│  2. 创建服务控制策略                │
│         │                           │
│  3. 绑定策略到目标（部门/成员）     │
│         │                           │
│  4. 策略生效，开始执行访问控制      │
└─────────────────────────────────────┘
```

### 目标类型说明

| 目标类型 | 说明 | 标识方式 |
|----------|------|----------|
| **NODE** | 组织节点（部门） | 部门ID或部门名称 |
| **MEMBER** | 组织成员 | 成员Uin或成员名称 |

### 策略文件格式要求

- **版本**: 必须为 `"2.0"`
- **Effect**: 支持 `"allow"` 或 `"deny"`
- **Action**: 支持具体操作或通配符
- **Resource**: 支持具体资源或通配符
- **Condition**: 支持各种条件表达式

### 自动发现机制

模块会自动发现以下信息：
- 组织节点结构及对应ID
- 组织成员列表及对应Uin
- 支持通过名称自动解析为ID

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **权限配置**
   - 确保执行账号具有组织管理相关权限
   - 需要`QcloudOrganizationFullAccess`权限

2. **组织ID获取**
   - 需要提前创建腾讯云组织
   - 组织ID可以通过控制台或API获取

3. **策略文件验证**
   - 策略JSON文件必须符合TCO策略语法
   - 建议先在控制台测试策略效果

4. **目标绑定**
   - 支持通过名称或ID指定目标
   - 名称和ID不能同时为空
   - 如果同时提供，优先使用ID

5. **依赖关系**
   - 策略配置 → 策略创建 → 策略绑定
   - 模块自动处理依赖关系

6. **策略限制**
   - 每个组织最多可创建1000条策略
   - 策略名称不能重复
   - 策略内容有大小限制

7. **生效时间**
   - 策略创建后需要时间生效
   - 建议先在小范围测试

8. **回滚策略**
   - 建议保留策略历史版本
   - 重大变更前做好备份

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少组织管理权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含`QcloudOrganizationFullAccess`权限

#### 错误二：组织不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Organization not found
```

**原因**：指定的组织ID不存在
**解决方案**：
- 确认组织ID正确
- 检查组织是否已被删除

#### 错误三：策略文件错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid policy content
```

**原因**：策略文件格式或语法错误
**解决方案**：
- 检查策略JSON格式是否正确
- 验证策略语法是否符合TCO要求
- 使用控制台策略编辑器验证

#### 错误四：目标不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Target not found
```

**原因**：指定的目标（部门或成员）不存在
**解决方案**：
- 确认目标名称或ID正确
- 检查目标是否已被删除
- 使用自动发现功能验证目标存在

#### 错误五：策略数量超限

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Policy count exceeds limit
```

**原因**：策略数量超过组织限制
**解决方案**：
- 删除不再使用的策略
- 合并相似策略
- 联系腾讯云提升配额

#### 错误六：策略名称重复

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy name already exists
```

**原因**：策略名称已存在
**解决方案**：
- 使用唯一的策略名称
- 检查是否已有同名策略
- 添加前缀或后缀区分