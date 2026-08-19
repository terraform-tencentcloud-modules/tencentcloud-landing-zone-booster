# 腾讯云组织身份管理模块

## 模块概述

本模块用于在腾讯云中创建和管理组织身份（Org Identity）以及成员身份授权，实现基于角色的访问控制（RBAC），主要功能包括：

- **组织身份创建** - 批量创建组织身份（Org Identity）
- **策略管理** - 支持预设策略和自定义策略配置
- **成员授权** - 为组织成员分配身份权限
- **自动成员识别** - 支持通过成员UIN或名称进行成员识别
- **身份ID映射** - 输出身份名称到ID的映射关系
- **依赖管理** - 自动处理模块间的依赖关系
- **批量操作** - 支持一次性配置多个身份策略

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
| `QcloudCamFullAccess` | 访问管理全权限 |
| `QcloudOrganizationReadOnlyAccess` | 组织只读访问权限 |

### 其他要求

- 需要了解腾讯云组织架构
- 需要规划好身份命名规范
- 需要确定成员访问控制策略
- 需要了解预设策略和自定义策略的区别
- 需要收集成员UIN或名称信息

---

## 变量说明

### 主要配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `assume_role_policies` | `list(object)` | 是 | - | 身份策略配置列表 |

### 身份策略对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `assume_role_name` | `string` | 是 | - | 身份别名名称 |
| `description` | `string` | 否 | - | 身份描述信息 |
| `policies` | `list(object)` | 是 | - | 策略配置列表 |
| `members` | `list(object)` | 是 | - | 成员配置列表 |

### 策略对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `policy_id` | `number` | 条件必填 | - | CAM预设策略ID（PolicyType=2时必填） |
| `policy_name` | `string` | 条件必填 | - | CAM预设策略名称（PolicyType=2时必填） |
| `policy_type` | `number` | 否 | `2` | 策略类型：`1`-自定义策略，`2`-预设策略 |
| `policy_document` | `string` | 条件必填 | - | 自定义策略内容（PolicyType=1时必填） |

