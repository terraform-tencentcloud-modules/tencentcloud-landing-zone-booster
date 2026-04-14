# 腾讯云服务委派管理模块

## 模块概述

本模块用于在腾讯云中为组织成员委派服务管理权限，支持批量服务权限分配和统一管理，主要功能包括：

- **服务委派管理** - 为组织成员委派特定云服务的管理权限
- **成员识别** - 支持通过成员UIN或成员名称识别目标成员
- **批量操作** - 支持批量委派多个服务和多个成员
- **自动映射** - 自动处理成员名称到UIN的映射关系
- **权限统一** - 实现组织内服务权限的统一管理
- **服务覆盖** - 支持多种腾讯云核心服务的委派
- **依赖处理** - 自动处理成员信息依赖关系
- **灵活配置** - 支持多种配置方式满足不同场景需求

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
| 相关服务的管理权限 | 需要委派的服务对应权限 |

### 其他要求

- 需要了解腾讯云组织架构和成员结构
- 需要规划好服务委派策略
- 需要确定委派范围和权限级别
- 需要收集成员UIN或准确名称
- 需要了解各服务的功能特性
- 需要准备服务委派清单

---

## 变量说明

### 主要配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `service_assign_list` | `list(object)` | 是 | - | 服务委派配置列表 |

### 服务委派对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `member_uin` | `number` | 条件 | `null` | 成员UIN（与member_name二选一） |
| `member_name` | `string` | 条件 | `null` | 成员名称（与member_uin二选一） |
| `service_name` | `string` | 是 | - | 服务名称 |

### 支持的服务列表及说明

