# 腾讯云组织部门管理模块

## 模块概述

本模块用于在腾讯云中创建和管理组织部门结构，支持多级部门架构，主要功能包括：

- **多级部门创建** - 支持创建一级（L1）和二级（L2）部门节点
- **部门层级管理** - 自动处理部门间的父子层级关系
- **部门信息配置** - 支持部门名称和备注信息配置
- **依赖关系处理** - 自动处理部门创建的顺序依赖
- **ID映射输出** - 输出部门名称到ID的映射关系
- **批量操作** - 支持一次性配置多个部门层级
- **灵活配置** - 支持可选参数和默认值配置

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
| `QcloudOrganizationReadOnlyAccess` | 组织只读访问权限 |

### 其他要求

- 需要了解腾讯云组织架构
- 需要规划好部门命名规范
- 需要确定部门层级结构
- 需要收集部门备注信息（可选）
- 需要了解部门ID映射关系

---

## 变量说明

### 主要配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `org_nodes` | `list(object)` | 否 | `[]` | 组织部门节点配置列表 |

### 部门节点对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `name` | `string` | 是 | - | 一级部门名称 |
| `remark` | `string` | 否 | - | 一级部门备注信息 |
| `sub_nodes` | `list(object)` | 否 | `[]` | 二级部门子节点列表 |

