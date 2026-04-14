# 腾讯云组织成员管理模块

## 模块概述

本模块用于在腾讯云中创建和管理组织成员账户，支持批量成员管理和权限配置，主要功能包括：

- **成员账户管理** - 创建和管理组织成员账户
- **权限配置** - 配置财务管理和组织策略权限
- **部门关联** - 将成员关联到指定组织部门
- **批量操作** - 支持批量创建和管理多个成员
- **安全信息绑定** - 支持邮箱和手机号安全绑定
- **标签管理** - 为成员添加自定义标签
- **依赖处理** - 自动处理部门ID映射关系
- **输出管理** - 输出成员UIN映射关系

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
| `QcloudFinanceFullAccess` | 财务管理全权限 |

### 其他要求

- 需要了解腾讯云组织架构和部门结构
- 需要规划好成员命名规范
- 需要确定权限分配策略
- 需要收集成员联系信息（可选）
- 需要了解财务权限配置
- 需要准备支付账号信息（如需代付）

---

## 变量说明

### 主要配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `members` | `map(list(object))` | 否 | `{}` | 组织成员配置映射表，键为部门名称 |

### 成员对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `name` | `string` | 是 | - | 成员名称 |
| `permission_ids` | `list(number)` | 是 | - | 财务管理权限ID列表 |
| `policy_type` | `string` | 是 | - | 组织策略类型 |
| `pay_uin` | `string` | 条件 | - | 代付账号UIN |
| `node_id` | `number` | 否 | `null` | 组织部门节点ID |
| `force_delete_account` | `bool` | 否 | `false` | 是否强制删除成员账户 |
| `is_modify_nick_name` | `number` | 否 | - | 是否同步名称到昵称 |
| `record_id` | `number` | 否 | - | 创建记录ID（重试时使用） |
| `remark` | `string` | 否 | - | 成员备注信息 |
| `tags` | `map(string)` | 否 | - | 成员标签映射 |
| `enable_bound` | `bool` | 否 | `false` | 是否启用安全信息绑定 |
| `email` | `string` | 否 | - | 成员邮箱地址 |
| `phone` | `string` | 否 | - | 成员手机号码 |
| `country_code` | `number` | 否 | - | 手机国家代码 |

### 财务管理权限ID说明

| 权限ID | 权限名称 | 说明 | 是否必需 |
|--------|----------|------|----------|
| **1** | 查看账单 | 查看消费账单和明细 | 必需 |
| **2** | 查看余额 | 查看账户余额信息 | 必需 |
| **3** | 资金划拨 | 进行资金划拨操作 | 可选 |
| **4** | 合并账单 | 合并多个账单查看 | 可选 |
| **5** | 开具发票 | 申请和开具发票 | 可选 |
| **6** | 继承折扣 | 继承主账号折扣 | 可选 |
| **7** | 代付功能 | 使用代付账号支付 | 条件必需 |

### 组织策略类型说明