| 服务ID | 服务名称 | 中文名称 | 功能说明 |
|--------|----------|----------|----------|
| **22** | ICP | ICP备案 | 统一管理组织成员的ICP备案资源 |
| **24** | Web Application Firewall | Web应用防火墙 | 统一管理组织成员的WAF资源 |
| **15** | Cloud Security Center | 云安全中心 | 统一管理组织成员的CSC资源 |
| **23** | Cloud Virtual Machine | 云虚拟机 | 查看成员CVM配额并代申请配额提升 |
| **25** | Key Management Service | 密钥管理服务 | 统一管理组织成员的KMS密钥资源 |
| **17** | Control Center | 控制中心 | 统一管理和配置多账号环境 |
| **12** | CloudAudit | 云审计 | 统一管理组织成员的审计日志 |
| **20** | tandon | 安顿服务 | 统一管理组织成员的安顿资源 |
| **13** | Billing Center | 计费中心 | 查看成员账单、余额和合并报表 |
| **18** | Config | 配置管理 | 统一管理组织成员的配置资源 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 基础服务委派配置示例
service_assign_list = [
  # 为技术部门成员委派开发相关服务
  {
    member_name  = "developer_zhangsan"
    service_name = "Cloud Virtual Machine"     # ID: 23 - 云虚拟机管理
  },
  {
    member_name  = "developer_zhangsan"
    service_name = "Key Management Service"    # ID: 25 - 密钥管理
  },
  {
    member_name  = "developer_lisi"
    service_name = "Web Application Firewall"  # ID: 24 - WAF管理
  },
  
  # 为安全团队委派安全相关服务
  {
    member_name  = "security_wangwu"
    service_name = "Cloud Security Center"     # ID: 15 - 云安全中心
  },
  {
    member_name  = "security_wangwu"
    service_name = "Web Application Firewall"  # ID: 24 - WAF管理
  },
  
  # 为财务人员委派财务相关服务
  {
    member_name  = "finance_zhaoliu"
    service_name = "Billing Center"            # ID: 13 - 计费中心
  },
  
  # 为管理员委派管理相关服务
  {
    member_name  = "admin_liqi"
    service_name = "Control Center"            # ID: 17 - 控制中心
  },
  {
    member_name  = "admin_liqi"
    service_name = "CloudAudit"                # ID: 12 - 云审计
  },
  {
    member_name  = "admin_liqi"
    service_name = "Config"                    # ID: 18 - 配置管理
  }
]
```

### 使用成员UIN配置示例

```hcl
# 使用成员UIN进行服务委派
service_assign_list = [
  {
    member_uin    = 1000000001                 # 技术总监UIN
    service_name  = "Cloud Virtual Machine"    # 云虚拟机管理
  },
  {
    member_uin    = 1000000001
    service_name  = "Key Management Service"   # 密钥管理
  },
  {
    member_uin    = 1000000002                 # 安全主管UIN
    service_name  = "Cloud Security Center"    # 云安全中心
  },
  {
    member_uin    = 1000000002
    service_name  = "Web Application Firewall" # WAF管理
  },
  {
    member_uin    = 1000000003                 # 财务总监UIN
    service_name  = "Billing Center"           # 计费中心
  },
  {
    member_uin    = 1000000004                 # 系统管理员UIN
    service_name  = "Control Center"           # 控制中心
  },
  {
    member_uin    = 1000000004
    service_name  = "CloudAudit"               # 云审计
  }
]
```

### 混合配置示例

```hcl
# 混合使用成员名称和UIN进行配置
service_assign_list = [
  # 使用成员名称配置
  {
    member_name  = "tech_director"
    service_name = "Cloud Virtual Machine"     # 云虚拟机管理
  },
  {
    member_name  = "tech_director"
    service_name = "Key Management Service"    # 密钥管理
  },
  
  # 使用成员UIN配置
  {
    member_uin   = 1000000005                  # 安全专家UIN
    service_name = "Cloud Security Center"     # 云安全中心
  },
  {
    member_uin   = 1000000005
    service_name = "Web Application Firewall"  # WAF管理
  },
  
  # 为整个团队委派服务
  {
    member_name  = "dev_team_lead"
    service_name = "Cloud Virtual Machine"     # 开发团队云虚拟机
  },
  {
    member_name  = "sec_team_lead"
    service_name = "Cloud Security Center"     # 安全团队云安全
  },
  {
    member_name  = "fin_team_lead"
    service_name = "Billing Center"            # 财务团队计费
  }
]
```

### 企业级服务委派配置

```hcl
# 企业级精细化服务权限管理
service_assign_list = [
  # 基础设施团队
  {
    member_name  = "infra_manager"
    service_name = "Cloud Virtual Machine"     # 虚拟机管理
  },
  {
    member_name  = "infra_manager"
    service_name = "Key Management Service"    # 密钥管理
  },
  {
    member_name  = "infra_engineer"
    service_name = "Cloud Virtual Machine"     # 虚拟机操作
  },
  
  # 安全运维团队
  {
    member_name  = "secops_manager"
    service_name = "Cloud Security Center"     # 安全中心管理
  },
  {
    member_name  = "secops_manager"
    service_name = "Web Application Firewall"  # WAF管理
  },
  {
    member_name  = "secops_analyst"
    service_name = "Cloud Security Center"     # 安全分析
  },
  
  # 网络团队
  {
    member_name  = "network_admin"
    service_name = "Web Application Firewall"  # WAF配置
  },
  
  # 财务团队
  {
    member_name  = "finance_director"
    service_name = "Billing Center"            # 财务总监计费权限
  },
  {
    member_name  = "finance_manager"
    service_name = "Billing Center"            # 财务经理计费权限
  },
  
  # 合规审计团队
  {
    member_name  = "compliance_auditor"
    service_name = "CloudAudit"                # 审计权限
  },
  {
    member_name  = "compliance_auditor"
    service_name = "Config"                    # 配置审计
  },
  
  # 管理团队
  {
    member_name  = "it_director"
    service_name = "Control Center"            # 控制中心管理
  },
  {
    member_name  = "it_director"
    service_name = "CloudAudit"                # 审计管理
  }
]
```

---

## 使用示例

### 示例一：开发团队服务委派

```hcl
# 开发团队服务权限配置
service_assign_list = [
  # 开发总监 - 全开发服务权限
  {
    member_name  = "dev_director"
    service_name = "Cloud Virtual Machine"     # 虚拟机资源管理
  },
  {
    member_name  = "dev_director"
    service_name = "Key Management Service"    # 密钥安全管理
  },
  {
    member_name  = "dev_director"
    service_name = "Web Application Firewall"  # WAF配置管理
  },
  
  # 后端开发团队 - 虚拟机权限
  {
    member_name  = "backend_team_lead"
    service_name = "Cloud Virtual Machine"     # 团队虚拟机管理
  },
  {
    member_name  = "backend_senior_dev"
    service_name = "Cloud Virtual Machine"     # 高级开发虚拟机
  },
  {
    member_name  = "backend_junior_dev"
    service_name = "Cloud Virtual Machine"     # 初级开发虚拟机
  },
  
  # 前端开发团队 - WAF权限
  {
    member_name  = "frontend_team_lead"
    service_name = "Web Application Firewall"  # 团队WAF管理
  },
  {
    member_name  = "frontend_dev"
    service_name = "Web Application Firewall"  # 前端WAF配置
  }
]
```

### 示例二：安全团队服务委派

```hcl
# 安全团队服务权限配置
service_assign_list = [
  # 安全总监 - 全安全服务权限
  {
    member_name  = "security_director"
    service_name = "Cloud Security Center"     # 云安全中心管理
  },
  {
    member_name  = "security_director"
    service_name = "Web Application Firewall"  # WAF全局管理
  },
  {
    member_name  = "security_director"
    service_name = "Key Management Service"    # 密钥安全管理
  },
  
  # 安全分析师 - 监控分析权限
  {
    member_name  = "security_analyst"
    service_name = "Cloud Security Center"     # 安全事件分析
  },
  {
    member_name  = "security_analyst"
    service_name = "Web Application Firewall"  # WAF日志分析
  },
  
  # 安全工程师 - 实施配置权限
  {
    member_name  = "security_engineer"
    service_name = "Web Application Firewall"  # WAF规则配置
  },
  {
    member_name  = "security_engineer"
    service_name = "Key Management Service"    # 密钥轮换配置
  }
]
```

### 示例三：混合团队服务委派

```hcl
# 跨团队服务权限配置
service_assign_list = [
  # 项目管理办公室 - 全局监控权限
  {
    member_name  = "pmo_director"
    service_name = "Control Center"            # 控制中心查看
  },
  {
    member_name  = "pmo_director"
    service_name = "Billing Center"            # 项目成本监控
  },
  {
    member_name  = "pmo_manager"
    service_name = "Billing Center"            # 项目费用管理
  },
  
  # 基础设施团队 - 资源管理权限
  {
    member_name  = "infra_team_lead"
    service_name = "Cloud Virtual Machine"     # 虚拟机配额管理
  },
  {
    member_name  = "infra_engineer"
    service_name = "Cloud Virtual Machine"     # 虚拟机日常操作
  },
  
  # 合规团队 - 审计监控权限
  {
    member_name  = "compliance_officer"
    service_name = "CloudAudit"                # 操作审计
  },
  {
    member_name  = "compliance_officer"
    service_name = "Config"                    # 配置合规检查
  },
  
  # 客户支持团队 - 有限权限
  {
    member_name  = "support_team_lead"
    service_name = "Billing Center"            # 客户账单查询
  },
  {
    member_name  = "support_engineer"
    service_name = "Cloud Virtual Machine"     # 客户资源查看
  }
]
```

---

## 配置说明

### 成员识别方式

模块支持两种成员识别方式：

1. **通过成员名称识别**
   - 使用`member_name`字段指定成员名称
   - 模块自动查询并映射到对应的成员UIN
   - 适合名称已知但UIN未知的场景
   - 需要确保成员名称在组织中唯一

2. **通过成员UIN识别**
   - 使用`member_uin`字段指定成员UIN
   - 直接使用指定的UIN进行委派
   - 适合UIN已知且需要精确控制的场景
   - 需要确保UIN正确且成员存在

### 服务权限说明

| 服务类型 | 权限级别 | 适用角色 | 管理范围 |
|----------|----------|----------|----------|
| **资源管理类** | 操作权限 | 运维工程师 | 虚拟机、密钥等资源 |
| **安全防护类** | 安全权限 | 安全工程师 | WAF、安全中心等 |
| **财务成本类** | 财务权限 | 财务人员 | 账单、成本等 |
| **审计合规类** | 审计权限 | 合规人员 | 审计日志、配置等 |
| **管理控制类** | 管理权限 | 管理人员 | 控制中心、配置等 |

### 自动映射机制

模块内置自动映射功能：
- 自动查询组织中所有成员信息
- 建立成员名称到UIN的映射表
- 支持动态解析成员名称
- 处理成员不存在的情况
- 确保委派操作的准确性

### 最佳实践建议

1. **权限分离原则**
   - 按职责分配最小必要权限
   - 避免过度委派
   - 定期审计权限分配

2. **命名规范**
   - 制定统一的成员命名规范
   - 确保成员名称唯一性
   - 便于权限管理和审计

3. **服务分组**
   - 按功能分组委派服务
   - 同类服务集中管理
   - 避免权限碎片化

4. **监控审计**
   - 启用操作日志记录
   - 定期检查权限使用情况
   - 及时调整不必要的权限

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **成员识别**
   - `member_uin`和`member_name`必须二选一
   - 不能同时为空或同时设置
   - 确保指定的成员存在

2. **服务可用性**
   - 确保要委派的服务已开通
   - 检查服务状态是否正常
   - 确认服务兼容性

3. **权限验证**
   - 委派前验证目标成员权限
   - 确保不会造成权限冲突
   - 测试权限生效情况

4. **名称准确性**
   - 成员名称必须精确匹配
   - 大小写敏感
   - 避免使用易混淆名称

5. **UIN准确性**
   - UIN必须准确无误
   - 避免使用错误的UIN
   - 定期核对UIN信息

6. **服务限制**
   - 了解各服务的功能限制
   - 注意服务之间的依赖关系
   - 避免冲突配置

7. **操作顺序**
   - 先创建成员再委派服务
   - 按依赖关系顺序操作
   - 避免循环依赖

8. **备份恢复**
   - 定期备份权限配置
   - 准备恢复方案
   - 测试恢复流程

9. **变更管理**
   - 记录所有权限变更
   - 通知相关受影响方
   - 评估变更影响

10. **合规要求**
    - 遵守企业内部合规要求
    - 满足行业监管要求
    - 定期进行合规检查

---

## 故障排除

### 常见错误及解决方案

#### 错误一：成员不存在

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Member not found
```

**原因**：指定的成员名称或UIN不存在
**解决方案**：
- 检查成员名称拼写是否正确
- 确认成员UIN是否正确
- 确保成员已在组织中创建

#### 错误二：服务不存在

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Service not found
```

**原因**：指定的服务名称不存在或未开通
**解决方案**：
- 检查服务名称是否正确
- 确认服务是否已开通
- 查看支持的服务列表

#### 错误三：权限不足

```
Error: [TencentCloudSDKError] Code=PermissionDenied
Message=Insufficient permissions
```

**原因**：当前账号权限不足
**解决方案**：
- 检查当前账号权限
- 确认是否有委派权限
- 申请必要的权限

#### 错误四：重复委派

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Service already assigned
```

**原因**：相同的服务已委派给该成员
**解决方案**：
- 检查是否重复配置
- 移除重复的委派配置
- 确认是否需要重复委派

#### 错误五：参数冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Parameter conflict
```

**原因**：同时设置了member_uin和member_name
**解决方案**：
- 只使用一种识别方式
- 移除冲突的参数
- 选择优先使用的方式

#### 错误六：服务限制

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=Service limit exceeded
```

**原因**：达到服务委派数量限制
**解决方案**：
- 检查服务委派限制
- 减少委派数量
- 申请提高限额