### 成员对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `member_uin` | `number` | 条件必填 | - | 成员UIN（与member_name二选一） |
| `member_name` | `string` | 条件必填 | - | 成员名称（与member_uin二选一） |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 基础身份策略配置
assume_role_policies = [
  {
    assume_role_name = "admin-role"
    description      = "Administrator role with full access"
    
    # 策略配置 - 使用预设策略
    policies = [
      {
        policy_type = 2  # 预设策略
        policy_name = "QcloudCamFullAccess"  # 访问管理全权限
      },
      {
        policy_type = 2  # 预设策略
        policy_name = "QcloudOrganizationFullAccess"  # 组织管理全权限
      }
    ]
    
    # 成员配置 - 使用成员UIN
    members = [
      {
        member_uin = 100000000001  # 管理员用户UIN
      },
      {
        member_uin = 100000000002  # 备份管理员UIN
      }
    ]
  },
  
  {
    assume_role_name = "developer-role"
    description      = "Developer role with limited access"
    
    # 策略配置 - 混合使用预设和自定义策略
    policies = [
      {
        policy_type = 2  # 预设策略
        policy_name = "QcloudCamReadOnlyAccess"  # 访问管理只读权限
      },
      {
        policy_type = 1  # 自定义策略
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cvm:DescribeInstances",
                "cvm:RunInstances",
                "cvm:TerminateInstances"
              ],
              "resource": "*"
            }
          ]
        }
        EOT
      }
    ]
    
    # 成员配置 - 使用成员名称
    members = [
      {
        member_name = "developer-user1"  # 开发用户1
      },
      {
        member_name = "developer-user2"  # 开发用户2
      }
    ]
  },
  
  {
    assume_role_name = "audit-role"
    description      = "Audit role with read-only access"
    
    # 策略配置 - 只读权限
    policies = [
      {
        policy_type = 2  # 预设策略
        policy_name = "QcloudCamReadOnlyAccess"  # 访问管理只读权限
      },
      {
        policy_type = 2  # 预设策略
        policy_name = "QcloudOrganizationReadOnlyAccess"  # 组织只读权限
      }
    ]
    
    # 成员配置 - 混合使用UIN和名称
    members = [
      {
        member_uin = 100000000003  # 审计员UIN
      },
      {
        member_name = "audit-user"  # 审计用户
      }
    ]
  }
]
```

### 多环境配置示例

```hcl
# 多环境身份策略配置
assume_role_policies = [
  # 开发环境角色
  {
    assume_role_name = "dev-developer"
    description      = "Developer role for development environment"
    
    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cvm:*",
                "vpc:*",
                "clb:*"
              ],
              "resource": [
                "qcs::cvm:ap-guangzhou::instance/*",
                "qcs::vpc:ap-guangzhou::vpc/*",
                "qcs::clb:ap-guangzhou::clb/*"
              ]
            }
          ]
        }
        EOT
      }
    ]
    
    members = [
      {
        member_name = "dev-user1"
      },
      {
        member_name = "dev-user2"
      }
    ]
  },
  
  # 测试环境角色
  {
    assume_role_name = "test-tester"
    description      = "Tester role for testing environment"
    
    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cvm:Describe*",
                "vpc:Describe*",
                "clb:Describe*"
              ],
              "resource": "*"
            },
            {
              "effect": "allow",
              "action": [
                "cvm:RunInstances",
                "cvm:TerminateInstances"
              ],
              "resource": "qcs::cvm:ap-shanghai::instance/*"
            }
          ]
        }
        EOT
      }
    ]
    
    members = [
      {
        member_name = "test-user1"
      },
      {
        member_name = "test-user2"
      }
    ]
  },
  
  # 生产环境角色
  {
    assume_role_name = "prod-operator"
    description      = "Operator role for production environment"
    
    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cvm:Describe*",
                "vpc:Describe*",
                "clb:Describe*"
              ],
              "resource": "*"
            },
            {
              "effect": "allow",
              "action": [
                "cvm:RunInstances",
                "cvm:StopInstances",
                "cvm:StartInstances"
              ],
              "resource": "qcs::cvm:ap-beijing::instance/*",
              "condition": {
                "string_equal": {
                  "cvm:ResourceTag/Environment": "production"
                }
              }
            }
          ]
        }
        EOT
      }
    ]
    
    members = [
      {
        member_uin = 100000000004  # 生产操作员UIN
      },
      {
        member_name = "prod-backup"  # 生产备份用户
      }
    ]
  }
]
```

### 精细权限配置示例

```hcl
# 精细权限身份策略配置
assume_role_policies = [
  {
    assume_role_name = "network-admin"
    description      = "Network administrator role"
    
    policies = [
      {
        policy_type = 2
        policy_name = "QcloudVPCFullAccess"  # VPC全权限
      },
      {
        policy_type = 2
        policy_name = "QcloudEIPFullAccess"   # 弹性公网IP全权限
      },
      {
        policy_type = 2
        policy_name = "QcloudCLBFullAccess"   # 负载均衡全权限
      }
    ]
    
    members = [
      {
        member_name = "network-admin1"
      }
    ]
  },
  
  {
    assume_role_name = "database-admin"
    description      = "Database administrator role"
    
    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCDBFullAccess"    # 云数据库全权限
      },
      {
        policy_type = 2
        policy_name = "QcloudRedisFullAccess"   # Redis全权限
      },
      {
        policy_type = 2
        policy_name = "QcloudMongoDBFullAccess" # MongoDB全权限
      }
    ]
    
    members = [
      {
        member_name = "db-admin1"
      }
    ]
  },
  
  {
    assume_role_name = "security-auditor"
    description      = "Security auditor role"
    
    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"       # 访问管理只读
      },
      {
        policy_type = 2
        policy_name = "QcloudOrganizationReadOnlyAccess" # 组织只读
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cam:Get*",
                "cam:List*",
                "organization:Get*",
                "organization:List*"
              ],
              "resource": "*"
            }
          ]
        }
        EOT
      }
    ]
    
    members = [
      {
        member_name = "security-auditor1"
      }
    ]
  }
]
```

---

## 使用示例

### 示例一：基础管理角色

```hcl
# 基础管理角色配置
assume_role_policies = [
  {
    assume_role_name = "system-administrator"
    description      = "System administrator with full organization access"
    
    policies = [
      {
        policy_type = 2
        policy_name = "QcloudOrganizationFullAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudCamFullAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudFinanceFullAccess"
      }
    ]
    
    members = [
      {
        member_uin = 100000000001  # 系统管理员
      }
    ]
  }
]
```

### 示例二：项目开发角色

```hcl
# 项目开发角色配置
assume_role_policies = [
  {
    assume_role_name = "project-developer"
    description      = "Developer role for specific project access"
    
    policies = [
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "cvm:*",
                "vpc:*",
                "clb:*"
              ],
              "resource": [
                "qcs::cvm:ap-guangzhou::instance/*",
                "qcs::vpc:ap-guangzhou::vpc/*",
                "qcs::clb:ap-guangzhou::clb/*"
              ],
              "condition": {
                "string_equal": {
                  "cvm:ResourceTag/Project": "my-project"
                }
              }
            }
          ]
        }
        EOT
      }
    ]
    
    members = [
      {
        member_name = "dev-john"
      },
      {
        member_name = "dev-jane"
      }
    ]
  }
]
```

### 示例三：财务审计角色

```hcl
# 财务审计角色配置
assume_role_policies = [
  {
    assume_role_name = "finance-auditor"
    description      = "Finance auditor with billing and cost access"
    
    policies = [
      {
        policy_type = 2
        policy_name = "QcloudFinanceReadOnlyAccess"
      },
      {
        policy_type = 2
        policy_name = "QcloudCamReadOnlyAccess"
      },
      {
        policy_type = 1
        policy_document = <<-EOT
        {
          "version": "2.0",
          "statement": [
            {
              "effect": "allow",
              "action": [
                "finance:Describe*",
                "finance:Get*"
              ],
              "resource": "*"
            }
          ]
        }
        EOT
      }
    ]
    
    members = [
      {
        member_uin = 100000000005  # 财务审计员
      }
    ]
  }
]
```

---

## 配置说明

### 策略类型说明

| 策略类型 | 值 | 说明 | 必填字段 |
|----------|----|------|----------|
| **预设策略** | `2` | 腾讯云预定义的策略模板 | `policy_name` 或 `policy_id` |
| **自定义策略** | `1` | 用户自定义的JSON策略文档 | `policy_document` |

### 成员识别说明

成员可以通过以下两种方式识别：
- **member_uin** - 成员的用户唯一标识符（UIN）
- **member_name** - 成员的名称（模块会自动查询对应的UIN）

**注意**：两种方式只能选择一种，不能同时设置。

### 预设策略参考

常用预设策略名称：
- `QcloudOrganizationFullAccess` - 组织管理全权限
- `QcloudOrganizationReadOnlyAccess` - 组织只读权限
- `QcloudCamFullAccess` - 访问管理全权限
- `QcloudCamReadOnlyAccess` - 访问管理只读权限
- `QcloudVPCFullAccess` - VPC全权限
- `QcloudCVMFullAccess` - 云服务器全权限
- `QcloudCDBFullAccess` - 云数据库全权限
- `QcloudFinanceFullAccess` - 财务管理全权限
- `QcloudFinanceReadOnlyAccess` - 财务只读权限

### 输出说明

模块输出身份名称到ID的映射关系：
```hcl
identity_ids = {
  "admin-role"       = "org-identity-12345678"
  "developer-role"   = "org-identity-87654321"
  "audit-role"       = "org-identity-abcdefgh"
}
```

### 依赖关系说明

模块内部自动处理以下依赖关系：
1. 首先查询组织成员信息
2. 然后创建组织身份
3. 最后进行成员身份授权
4. 确保身份创建完成后才进行授权操作

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **权限规划**
   - 遵循最小权限原则
   - 仔细规划身份和策略配置
   - 避免过度授权

2. **成员识别**
   - 确保成员UIN或名称正确
   - 成员必须存在于组织中
   - 建议使用UIN进行精确识别

3. **策略配置**
   - 预设策略和自定义策略不能混用同一策略对象
   - 自定义策略必须符合CAM策略语法
   - 验证策略文档的JSON格式正确性

4. **依赖管理**
   - 模块自动处理创建和授权的依赖关系
   - 确保组织成员数据可正常获取
   - 监控创建过程中的依赖错误

5. **命名规范**
   - 使用有意义的身份名称
   - 遵循统一的命名约定
   - 避免使用特殊字符

6. **测试验证**
   - 在非生产环境测试配置
   - 验证权限是否按预期工作
   - 测试成员能否正常担任身份

7. **变更管理**
   - 记录所有身份策略变更
   - 制定回滚计划
   - 通知受影响成员

8. **监控审计**
   - 启用组织操作日志
   - 定期审计身份使用情况
   - 监控异常权限使用

---

## 故障排除

### 常见错误及解决方案

#### 错误一：成员不存在

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Member not found
```

**原因**：指定的成员UIN或名称不存在
**解决方案**：
- 确认成员UIN正确
- 检查成员名称拼写
- 验证成员是否在组织中

#### 错误二：策略不存在

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy not found
```

**原因**：指定的预设策略不存在
**解决方案**：
- 确认策略名称正确
- 检查策略是否可用
- 验证权限是否包含策略访问

#### 错误三：策略语法错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid policy document
```

**原因**：自定义策略文档格式错误
**解决方案**：
- 验证JSON格式正确性
- 检查策略语法是否符合CAM要求
- 使用在线JSON验证工具

#### 错误四：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少组织管理权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含组织管理权限
- 验证项目权限

#### 错误五：配额限制

```
Error: [TencentCloudSDKError] Code=QuotaExceeded
Message=Identity quota exceeded
```

**原因**：达到身份或策略配额限制
**解决方案**：
- 检查身份和策略配额
- 申请提高配额或删除无用资源
- 合并相似的身份配置

#### 错误六：依赖错误

```
Error: [TencentCloudSDKError] Code=DependencyViolation
Message=Cannot authorize before identity creation
```

**原因**：授权操作在身份创建之前执行
**解决方案**：
- 确保依赖关系正确配置
- 检查depends_on设置
- 重新运行terraform apply