| 策略类型 | 说明 | 适用场景 |
|----------|------|----------|
| **Financial** | 财务管理策略 | 财务管理和资金操作 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 基础成员配置示例
members = {
  # 技术部门成员
  "技术部" = [
    {
      name           = "developer_zhangsan"
      permission_ids = [1, 2, 3]  # 查看账单、查看余额、资金划拨
      policy_type    = "Financial"
      remark         = "后端开发工程师"
      email          = "zhangsan@example.com"
      phone          = "13800138000"
      country_code   = 86
      tags           = {
        role     = "developer"
        team     = "backend"
        level    = "senior"
      }
    },
    {
      name           = "developer_lisi"
      permission_ids = [1, 2]      # 仅查看权限
      policy_type    = "Financial"
      remark         = "前端开发工程师"
      email          = "lisi@example.com"
      enable_bound   = true        # 启用安全绑定
    }
  ],
  
  # 财务部门成员
  "财务部" = [
    {
      name           = "finance_wangwu"
      permission_ids = [1, 2, 3, 4, 5, 6, 7]  # 全权限
      policy_type    = "Financial"
      pay_uin        = "123456789"             # 代付账号UIN
      remark         = "财务主管"
      email          = "wangwu@example.com"
      phone          = "13900139000"
      country_code   = 86
      force_delete_account = true  # 强制删除账户
    },
    {
      name           = "finance_zhaoliu"
      permission_ids = [1, 2, 4, 5]  # 查看和发票权限
      policy_type    = "Financial"
      remark         = "财务专员"
      email          = "zhaoliu@example.com"
    }
  ],
  
  # 管理部门成员
  "管理部" = [
    {
      name           = "manager_liqi"
      permission_ids = [1, 2, 3, 6]  # 基础财务权限
      policy_type    = "Financial"
      remark         = "部门经理"
      email          = "liqi@example.com"
      phone          = "13700137000"
      country_code   = 86
      is_modify_nick_name = 1  # 同步名称到昵称
    }
  ]
}
```

### 简单成员配置示例

```hcl
# 简单成员配置（适用于小型团队）
members = {
  "默认部门" = [
    {
      name           = "admin_user"
      permission_ids = [1, 2]      # 基础查看权限
      policy_type    = "Financial"
      remark         = "管理员账号"
      email          = "admin@company.com"
    },
    {
      name           = "dev_user"
      permission_ids = [1, 2]      # 基础查看权限
      policy_type    = "Financial"
      remark         = "开发人员账号"
      email          = "dev@company.com"
    },
    {
      name           = "finance_user"
      permission_ids = [1, 2, 3, 4, 5]  # 财务相关权限
      policy_type    = "Financial"
      remark         = "财务人员账号"
      email          = "finance@company.com"
    }
  ]
}
```

### 高级权限配置示例

```hcl
# 高级权限配置（细粒度权限控制）
members = {
  "研发中心" = [
    {
      name           = "rd_director"
      permission_ids = [1, 2, 3, 6]  # 管理级权限
      policy_type    = "Financial"
      remark         = "研发总监"
      email          = "rd_director@tech.com"
      phone          = "18600186000"
      country_code   = 86
      tags           = {
        department = "rd"
        level      = "director"
        cost_center = "RD001"
      }
    },
    {
      name           = "rd_manager"
      permission_ids = [1, 2, 3]      # 经理级权限
      policy_type    = "Financial"
      remark         = "研发经理"
      email          = "rd_manager@tech.com"
      tags           = {
        department = "rd"
        level      = "manager"
        cost_center = "RD002"
      }
    },
    {
      name           = "rd_engineer"
      permission_ids = [1, 2]          # 工程师基础权限
      policy_type    = "Financial"
      remark         = "研发工程师"
      email          = "rd_engineer@tech.com"
      tags           = {
        department = "rd"
        level      = "engineer"
        cost_center = "RD003"
      }
    }
  ],
  
  "财务中心" = [
    {
      name           = "finance_director"
      permission_ids = [1, 2, 3, 4, 5, 6, 7]  # 全权限
      policy_type    = "Financial"
      pay_uin        = "888888888"             # 主代付账号
      remark         = "财务总监"
      email          = "finance_director@tech.com"
      phone          = "18500185000"
      country_code   = 86
      force_delete_account = true
      tags           = {
        department = "finance"
        level      = "director"
        cost_center = "FIN001"
      }
    },
    {
      name           = "finance_specialist"
      permission_ids = [1, 2, 4, 5]      # 发票和账单权限
      policy_type    = "Financial"
      remark         = "财务专员"
      email          = "finance_specialist@tech.com"
      tags           = {
        department = "finance"
        level      = "specialist"
        cost_center = "FIN002"
      }
    }
  ]
}
```

### 国际化成员配置示例

```hcl
# 国际化成员配置
members = {
  "Global" = [
    {
      name           = "global_admin"
      permission_ids = [1, 2, 3, 4, 5, 6]  # 全球管理权限
      policy_type    = "Financial"
      remark         = "Global Administrator"
      email          = "admin@global.com"
      phone          = "+14155550123"
      country_code   = 1
      tags           = {
        region = "global"
        role   = "administrator"
      }
    },
    {
      name           = "us_finance"
      permission_ids = [1, 2, 3, 7]          # 美国财务权限
      policy_type    = "Financial"
      pay_uin        = "US123456789"
      remark         = "US Finance Manager"
      email          = "finance.us@global.com"
      phone          = "+12125550123"
      country_code   = 1
      tags           = {
        region = "north_america"
        role   = "finance_manager"
      }
    },
    {
      name           = "eu_developer"
      permission_ids = [1, 2]                  # 欧洲开发权限
      policy_type    = "Financial"
      remark         = "EU Developer"
      email          = "dev.eu@global.com"
      phone          = "+442012345678"
      country_code   = 44
      tags           = {
        region = "europe"
        role   = "developer"
      }
    }
  ]
}
```

---

## 使用示例

### 示例一：企业级成员管理

```hcl
# 企业级成员权限管理
members = {
  "董事会" = [
    {
      name           = "board_chairman"
      permission_ids = [1, 2, 3, 4, 5, 6]  # 董事会全权限
      policy_type    = "Financial"
      remark         = "董事会主席"
      email          = "chairman@enterprise.com"
      phone          = "13900000001"
      country_code   = 86
      tags           = {
        level = "board"
        role  = "chairman"
      }
    }
  ],
  
  "高管层" = [
    {
      name           = "ceo"
      permission_ids = [1, 2, 3, 4, 5, 6]  # 高管全权限
      policy_type    = "Financial"
      remark         = "首席执行官"
      email          = "ceo@enterprise.com"
      phone          = "13900000002"
      country_code   = 86
      tags           = {
        level = "c_level"
        role  = "ceo"
      }
    },
    {
      name           = "cfo"
      permission_ids = [1, 2, 3, 4, 5, 6, 7]  # CFO全权限+代付
      policy_type    = "Financial"
      pay_uin        = "enterprise_main"
      remark         = "首席财务官"
      email          = "cfo@enterprise.com"
      phone          = "13900000003"
      country_code   = 86
      force_delete_account = true
      tags           = {
        level = "c_level"
        role  = "cfo"
      }
    }
  ],
  
  "部门管理层" = [
    {
      name           = "tech_vp"
      permission_ids = [1, 2, 3, 6]  # 技术VP权限
      policy_type    = "Financial"
      remark         = "技术副总裁"
      email          = "tech.vp@enterprise.com"
      tags           = {
        level = "vp"
        department = "technology"
      }
    },
    {
      name           = "sales_vp"
      permission_ids = [1, 2, 3, 6]  # 销售VP权限
      policy_type    = "Financial"
      remark         = "销售副总裁"
      email          = "sales.vp@enterprise.com"
      tags           = {
        level = "vp"
        department = "sales"
      }
    }
  ]
}
```

### 示例二：项目团队权限管理

```hcl
# 项目团队权限配置
members = {
  "项目A团队" = [
    {
      name           = "project_a_manager"
      permission_ids = [1, 2, 3]      # 项目经理权限
      policy_type    = "Financial"
      remark         = "项目A经理"
      email          = "manager.project_a@company.com"
      tags           = {
        project = "project_a"
        role    = "manager"
        budget  = "500000"
      }
    },
    {
      name           = "project_a_lead"
      permission_ids = [1, 2]          # 项目组长权限
      policy_type    = "Financial"
      remark         = "项目A技术负责人"
      email          = "lead.project_a@company.com"
      tags           = {
        project = "project_a"
        role    = "tech_lead"
      }
    },
    {
      name           = "project_a_dev"
      permission_ids = [1, 2]          # 开发人员权限
      policy_type    = "Financial"
      remark         = "项目A开发工程师"
      email          = "dev.project_a@company.com"
      tags           = {
        project = "project_a"
        role    = "developer"
      }
    }
  ],
  
  "项目B团队" = [
    {
      name           = "project_b_manager"
      permission_ids = [1, 2, 3]      # 项目经理权限
      policy_type    = "Financial"
      remark         = "项目B经理"
      email          = "manager.project_b@company.com"
      tags           = {
        project = "project_b"
        role    = "manager"
        budget  = "300000"
      }
    },
    {
      name           = "project_b_qa"
      permission_ids = [1, 2]          # 测试人员权限
      policy_type    = "Financial"
      remark         = "项目B测试工程师"
      email          = "qa.project_b@company.com"
      tags           = {
        project = "project_b"
        role    = "qa_engineer"
      }
    }
  ]
}
```

### 示例三：外包人员权限管理

```hcl
# 外包人员权限配置（最小权限原则）
members = {
  "外包团队" = [
    {
      name           = "vendor_lead"
      permission_ids = [1, 2]          # 外包负责人基础权限
      policy_type    = "Financial"
      remark         = "外包团队负责人"
      email          = "vendor.lead@external.com"
      phone          = "13800000001"
      country_code   = 86
      tags           = {
        type = "vendor"
        role = "team_lead"
        contract = "CT2024001"
      }
    },
    {
      name           = "vendor_dev"
      permission_ids = [1]              # 外包开发只读权限
      policy_type    = "Financial"
      remark         = "外包开发工程师"
      email          = "vendor.dev@external.com"
      tags           = {
        type = "vendor"
        role = "developer"
        contract = "CT2024001"
      }
    },
    {
      name           = "vendor_qa"
      permission_ids = [1]              # 外包测试只读权限
      policy_type    = "Financial"
      remark         = "外包测试工程师"
      email          = "vendor.qa@external.com"
      tags           = {
        type = "vendor"
        role = "qa_engineer"
        contract = "CT2024001"
      }
    }
  ]
}
```

---

## 配置说明

### 权限配置说明

| 权限级别 | 权限ID组合 | 适用角色 | 说明 |
|----------|------------|----------|------|
| **只读权限** | `[1, 2]` | 普通员工 | 只能查看账单和余额 |
| **基础操作** | `[1, 2, 3]` | 团队领导 | 可以查看和进行资金划拨 |
| **财务权限** | `[1, 2, 3, 4, 5]` | 财务人员 | 完整的财务操作权限 |
| **代付权限** | `[1, 2, 3, 4, 5, 6, 7]` | 财务主管 | 全权限+代付功能 |
| **管理权限** | `[1, 2, 3, 6]` | 管理人员 | 基础操作+折扣继承 |

### 部门映射说明

模块自动处理部门名称到部门ID的映射：
- 如果提供`node_id`，直接使用指定的部门ID
- 如果未提供`node_id`，自动根据部门名称查找对应的部门ID
- 支持跨部门成员管理
- 自动处理部门依赖关系

### 输出说明

模块输出成员名称到UIN的映射关系：

```hcl
# 成员UIN映射输出示例
member_uins = {
  "技术部" = {
    "developer_zhangsan" = "1000000001"
    "developer_lisi"     = "1000000002"
  },
  "财务部" = {
    "finance_wangwu"     = "1000000003"
    "finance_zhaoliu"    = "1000000004"
  },
  "管理部" = {
    "manager_liqi"       = "1000000005"
  }
}
```

### 安全绑定说明

当`enable_bound = true`时：
- 系统会向提供的邮箱发送激活邮件
- 成员需要完成安全绑定才能使用账号
- 建议为敏感操作启用安全绑定
- 绑定后可以提高账号安全性

### 标签管理说明

标签用于：
- 权限分组和筛选
- 成本中心标识
- 角色和级别标识
- 项目和组织标识
- 审计和报告分类

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **权限规划**
   - 遵循最小权限原则
   - 提前规划权限分配策略
   - 避免过度授权

2. **部门依赖**
   - 确保部门已经存在
   - 部门名称需要精确匹配
   - 建议先创建部门再添加成员

3. **代付配置**
   - 代付功能需要提供`pay_uin`
   - 代付账号需要有足够权限
   - 代付操作需要谨慎授权

4. **安全绑定**
   - 安全绑定会发送激活邮件
   - 确保邮箱地址正确
   - 建议对敏感操作启用绑定

5. **删除保护**
   - `force_delete_account`会强制删除账户
   - 删除操作不可逆
   - 生产环境谨慎使用

6. **名称同步**
   - `is_modify_nick_name`同步名称到昵称
   - 昵称修改可能影响用户体验
   - 考虑命名一致性

7. **重试机制**
   - `record_id`用于创建失败重试
   - 记录ID需要妥善保管
   - 避免重复创建

8. **标签规范**
   - 制定统一的标签命名规范
   - 避免标签冲突
   - 便于后续查询和管理

9. **联系信息**
   - 收集完整的联系信息
   - 确保联系方式准确
   - 定期更新联系信息

10. **审计监控**
    - 启用操作日志记录
    - 定期审计成员权限
    - 监控异常操作行为

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid permission ids
```

