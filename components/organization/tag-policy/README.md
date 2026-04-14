# 腾讯云标签策略管理模块

## 模块概述

本模块用于在腾讯云中统一管理组织级别的标签策略，实现标签规范的自动化管理和强制执行，主要功能包括：

- **标签策略创建** - 创建统一的标签管理策略
- **多目标绑定** - 支持部门和成员级别的策略绑定
- **自动映射** - 自动处理名称到ID的映射关系
- **策略启用** - 自动启用标签策略功能
- **批量管理** - 支持批量创建和管理多个策略
- **灵活配置** - 支持多种配置方式满足不同场景需求
- **依赖处理** - 自动处理策略间的依赖关系
- **统一管控** - 实现组织内标签规范的统一管理

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
| `QcloudTagFullAccess` | 标签管理全权限 |
| `QcloudFinanceFullAccess` | 财务管理全权限 |

### 其他要求

- 需要了解腾讯云组织架构和标签策略规范
- 需要规划好标签策略的管控范围
- 需要确定策略绑定目标和级别
- 需要准备标签策略文件内容
- 需要了解策略的生效机制
- 需要收集目标ID或准确名称

---

## 变量说明

### 主要配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `organization_id` | `string` | 是 | - | 组织ID |
| `org_tag_policies` | `list(object)` | 是 | - | 标签策略配置列表 |

### 标签策略对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `name` | `string` | 是 | - | 策略名称（1-128字符，支持中文、英文、数字、下划线） |
| `path` | `string` | 是 | - | 策略文件路径 |
| `description` | `string` | 否 | `null` | 策略描述 |
| `targets` | `list(object)` | 是 | - | 策略绑定目标列表 |

### 目标对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `target_id` | `number` | 条件 | `null` | 目标ID（部门ID或成员UIN，与target_name二选一） |
| `target_name` | `string` | 条件 | `null` | 目标名称（部门名称或成员名称，与target_id二选一） |
| `target_type` | `string` | 是 | - | 目标类型：`NODE`-部门，`MEMBER`-成员 |

### 目标类型说明

| 目标类型 | 说明 | 适用场景 | 管理范围 |
|----------|------|----------|----------|
| **NODE** | 部门级别 | 整个部门统一标签规范 | 部门下所有成员和资源 |
| **MEMBER** | 成员级别 | 特定成员标签规范 | 指定成员的所有资源 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 组织ID配置
organization_id = "org-123456789"