### 二级部门对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `name` | `string` | 是 | - | 二级部门名称 |
| `remark` | `string` | 否 | - | 二级部门备注信息 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 基础部门结构配置
org_nodes = [
  {
    name      = "技术部"
    remark    = "负责技术研发和运维"
    sub_nodes = [
      {
        name   = "前端开发组"
        remark = "负责前端技术开发"
      },
      {
        name   = "后端开发组"
        remark = "负责后端技术开发"
      },
      {
        name   = "运维组"
        remark = "负责系统运维和部署"
      }
    ]
  },
  
  {
    name      = "产品部"
    remark    = "负责产品设计和规划"
    sub_nodes = [
      {
        name   = "产品设计组"
        remark = "负责产品界面和交互设计"
      },
      {
        name   = "产品策划组"
        remark = "负责产品功能规划和需求分析"
      }
    ]
  },
  
  {
    name      = "市场部"
    remark    = "负责市场推广和品牌建设"
    sub_nodes = [
      {
        name   = "市场推广组"
        remark = "负责线上线下的市场推广活动"
      },
      {
        name   = "品牌建设组"
        remark = "负责品牌形象建设和维护"
      },
      {
        name   = "客户关系组"
        remark = "负责客户关系维护和客户服务"
      }
    ]
  },
  
  {
    name      = "财务部"
    remark    = "负责财务管理和资金运作"
    sub_nodes = []  # 没有子部门
  },
  
  {
    name      = "人力资源部"
    remark    = "负责人才招聘和员工发展"
    sub_nodes = [
      {
        name   = "招聘组"
        remark = "负责人才招聘和面试"
      },
      {
        name   = "培训组"
        remark = "负责员工培训和职业发展"
      },
      {
        name   = "薪酬福利组"
        remark = "负责薪酬管理和福利发放"
      }
    ]
  }
]
```

### 多层级部门配置示例

```hcl
# 复杂层级部门结构配置
org_nodes = [
  {
    name      = "研发中心"
    remark    = "公司核心技术研发部门"
    sub_nodes = [
      {
        name   = "平台研发部"
        remark = "基础平台技术研发"
      },
      {
        name   = "应用研发部"
        remark = "业务应用系统研发"
      },
      {
        name   = "数据研发部"
        remark = "大数据和AI技术研发"
      },
      {
        name   = "质量保障部"
        remark = "软件测试和质量保证"
      }
    ]
  },
  
  {
    name      = "业务中心"
    remark    = "公司业务运营部门"
    sub_nodes = [
      {
        name   = "电商业务部"
        remark = "电商平台业务运营"
      },
      {
        name   = "金融业务部"
        remark = "金融科技业务运营"
      },
      {
        name   = "企业服务部"
        remark = "企业级服务业务"
      },
      {
        name   = "海外业务部"
        remark = "海外市场拓展和运营"
      }
    ]
  },
  
  {
    name      = "支撑中心"
    remark    = "公司运营支撑部门"
    sub_nodes = [
      {
        name   = "人力资源部"
        remark = "人才管理和组织发展"
      },
      {
        name   = "财务部"
        remark = "财务管理和资金运作"
      },
      {
        name   = "行政部"
        remark = "行政事务和办公管理"
      },
      {
        name   = "法务部"
        remark = "法律事务和合规管理"
      }
    ]
  },
  
  {
    name      = "战略发展部"
    remark    = "公司战略规划和投资"
    sub_nodes = []
  },
  
  {
    name      = "董事会办公室"
    remark    = "董事会事务和公司治理"
    sub_nodes = []
  }
]
```

### 简单部门结构示例

```hcl
# 简单部门结构配置（适用于小型组织）
org_nodes = [
  {
    name      = "管理层"
    remark    = "公司高层管理团队"
    sub_nodes = []
  },
  
  {
    name      = "技术团队"
    remark    = "技术开发和运维"
    sub_nodes = [
      {
        name   = "开发组"
        remark = "软件开发"
      },
      {
        name   = "运维组"
        remark = "系统运维"
      }
    ]
  },
  
  {
    name      = "业务团队"
    remark    = "业务运营和客户服务"
    sub_nodes = [
      {
        name   = "销售组"
        remark = "产品销售"
      },
      {
        name   = "客服组"
        remark = "客户服务"
      }
    ]
  },
  
  {
    name      = "支持团队"
    remark    = "行政和财务支持"
    sub_nodes = [
      {
        name   = "行政组"
        remark = "行政事务"
      },
      {
        name   = "财务组"
        remark = "财务管理"
      }
    ]
  }
]
```

### 国际化部门结构示例

```hcl
# 国际化部门结构配置
org_nodes = [
  {
    name      = "Headquarters"
    remark    = "Global headquarters management"
    sub_nodes = [
      {
        name   = "Executive Office"
        remark = "C-level management"
      },
      {
        name   = "Strategy Department"
        remark = "Corporate strategy planning"
      },
      {
        name   = "Finance Department"
        remark = "Global financial management"
      }
    ]
  },
  
  {
    name      = "Asia Pacific Region"
    remark    = "APAC business operations"
    sub_nodes = [
      {
        name   = "China Office"
        remark = "Mainland China operations"
      },
      {
        name   = "Japan Office"
        remark = "Japan market operations"
      },
      {
        name   = "Southeast Asia Office"
        remark = "SEA market operations"
      }
    ]
  },
  
  {
    name      = "Europe Region"
    remark    = "European business operations"
    sub_nodes = [
      {
        name   = "UK Office"
        remark = "United Kingdom operations"
      },
      {
        name   = "Germany Office"
        remark = "Germany market operations"
      },
      {
        name   = "France Office"
        remark = "France market operations"
      }
    ]
  },
  
  {
    name      = "North America Region"
    remark    = "NA business operations"
    sub_nodes = [
      {
        name   = "US Office"
        remark = "United States operations"
      },
      {
        name   = "Canada Office"
        remark = "Canada market operations"
      }
    ]
  }
]
```

---

## 使用示例

### 示例一：科技公司部门结构

```hcl
# 科技公司典型部门结构
org_nodes = [
  {
    name      = "技术研发中心"
    remark    = "核心技术研发和创新"
    sub_nodes = [
      {
        name   = "基础架构部"
        remark = "云原生和基础设施"
      },
      {
        name   = "前端开发部"
        remark = "Web和移动端开发"
      },
      {
        name   = "后端开发部"
        remark = "服务端和API开发"
      },
      {
        name   = "数据智能部"
        remark = "大数据和人工智能"
      },
      {
        name   = "测试保障部"
        remark = "质量保证和测试"
      }
    ]
  },
  
  {
    name      = "产品运营中心"
    remark    = "产品管理和运营"
    sub_nodes = [
      {
        name   = "产品管理部"
        remark = "产品规划和设计"
      },
      {
        name   = "用户运营部"
        remark = "用户增长和运营"
      },
      {
        name   = "数据运营部"
        remark = "数据分析和运营"
      },
      {
        name   = "内容运营部"
        remark = "内容创作和运营"
      }
    ]
  },
  
  {
    name      = "商业拓展中心"
    remark    = "业务发展和合作"
    sub_nodes = [
      {
        name   = "销售部"
        remark = "产品销售和商务"
      },
      {
        name   = "渠道部"
        remark = "渠道管理和合作"
      },
      {
        name   = "大客户部"
        remark = "大客户服务和管理"
      },
      {
        name   = "合作伙伴部"
        remark = "生态合作伙伴"
      }
    ]
  }
]
```

### 示例二：金融机构部门结构

```hcl
# 金融机构部门结构
org_nodes = [
  {
    name      = "风险管理委员会"
    remark    = "全面风险管理和控制"
    sub_nodes = [
      {
        name   = "信用风险部"
        remark = "信用风险评估和管理"
      },
      {
        name   = "市场风险部"
        remark = "市场风险监控"
      },
      {
        name   = "操作风险部"
        remark = "操作风险控制"
      },
      {
        name   = "合规部"
        remark = "合规管理和审计"
      }
    ]
  },
  
  {
    name      = "业务发展部"
    remark    = "金融业务拓展"
    sub_nodes = [
      {
        name   = "零售业务部"
        remark = "个人金融业务"
      },
      {
        name   = "企业业务部"
        remark = "企业金融服务"
      },
      {
        name   = "投资银行部"
        remark = "投行业务"
      },
      {
        name   = "资产管理部"
        remark = "资产管理和投资"
      }
    ]
  },
  
  {
    name      = "科技信息部"
    remark    = "金融科技和IT"
    sub_nodes = [
      {
        name   = "系统开发部"
        remark = "金融系统开发"
      },
      {
        name   = "数据中心"
        remark = "数据管理和分析"
      },
      {
        name   = "网络安全部"
        remark = "信息安全保障"
      },
      {
        name   = "运维保障部"
        remark = "系统运维支持"
      }
    ]
  }
]
```

### 示例三：教育机构部门结构

```hcl
# 教育机构部门结构
org_nodes = [
  {
    name      = "教学管理部门"
    remark    = "教学管理和课程开发"
    sub_nodes = [
      {
        name   = "课程研发部"
        remark = "课程体系开发"
      },
      {
        name   = "教学质量部"
        remark = "教学质量管理"
      },
      {
        name   = "教师发展部"
        remark = "教师培训和发展"
      },
      {
        name   = "学术研究部"
        remark = "学术研究和交流"
      }
    ]
  },
  
  {
    name      = "学生服务部门"
    remark    = "学生服务和管理"
    sub_nodes = [
      {
        name   = "招生办公室"
        remark = "学生招生和录取"
      },
      {
        name   = "学生事务部"
        remark = "学生日常管理"
      },
      {
        name   = "就业指导中心"
        remark = "就业指导和服务"
      },
      {
        name   = "心理咨询中心"
        remark = "心理健康服务"
      }
    ]
  },
  
  {
    name      = "行政支持部门"
    remark    = "行政和后勤支持"
    sub_nodes = [
      {
        name   = "财务处"
        remark = "财务管理"
      },
      {
        name   = "人事处"
        remark = "人事管理"
      },
      {
        name   = "后勤保障处"
        remark = "后勤服务"
      },
      {
        name   = "信息技术处"
        remark = "IT支持"
      }
    ]
  }
]
```

---

## 配置说明

### 部门层级说明

| 层级 | 说明 | 最大深度 | 备注 |
|------|------|----------|------|
| **一级部门 (L1)** | 直接隶属于根部门的顶级部门 | 无限制 | 支持无限数量的一级部门 |
| **二级部门 (L2)** | 隶属于一级部门的子部门 | 每个一级部门下无限制 | 支持无限数量的二级部门 |

### 命名规范说明

| 项目 | 要求 | 示例 |
|------|------|------|
| **部门名称** | 2-64个字符，支持中文、英文、数字、下划线 | `技术部`, `R&D_Department` |
| **部门备注** | 0-128个字符，支持中文、英文、数字、标点 | `负责技术研发工作` |
| **名称唯一性** | 同一层级下部门名称必须唯一 | 不能有两个`技术部` |

### 输出说明

模块输出两级部门的名称到ID的映射关系：

```hcl
# 一级部门ID映射
l1_nodes = {
  "技术部"       = "org-node-12345678"
  "产品部"       = "org-node-87654321"
  "市场部"       = "org-node-abcdefgh"
}

