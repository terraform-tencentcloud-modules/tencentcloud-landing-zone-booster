# 腾讯云安全组管理模块

## 模块概述

本模块用于在腾讯云中批量创建和管理安全组（Security Group），提供灵活的网络安全策略配置，主要功能包括：

- **批量安全组创建** - 支持一次性创建多个安全组
- **入站规则管理** - 配置入站流量访问控制策略
- **出站规则管理** - 配置出站流量访问控制策略
- **模板化配置** - 支持地址模板和协议模板
- **优先级控制** - 规则按配置顺序应用优先级
- **标签管理** - 支持为安全组添加标签
- **项目隔离** - 支持按项目ID进行资源隔离
- **ID映射输出** - 输出安全组名称到ID的映射关系

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
| `QcloudVPCFullAccess` | VPC管理全权限 |
| `QcloudSecurityGroupFullAccess` | 安全组管理全权限 |
| `QcloudTagFullAccess` | 标签管理全权限 |

### 其他要求

- 需要规划好安全组的命名规范
- 需要了解网络访问控制需求
- 需要确定安全组规则优先级
- 需要规划好标签策略
- 需要了解项目ID（如适用）

---

## 变量说明

### 安全组配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `security_groups` | `list(object)` | 否 | `[]` | 安全组配置列表 |

### 安全组对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `name` | `string` | 是 | - | 安全组名称 |
| `project_id` | `number` | 否 | - | 项目ID |
| `description` | `string` | 否 | - | 安全组描述 |
| `tags` | `map(string)` | 否 | `{}` | 安全组标签 |
| `ingress_rules` | `list(object)` | 否 | `[]` | 入站规则列表 |
| `egress_rules` | `list(object)` | 否 | `[]` | 出站规则列表 |