**原因**：权限ID配置错误或缺失必需权限
**解决方案**：
- 检查权限ID是否有效（1-7）
- 确保包含必需权限（1和2）
- 验证权限组合是否合理

#### 错误二：部门不存在

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Node not found
```

**原因**：指定的部门不存在或名称不匹配
**解决方案**：
- 检查部门名称拼写
- 确保部门已经创建
- 使用正确的部门ID

#### 错误三：代付账号错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid pay uin
```

**原因**：代付账号UIN无效或权限不足
**解决方案**：
- 检查代付账号UIN是否正确
- 确认代付账号有足够权限
- 验证代付账号状态

#### 错误四：成员已存在

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Member already exists
```

**原因**：成员名称已存在
**解决方案**：
- 检查成员名称是否唯一
- 修改重复的成员名称
- 使用不同的命名约定

#### 错误五：联系信息错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid contact information
```

**原因**：邮箱或手机号格式错误
**解决方案**：
- 检查邮箱格式是否正确
- 验证手机号和国家代码
- 确保联系信息有效

#### 错误六：配额限制

```
Error: [TencentCloudSDKError] Code=QuotaExceeded
Message=Member quota exceeded
```

**原因**：达到成员数量配额限制
**解决方案**：
- 检查成员配额限制
- 申请提高配额或删除无用成员
- 合并相似权限的成员