# 二级部门ID映射
l2_nodes = {
  "技术部/前端开发组" = "org-node-11111111"
  "技术部/后端开发组" = "org-node-22222222"
  "技术部/运维组"    = "org-node-33333333"
  "产品部/产品设计组" = "org-node-44444444"
  "产品部/产品策划组" = "org-node-55555555"
}
```

### 依赖关系说明

模块内部自动处理以下依赖关系：
1. 首先创建所有一级部门
2. 然后创建所有二级部门
3. 确保一级部门创建完成后才创建二级部门
4. 自动处理部门间的父子层级关系

### 模块架构说明

```
根部门 (Root)
├── 一级部门1 (L1 Node)
│   ├── 二级部门1-1 (L2 Node)
│   ├── 二级部门1-2 (L2 Node)
│   └── 二级部门1-3 (L2 Node)
├── 一级部门2 (L1 Node)
│   ├── 二级部门2-1 (L2 Node)
│   └── 二级部门2-2 (L2 Node)
└── 一级部门3 (L1 Node)
    └── (无子部门)
```

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **部门规划**
   - 提前规划好部门层级结构
   - 确定部门命名规范
   - 避免部门名称冲突

2. **依赖管理**
   - 模块自动处理创建顺序
   - 不要手动修改依赖关系
   - 确保一级部门先于二级部门创建

3. **命名规范**
   - 使用有意义的部门名称
   - 遵循统一的命名约定
   - 避免使用特殊字符

4. **层级限制**
   - 目前支持两级部门结构
   - 如需更多层级需要自定义扩展
   - 考虑组织架构的扁平化

5. **ID管理**
   - 部门ID由腾讯云自动生成
   - 通过输出变量获取ID映射
   - 不要硬编码部门ID

6. **变更管理**
   - 部门创建后不建议重命名
   - 部门删除需要先删除子部门
   - 制定部门变更流程

7. **权限控制**
   - 部门用于权限分组
   - 结合CAM策略进行权限控制
   - 遵循最小权限原则

8. **监控审计**
   - 启用组织操作日志
   - 定期审计部门结构
   - 监控部门变更操作

---

## 故障排除

### 常见错误及解决方案

#### 错误一：部门名称冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Node name already exists
```