### 安全组规则对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `action` | `string` | 是 | - | 规则策略：`ACCEPT` 或 `DROP` |
| `cidr_block` | `string` | 否 | - | IP地址网络或CIDR段 |
| `ipv6_cidr_block` | `string` | 否 | - | IPv6地址网络或CIDR段 |
| `protocol` | `string` | 否 | `ALL` | 协议类型：`TCP`, `UDP`, `ICMP`, `ICMPv6`, `ALL` |
| `port` | `string` | 否 | `all` | 端口范围：`all`, 单端口, 端口范围 |
| `source_security_id` | `string` | 否 | - | 嵌套安全组ID |
| `address_template_id` | `string` | 否 | - | 地址模板ID（如 `ipm-xxxxxxxx`） |
| `address_template_group` | `string` | 否 | - | 地址模板组ID（如 `ipmg-xxxxxxxx`） |
| `service_template_id` | `string` | 否 | - | 协议模板ID（如 `ppm-xxxxxxxx`） |
| `service_template_group` | `string` | 否 | - | 协议模板组ID（如 `ppmg-xxxxxxxx`） |
| `description` | `string` | 否 | - | 规则描述 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 基础安全组配置
security_groups = [
  {
    name        = "web-servers"
    description = "Security group for web servers"
    project_id  = 123456
    tags = {
      Environment = "production"
      Role        = "web"
      ManagedBy   = "terraform"
    }
    
    # 入站规则
    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Allow HTTP access from anywhere"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Allow HTTPS access from anywhere"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "22"
        description = "Allow SSH access from internal network"
      }
    ]
    
    # 出站规则
    egress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "ALL"
        port        = "all"
        description = "Allow all outbound traffic"
      }
    ]
  },
  
  {
    name        = "database-servers"
    description = "Security group for database servers"
    tags = {
      Environment = "production"
      Role        = "database"
    }
    
    # 入站规则
    ingress_rules = [
      {
        action              = "ACCEPT"
        source_security_id  = "sg-web-servers" # 引用web安全组
        protocol            = "TCP"
        port                = "3306"
        description         = "Allow MySQL access from web servers"
      },
      {
        action              = "ACCEPT"
        source_security_id  = "sg-app-servers" # 引用应用安全组
        protocol            = "TCP"
        port                = "5432"
        description         = "Allow PostgreSQL access from app servers"
      }
    ]
    
    # 出站规则
    egress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Allow HTTP outbound for updates"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Allow HTTPS outbound for updates"
      }
    ]
  }
]
```

### 使用模板配置示例

```hcl
# 使用地址模板和协议模板的安全组配置
security_groups = [
  {
    name        = "template-based-sg"
    description = "Security group using templates"
    
    ingress_rules = [
      {
        action               = "ACCEPT"
        address_template_id  = "ipm-12345678"  # 地址模板ID
        service_template_id  = "ppm-87654321"  # 协议模板ID
        description          = "Allow access based on address and service templates"
      }
    ],
    
    egress_rules = [
      {
        action                 = "ACCEPT"
        address_template_group = "ipmg-abcdefgh"  # 地址模板组ID
        service_template_group = "ppmg-hgfedcba"  # 协议模板组ID
        description            = "Allow outbound based on template groups"
      }
    ]
  }
]
```

### IPv6配置示例

```hcl
# IPv6安全组配置
security_groups = [
  {
    name        = "ipv6-enabled-sg"
    description = "Security group with IPv6 support"
    
    ingress_rules = [
      {
        action          = "ACCEPT"
        ipv6_cidr_block = "2001:db8::/32"
        protocol        = "TCP"
        port            = "80"
        description     = "Allow HTTP from IPv6 network"
      },
      {
        action          = "ACCEPT"
        ipv6_cidr_block = "2001:db8::/32"
        protocol        = "TCP"
        port            = "443"
        description     = "Allow HTTPS from IPv6 network"
      }
    ],
    
    egress_rules = [
      {
        action          = "ACCEPT"
        ipv6_cidr_block = "::/0"
        protocol        = "ALL"
        port            = "all"
        description     = "Allow all IPv6 outbound traffic"
      }
    ]
  }
]
```

### 多环境配置示例

```hcl
# 多环境安全组配置
security_groups = [
  # 开发环境
  {
    name        = "dev-web-sg"
    description = "Development web servers security group"
    tags = {
      Environment = "development"
      Role        = "web"
    }
    
    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "80"
        description = "Dev HTTP access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "443"
        description = "Dev HTTPS access"
      }
    ]
  },
  
  # 测试环境
  {
    name        = "test-web-sg"
    description = "Testing web servers security group"
    tags = {
      Environment = "testing"
      Role        = "web"
    }
    
    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "10.1.0.0/16"
        protocol    = "TCP"
        port        = "80"
        description = "Test HTTP access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.1.0.0/16"
        protocol    = "TCP"
        port        = "443"
        description = "Test HTTPS access"
      }
    ]
  },
  
  # 生产环境
  {
    name        = "prod-web-sg"
    description = "Production web servers security group"
    tags = {
      Environment = "production"
      Role        = "web"
      SLA         = "99.95%"
    }
    
    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Prod HTTP access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Prod HTTPS access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.2.0.0/16"
        protocol    = "TCP"
        port        = "22"
        description = "Prod SSH access from internal"
      }
    ]
  }
]
```

---

## 使用示例

### 示例一：Web应用安全组

```hcl
# Web应用安全组配置
security_groups = [
  {
    name        = "web-application-sg"
    description = "Security group for web application servers"
    project_id  = 1001
    tags = {
      Environment = "production"
      Application = "ecommerce"
      Tier        = "web"
    }
    
    # 入站规则 - 外部访问
    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Public HTTP access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Public HTTPS access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "22"
        description = "SSH from internal network"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "8080"
        description = "Internal application port"
      }
    ]
    
    # 出站规则
    egress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Outbound HTTP"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Outbound HTTPS"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "3306"
        description = "Database access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "6379"
        description = "Redis access"
      }
    ]
  }
]
```

### 示例二：数据库安全组

```hcl
# 数据库安全组配置
security_groups = [
  {
    name        = "database-sg"
    description = "Security group for database servers"
    project_id  = 1001
    tags = {
      Environment = "production"
      Application = "ecommerce"
      Tier        = "database"
    }
    
    # 入站规则 - 仅允许特定安全组访问
    ingress_rules = [
      {
        action              = "ACCEPT"
        source_security_id  = "sg-web-application"  # Web应用安全组
        protocol            = "TCP"
        port                = "3306"
        description         = "MySQL access from web servers"
      },
      {
        action              = "ACCEPT"
        source_security_id  = "sg-application"      # 应用服务器安全组
        protocol            = "TCP"
        port                = "3306"
        description         = "MySQL access from app servers"
      },
      {
        action              = "ACCEPT"
        source_security_id  = "sg-bastion"          # 堡垒机安全组
        protocol            = "TCP"
        port                = "22"
        description         = "SSH access from bastion"
      }
    ]
    
    # 出站规则 - 限制出站流量
    egress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "53"
        description = "DNS queries"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80"
        description = "Package updates"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "443"
        description = "Secure package updates"
      }
    ]
  }
]
```

### 示例三：堡垒机安全组

```hcl
# 堡垒机安全组配置
security_groups = [
  {
    name        = "bastion-sg"
    description = "Security group for bastion host"
    project_id  = 1001
    tags = {
      Environment = "production"
      Role        = "bastion"
      Access      = "restricted"
    }
    
    # 入站规则 - 严格限制访问
    ingress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "203.0.113.0/24"  # 公司办公网
        protocol    = "TCP"
        port        = "22"
        description = "SSH from office network"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "198.51.100.0/24" # VPN网络
        protocol    = "TCP"
        port        = "22"
        description = "SSH from VPN network"
      }
    ]
    
    # 出站规则 - 允许访问所有内部服务
    egress_rules = [
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "22"
        description = "SSH to all internal servers"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "3389"
        description = "RDP to Windows servers"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "5985"
        description = "WinRM access"
      },
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16"
        protocol    = "TCP"
        port        = "all"
        description = "All protocols to internal network"
      }
    ]
  }
]
```

---

## 配置说明

### 安全组规则优先级说明

安全组规则按照配置顺序应用优先级，**第一条规则具有最高优先级**。规则匹配是顺序执行的，一旦匹配到规则就停止后续匹配。

### 地址源类型互斥说明

以下地址源类型互斥，不能同时设置：
- `cidr_block` - IP地址网络或CIDR段
- `ipv6_cidr_block` - IPv6地址网络或CIDR段
- `source_security_id` - 嵌套安全组ID
- `address_template_id` - 地址模板ID
- `address_template_group` - 地址模板组ID

**必须设置其中一种地址源类型**。

### 协议端口配置说明

- **协议类型**：支持 `TCP`, `UDP`, `ICMP`, `ICMPv6`, `ALL`
- **端口配置**：支持 `all`、单端口（如 `80`）、端口范围（如 `80-90`）、端口列表（如 `80,90`）
- **特殊规则**：如果协议设置为 `ALL`，端口也必须设置为 `all`

### 模板使用说明

| 模板类型 | 格式 | 说明 |
|----------|------|------|
| **地址模板** | `ipm-xxxxxxxx` | 预定义的IP地址集合 |
| **地址模板组** | `ipmg-xxxxxxxx` | 地址模板的组集合 |
| **协议模板** | `ppm-xxxxxxxx` | 预定义的协议端口组合 |
| **协议模板组** | `ppmg-xxxxxxxx` | 协议模板的组集合 |

### 输出说明

模块输出安全组名称到ID的映射关系：
```hcl
security_group_ids = {
  "web-servers"      = "sg-12345678"
  "database-servers" = "sg-87654321"
  "bastion-sg"       = "sg-abcdefgh"
}
```

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **规则优先级**
   - 规则按配置顺序应用，第一条规则优先级最高
   - 仔细规划规则顺序，避免意外的访问控制
   - 建议将拒绝规则放在最后

2. **地址源配置**
   - 确保只设置一种地址源类型
   - CIDR块要使用正确的网络掩码
   - 嵌套安全组ID必须引用已存在的安全组

3. **协议端口配置**
   - 协议为 `ALL` 时端口必须为 `all`
   - 端口范围使用连字符（如 `80-90`）
   - 端口列表使用逗号分隔（如 `80,443`）

4. **模板使用**
   - 确保模板ID正确且存在
   - 模板和直接配置互斥，不能同时使用
   - 了解模板的具体内容和使用限制

5. **安全最佳实践**
   - 遵循最小权限原则
   - 定期审查和清理安全组规则
   - 使用描述字段记录规则用途
   - 实施网络分段和隔离

6. **性能考虑**
   - 安全组规则数量影响网络性能
   - 合理规划规则数量，避免过多规则
   - 考虑使用网络ACL进行粗粒度控制

7. **变更管理**
   - 记录所有安全组变更
   - 测试规则变更对业务的影响
   - 制定回滚计划

8. **监控审计**
   - 启用安全组流量日志
   - 监控异常访问模式
   - 定期进行安全审计

---

## 故障排除

### 常见错误及解决方案

#### 错误一：地址源类型冲突

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Conflict address source types
```

**原因**：同时设置了多种地址源类型
**解决方案**：
- 检查规则配置，确保只设置一种地址源
- 移除冲突的地址源配置
- 重新规划地址源选择

#### 错误二：协议端口不匹配

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Protocol and port mismatch
```

**原因**：协议为 `ALL` 但端口不是 `all`
**解决方案**：
- 将端口设置为 `all` 当协议为 `ALL` 时
- 或者选择具体的协议类型

#### 错误三：安全组不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Security group not found
```

**原因**：引用的嵌套安全组不存在
**解决方案**：
- 确认引用的安全组ID正确
- 确保引用的安全组已创建
- 检查安全组名称拼写

#### 错误四：模板不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Template not found
```

**原因**：引用的模板ID不存在
**解决方案**：
- 确认模板ID正确
- 检查模板是否已创建
- 验证模板权限

#### 错误五：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少必要权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含安全组管理权限
- 验证项目权限（如设置project_id）

#### 错误六：配额限制

```
Error: [TencentCloudSDKError] Code=QuotaExceeded
Message=Security group quota exceeded
```

**原因**：达到安全组或规则配额限制
**解决方案**：
- 检查安全组和规则配额
- 申请提高配额或删除无用资源
- 合并相似的安全组规则