# 部门级别标签策略配置
org_tag_policies = [
  # 开发部门标签策略
  {
    name        = "dev-department-tag-policy"
    path        = "./policies/dev-tags.json"
    description = "开发部门统一标签规范"
    targets = [
      {
        target_name = "开发部"           # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "测试部"           # 部门名称  
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 生产环境标签策略
  {
    name        = "prod-environment-tag-policy"
    path        = "./policies/prod-tags.json"
    description = "生产环境资源标签规范"
    targets = [
      {
        target_name = "生产部"           # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "运维部"           # 部门名称
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 财务相关标签策略
  {
    name        = "finance-tag-policy"
    path        = "./policies/finance-tags.json"
    description = "财务成本中心标签规范"
    targets = [
      {
        target_name = "财务部"           # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "采购部"           # 部门名称
        target_type = "NODE"            # 部门级别
      }
    ]
  }
]
```

### 混合目标类型配置示例

```hcl
# 组织ID配置
organization_id = "org-987654321"

# 混合部门和个人级别的标签策略
org_tag_policies = [
  # 技术团队统一标签策略
  {
    name        = "tech-team-tag-policy"
    path        = "./policies/tech-tags.json"
    description = "技术团队资源标签规范"
    targets = [
      {
        target_name = "技术中心"         # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "研发部"           # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "架构师团队"        # 部门名称
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 关键人员特殊标签策略
  {
    name        = "key-personnel-tag-policy"
    path        = "./policies/key-personnel-tags.json"
    description = "关键人员资源标签规范"
    targets = [
      {
        target_name = "技术总监"         # 成员名称
        target_type = "MEMBER"           # 成员级别
      },
      {
        target_name = "安全负责人"        # 成员名称
        target_type = "MEMBER"           # 成员级别
      },
      {
        target_name = "财务总监"         # 成员名称
        target_type = "MEMBER"           # 成员级别
      }
    ]
  },
  
  # 合规审计标签策略
  {
    name        = "compliance-tag-policy"
    path        = "./policies/compliance-tags.json"
    description = "合规审计标签规范"
    targets = [
      {
        target_name = "合规部"           # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "审计专员"         # 成员名称
        target_type = "MEMBER"           # 成员级别
      },
      {
        target_name = "风险控制"         # 部门名称
        target_type = "NODE"            # 部门级别
      }
    ]
  }
]
```

### 使用目标ID配置示例

```hcl
# 组织ID配置
organization_id = "org-555555555"

# 使用目标ID进行精确配置
org_tag_policies = [
  # 开发环境标签策略
  {
    name        = "dev-env-tag-policy"
    path        = "./policies/dev-env-tags.json"
    description = "开发环境资源标签规范"
    targets = [
      {
        target_id   = 1001              # 开发部ID
        target_type = "NODE"            # 部门级别
      },
      {
        target_id   = 1002              # 测试部ID
        target_type = "NODE"            # 部门级别
      },
      {
        target_id   = 1003              # 预发布部ID
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 生产环境标签策略
  {
    name        = "prod-env-tag-policy"
    path        = "./policies/prod-env-tags.json"
    description = "生产环境资源标签规范"
    targets = [
      {
        target_id   = 2001              # 生产部ID
        target_type = "NODE"            # 部门级别
      },
      {
        target_id   = 2002              # 运维部ID
        target_type = "NODE"            # 部门级别
      },
      {
        target_id   = 2003              # 监控部ID
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 管理人员标签策略
  {
    name        = "management-tag-policy"
    path        = "./policies/management-tags.json"
    description = "管理人员资源标签规范"
    targets = [
      {
        target_id   = 3001              # 技术总监UIN
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_id   = 3002              # 产品总监UIN
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_id   = 3003              # 运营总监UIN
        target_type = "MEMBER"          # 成员级别
      }
    ]
  }
]
```

### 企业级标签策略配置

```hcl
# 组织ID配置
organization_id = "org-999999999"

# 企业级精细化标签策略管理
org_tag_policies = [
  # 成本中心标签策略
  {
    name        = "cost-center-tag-policy"
    path        = "./policies/cost-center-tags.json"
    description = "成本中心资源标签规范"
    targets = [
      {
        target_name = "财务中心"         # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "采购中心"         # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "预算管理"         # 部门名称
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 项目组标签策略
  {
    name        = "project-team-tag-policy"
    path        = "./policies/project-team-tags.json"
    description = "项目组资源标签规范"
    targets = [
      {
        target_name = "项目A组"          # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "项目B组"          # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "项目C组"          # 部门名称
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 环境标签策略
  {
    name        = "environment-tag-policy"
    path        = "./policies/environment-tags.json"
    description = "环境资源标签规范"
    targets = [
      {
        target_name = "开发环境"         # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "测试环境"         # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "生产环境"         # 部门名称
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 合规审计标签策略
  {
    name        = "compliance-audit-tag-policy"
    path        = "./policies/compliance-audit-tags.json"
    description = "合规审计标签规范"
    targets = [
      {
        target_name = "合规部"           # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "审计部"           # 部门名称
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "风控部"           # 部门名称
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 管理人员标签策略
  {
    name        = "executive-tag-policy"
    path        = "./policies/executive-tags.json"
    description = "管理人员资源标签规范"
    targets = [
      {
        target_name = "CEO"             # 成员名称
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_name = "CTO"             # 成员名称
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_name = "CFO"             # 成员名称
        target_type = "MEMBER"          # 成员级别
      }
    ]
  }
]
```

---

## 使用示例

### 示例一：部门级别标签策略

```hcl
# 部门统一标签策略配置
org_tag_policies = [
  # 技术部门标签规范
  {
    name        = "technology-department-tags"
    path        = "./policies/tech-dept-tags.json"
    description = "技术部门资源标签统一规范"
    targets = [
      {
        target_name = "研发中心"         # 研发部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "质量保障"         # 测试部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "技术支持"         # 运维部门
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 业务部门标签规范
  {
    name        = "business-department-tags"
    path        = "./policies/business-dept-tags.json"
    description = "业务部门资源标签统一规范"
    targets = [
      {
        target_name = "销售部"           # 销售部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "市场部"           # 市场部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "客户成功"         # 客户服务部门
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 支持部门标签规范
  {
    name        = "support-department-tags"
    path        = "./policies/support-dept-tags.json"
    description = "支持部门资源标签统一规范"
    targets = [
      {
        target_name = "人力资源"         # HR部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "行政后勤"         # 行政部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "IT支持"          # IT支持部门
        target_type = "NODE"            # 部门级别
      }
    ]
  }
]
```

### 示例二：成员级别标签策略

```hcl
# 成员个人标签策略配置
org_tag_policies = [
  # 开发人员标签规范
  {
    name        = "developer-tags"
    path        = "./policies/developer-tags.json"
    description = "开发人员资源标签规范"
    targets = [
      {
        target_name = "张三"             # 后端开发
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_name = "李四"             # 前端开发
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_name = "王五"             # 全栈开发
        target_type = "MEMBER"          # 成员级别
      }
    ]
  },
  
  # 运维人员标签规范
  {
    name        = "operations-tags"
    path        = "./policies/operations-tags.json"
    description = "运维人员资源标签规范"
    targets = [
      {
        target_name = "赵六"             # 系统运维
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_name = "钱七"             # 网络运维
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_name = "孙八"             # 安全运维
        target_type = "MEMBER"          # 成员级别
      }
    ]
  },
  
  # 管理人员标签规范
  {
    name        = "management-tags"
    path        = "./policies/management-tags.json"
    description = "管理人员资源标签规范"
    targets = [
      {
        target_name = "周九"             # 技术总监
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_name = "吴十"             # 产品总监
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_name = "郑十一"           # 运营总监
        target_type = "MEMBER"          # 成员级别
      }
    ]
  }
]
```

### 示例三：混合级别标签策略

```hcl
# 混合部门和成员级别的标签策略
org_tag_policies = [
  # 项目组级别标签规范
  {
    name        = "project-group-tags"
    path        = "./policies/project-group-tags.json"
    description = "项目组资源标签规范"
    targets = [
      {
        target_name = "电商项目组"        # 项目部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "金融项目组"        # 项目部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "教育项目组"        # 项目部门
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 环境级别标签规范
  {
    name        = "environment-tags"
    path        = "./policies/environment-tags.json"
    description = "环境资源标签规范"
    targets = [
      {
        target_name = "开发环境组"        # 环境部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "测试环境组"        # 环境部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "生产环境组"        # 环境部门
        target_type = "NODE"            # 部门级别
      }
    ]
  },
  
  # 关键人员标签规范
  {
    name        = "key-personnel-tags"
    path        = "./policies/key-personnel-tags.json"
    description = "关键人员资源标签规范"
    targets = [
      {
        target_name = "架构师团队"        # 架构部门
        target_type = "NODE"            # 部门级别
      },
      {
        target_name = "首席架构师"        # 关键人员
        target_type = "MEMBER"          # 成员级别
      },
      {
        target_name = "安全专家"         # 关键人员
        target_type = "MEMBER"          # 成员级别
      }
    ]
  }
]
```

---

## 配置说明

### 目标识别方式

模块支持两种目标识别方式：

1. **通过目标名称识别**
   - 使用`target_name`字段指定目标名称
   - 模块自动查询并映射到对应的目标ID
   - 适合名称已知但ID未知的场景
   - 需要确保目标名称在组织中唯一

2. **通过目标ID识别**
   - 使用`target_id`字段指定目标ID
   - 直接使用指定的ID进行绑定
   - 适合ID已知且需要精确控制的场景
   - 需要确保ID正确且目标存在

### 策略级别说明

| 策略级别 | 管理范围 | 适用场景 | 优势 |
|----------|----------|----------|------|
| **部门级别** | 整个部门 | 统一部门标签规范 | 批量管理，一致性高 |
| **成员级别** | 单个成员 | 个性化标签要求 | 精细控制，灵活性高 |

### 自动映射机制

模块内置自动映射功能：
- 自动查询组织中所有部门信息
- 自动查询组织中所有成员信息
- 建立名称到ID的映射表
- 支持动态解析目标名称
- 处理目标不存在的情况
- 确保策略绑定的准确性

### 策略文件格式要求

策略文件需要符合JSON格式，包含完整的标签策略定义：

```json
{
  "version": "1.0",
  "statement": [
    {
      "effect": "allow",
      "action": "tag:*",
      "resource": "*",
      "condition": {
        "for_all_value": {
          "tag:required": ["project", "environment", "owner"]
        }
      }
    }
  ]
}
```

### 最佳实践建议

1. **分级管理原则**
   - 按组织架构分级制定策略
   - 避免过度严格的策略
   - 定期审计策略效果

2. **命名规范**
   - 制定统一的策略命名规范
   - 确保策略名称唯一性
   - 便于策略管理和审计

3. **策略分组**
   - 按功能分组制定策略
   - 同类策略集中管理
   - 避免策略冲突

4. **监控审计**
   - 启用策略执行日志
   - 定期检查策略合规性
   - 及时调整不合适的策略

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **目标识别**
   - `target_id`和`target_name`必须二选一
   - 不能同时为空或同时设置
   - 确保指定的目标存在

2. **策略文件**
   - 确保策略文件路径正确
   - 检查策略文件格式是否合法
   - 确认策略内容有效性

3. **权限验证**
   - 绑定前验证目标权限
   - 确保不会造成权限冲突
   - 测试策略生效情况

4. **名称准确性**
   - 目标名称必须精确匹配
   - 大小写敏感
   - 避免使用易混淆名称

5. **ID准确性**
   - 目标ID必须准确无误
   - 避免使用错误的ID
   - 定期核对ID信息

6. **策略限制**
   - 了解策略的数量限制
   - 注意策略之间的依赖关系
   - 避免冲突配置

7. **操作顺序**
   - 先创建部门/成员再绑定策略
   - 按依赖关系顺序操作
   - 避免循环依赖

8. **备份恢复**
   - 定期备份策略配置
   - 准备恢复方案
   - 测试恢复流程

9. **变更管理**
   - 记录所有策略变更
   - 通知相关受影响方
   - 评估变更影响

10. **合规要求**
    - 遵守企业内部合规要求
    - 满足行业监管要求
    - 定期进行合规检查

---

## 故障排除

### 常见错误及解决方案

#### 错误一：目标不存在

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Target not found
```

**原因**：指定的目标名称或ID不存在
**解决方案**：
- 检查目标名称拼写是否正确
- 确认目标ID是否正确
- 确保目标已在组织中创建

#### 错误二：策略文件不存在

```
Error: [TerraformError] Code=FileNotFound
Message=Policy file not found
```

**原因**：指定的策略文件路径不存在
**解决方案**：
- 检查策略文件路径是否正确
- 确认文件是否已创建
- 确保文件有读取权限

#### 错误三：权限不足

```
Error: [TencentCloudSDKError] Code=PermissionDenied
Message=Insufficient permissions
```

**原因**：当前账号权限不足
**解决方案**：
- 检查当前账号权限
- 确认是否有策略管理权限
- 申请必要的权限

#### 错误四：重复绑定

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Policy already bound
```

**原因**：相同的策略已绑定到该目标
**解决方案**：
- 检查是否重复配置
- 移除重复的绑定配置
- 确认是否需要重复绑定

#### 错误五：参数冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Parameter conflict
```

**原因**：同时设置了target_id和target_name
**解决方案**：
- 只使用一种识别方式
- 移除冲突的参数
- 选择优先使用的方式

#### 错误六：策略限制

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Policy limit exceeded
```

**原因**：达到策略数量限制
**解决方案**：
- 检查策略数量限制
- 减少策略数量
- 申请提高限额