**原因**：同一层级下部门名称重复
**解决方案**：
- 检查部门名称是否唯一
- 修改重复的部门名称
- 使用不同的名称或添加后缀

#### 错误二：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少组织管理权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含组织管理权限
- 验证项目权限

#### 错误三：父部门不存在

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Parent node not found
```

**原因**：二级部门的父部门不存在
**解决方案**：
- 确保一级部门已正确配置
- 检查一级部门名称拼写
- 验证依赖关系是否正确

#### 错误四：参数格式错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid parameter format
```

**原因**：部门名称或备注格式不符合要求
**解决方案**：
- 检查部门名称长度（2-64字符）
- 检查备注长度（0-128字符）
- 移除非法字符

#### 错误五：配额限制

```
Error: [TencentCloudSDKError] Code=QuotaExceeded
Message=Node quota exceeded
```

**原因**：达到部门数量配额限制
**解决方案**：
- 检查部门配额限制
- 申请提高配额或删除无用部门
- 合并相似的部门

#### 错误六：依赖错误

```
Error: [TencentCloudSDKError] Code=DependencyViolation
Message=Cannot create child node before parent
```

**原因**：二级部门创建在一级部门之前
**解决方案**：
- 确保依赖关系正确配置
- 检查depends_on设置
- 重新运行terraform apply