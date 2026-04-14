# 腾讯云网络ACL管理模块

## 模块概述

本模块用于在腾讯云VPC（Virtual Private Cloud）中创建和管理网络访问控制列表（Network ACL），实现VPC级别的网络安全控制，主要功能包括：

- **批量ACL创建** - 支持同时创建多个网络ACL
- **入站规则管理** - 配置入站（ingress）流量控制规则
- **出站规则管理** - 配置出站（egress）流量控制规则
- **VPC关联** - 支持通过VPC ID或VPC名称关联ACL
- **标签管理** - 支持为ACL添加标签进行资源管理
- **自动映射** - 自动生成ACL名称到ACL ID的映射

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
| `QcloudTagFullAccess` | 标签管理全权限 |

### 其他要求

- 需要提前创建好VPC网络
- 需要获取VPC ID或VPC名称
- 需要规划好网络ACL的规则策略
- 需要了解网络协议和端口配置

---

## 变量说明

### 网络ACL配置变量

| 变量名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| `network_acls` | `list(object)` | 是 | 网络ACL配置列表 |
| `↳ acl_name` | `string` | 是 | ACL名称（必须唯一） |
| `↳ vpc_id` | `string` | 否 | VPC ID |
| `↳ vpc_name` | `string` | 否 | VPC名称 |
| `↳ ingress_rules` | `list(object)` | 否 | 入站规则列表 |
| `↳↳ action` | `string` | 是 | 动作（ACCEPT: 允许, DROP: 拒绝） |
| `↳↳ cidr` | `string` | 是 | IP地址网络或网段 |
| `↳↳ port` | `string` | 是 | 端口（格式: 80, 80-90, ALL） |
| `↳↳ protocol` | `string` | 是 | 协议（TCP, UDP, ICMP, ALL） |
| `↳↳ desc` | `string` | 是 | 规则描述（必须大写） |
| `↳ egress_rules` | `list(object)` | 否 | 出站规则列表 |
| `↳↳ action` | `string` | 是 | 动作（ACCEPT: 允许, DROP: 拒绝） |
| `↳↳ cidr` | `string` | 是 | IP地址网络或网段 |
| `↳↳ port` | `string` | 是 | 端口（格式: 80, 80-90, ALL） |
| `↳↳ protocol` | `string` | 是 | 协议（TCP, UDP, ICMP, ALL） |
| `↳↳ desc` | `string` | 是 | 规则描述（必须大写） |
| `↳ tags` | `map(string)` | 否 | ACL标签 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 网络ACL配置示例
network_acls = [
  {
    acl_name = "web-tier-acl"
    vpc_name = "production-vpc"
    
    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "80"
        protocol = "TCP"
        desc     = "ALLOW HTTP FROM INTERNAL"
      },
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "443"
        protocol = "TCP"
        desc     = "ALLOW HTTPS FROM INTERNAL"
      },
      {
        action   = "DROP"
        cidr     = "0.0.0.0/0"
        port     = "ALL"
        protocol = "ALL"
        desc     = "DENY ALL OTHER TRAFFIC"
      }
    ]
    
    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "80"
        protocol = "TCP"
        desc     = "ALLOW HTTP TO INTERNET"
      },
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "443"
        protocol = "TCP"
        desc     = "ALLOW HTTPS TO INTERNET"
      }
    ]
    
    tags = {
      Environment = "production"
      Tier        = "web"
      ManagedBy   = "terraform"
    }
  },
  {
    acl_name = "db-tier-acl"
    vpc_id   = "vpc-xxxxxx"
    
    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.1.0/24"
        port     = "3306"
        protocol = "TCP"
        desc     = "ALLOW MYSQL FROM WEB TIER"
      },
      {
        action   = "DROP"
        cidr     = "0.0.0.0/0"
        port     = "ALL"
        protocol = "ALL"
        desc     = "DENY ALL OTHER TRAFFIC"
      }
    ]
    
    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.1.0/24"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW ALL TO WEB TIER"
      }
    ]
  }
]
```

### 简单配置示例

```hcl
# 基础配置示例
network_acls = [
  {
    acl_name = "basic-acl"
    vpc_name = "my-vpc"
    
    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW ALL INTERNAL TRAFFIC"
      }
    ]
    
    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW ALL OUTBOUND TRAFFIC"
      }
    ]
  }
]
```

---

## 使用示例

### 示例一：Web层ACL配置

```hcl
# Web层网络ACL配置
network_acls = [
  {
    acl_name = "web-acl"
    vpc_name = "app-vpc"
    
    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "80"
        protocol = "TCP"
        desc     = "ALLOW HTTP FROM INTERNET"
      },
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "443"
        protocol = "TCP"
        desc     = "ALLOW HTTPS FROM INTERNET"
      },
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW ALL INTERNAL TRAFFIC"
      }
    ]
    
    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "80"
        protocol = "TCP"
        desc     = "ALLOW HTTP TO INTERNET"
      },
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "443"
        protocol = "TCP"
        desc     = "ALLOW HTTPS TO INTERNET"
      },
      {
        action   = "ACCEPT"
        cidr     = "10.0.1.0/24"
        port     = "3306"
        protocol = "TCP"
        desc     = "ALLOW MYSQL TO DB TIER"
      }
    ]
    
    tags = {
      Environment = "production"
      Tier        = "web"
    }
  }
]
```

### 示例二：数据库层ACL配置

```hcl
# 数据库层网络ACL配置
network_acls = [
  {
    acl_name = "db-acl"
    vpc_id   = "vpc-abcdef"
    
    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/24"
        port     = "3306"
        protocol = "TCP"
        desc     = "ALLOW MYSQL FROM WEB TIER"
      },
      {
        action   = "ACCEPT"
        cidr     = "10.0.2.0/24"
        port     = "5432"
        protocol = "TCP"
        desc     = "ALLOW POSTGRES FROM APP TIER"
      },
      {
        action   = "DROP"
        cidr     = "0.0.0.0/0"
        port     = "ALL"
        protocol = "ALL"
        desc     = "DENY ALL OTHER TRAFFIC"
      }
    ]
    
    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW ALL INTERNAL TRAFFIC"
      }
    ]
    
    tags = {
      Environment = "production"
      Tier        = "database"
      DataClass   = "sensitive"
    }
  }
]
```

### 示例三：多ACL批量配置

```hcl
# 多ACL批量配置示例
network_acls = [
  # Web层ACL
  {
    acl_name = "web-acl"
    vpc_name = "multi-tier-vpc"
    
    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "80"
        protocol = "TCP"
        desc     = "ALLOW HTTP"
      },
      {
        action   = "ACCEPT"
        cidr     = "0.0.0.0/0"
        port     = "443"
        protocol = "TCP"
        desc     = "ALLOW HTTPS"
      }
    ]
    
    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.1.0/24"
        port     = "3306"
        protocol = "TCP"
        desc     = "ALLOW DB ACCESS"
      }
    ]
  },
  
  # App层ACL
  {
    acl_name = "app-acl"
    vpc_name = "multi-tier-vpc"
    
    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/24"
        port     = "8080"
        protocol = "TCP"
        desc     = "ALLOW APP TRAFFIC"
      }
    ]
    
    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.2.0/24"
        port     = "5432"
        protocol = "TCP"
        desc     = "ALLOW DB ACCESS"
      }
    ]
  },
  
  # DB层ACL
  {
    acl_name = "db-acl"
    vpc_name = "multi-tier-vpc"
    
    ingress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/24"
        port     = "3306"
        protocol = "TCP"
        desc     = "ALLOW MYSQL"
      },
      {
        action   = "ACCEPT"
        cidr     = "10.0.1.0/24"
        port     = "5432"
        protocol = "TCP"
        desc     = "ALLOW POSTGRES"
      }
    ]
    
    egress_rules = [
      {
        action   = "ACCEPT"
        cidr     = "10.0.0.0/16"
        port     = "ALL"
        protocol = "ALL"
        desc     = "ALLOW INTERNAL"
      }
    ]
  }
]
```

---

## 配置说明

### 规则格式说明

网络ACL规则使用特定格式：`[action]#[cidr]#[port]#[protocol]#[description]`

| 字段 | 说明 | 允许值 |
|------|------|--------|
| **action** | 动作 | `ACCEPT`, `DROP` |
| **cidr** | IP地址/网段 | 有效的IP地址或CIDR格式 |
| **port** | 端口范围 | `80`, `80-90`, `ALL` |
| **protocol** | 协议类型 | `TCP`, `UDP`, `ICMP`, `ALL` |
| **description** | 规则描述 | 必须为大写字母 |

### 协议与端口约束

| 协议 | 端口约束 | 说明 |
|------|----------|------|
| `TCP` | 任意端口 | 支持具体端口或范围 |
| `UDP` | 任意端口 | 支持具体端口或范围 |
| `ICMP` | 必须为 `ALL` | ICMP协议不需要端口 |
| `ALL` | 必须为 `ALL` | 所有协议和端口 |

### VPC关联方式

支持两种VPC关联方式：
- **VPC ID** - 直接使用VPC ID进行关联
- **VPC名称** - 通过VPC名称自动查找对应ID

> **注意**: VPC ID和VPC名称不能同时为空，如果同时提供，优先使用VPC ID

### 输出映射

模块自动生成ACL名称到ACL ID的映射：
```hcl
acl_ids = {
  "web-tier-acl" = "acl-xxxxxx"
  "db-tier-acl"  = "acl-yyyyyy"
}
```

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **权限配置**
   - 确保执行账号具有VPC管理相关权限
   - 需要`QcloudVPCFullAccess`权限

2. **VPC要求**
   - VPC必须提前创建好
   - 确保VPC ID或VPC名称正确

3. **ACL名称唯一性**
   - ACL名称在VPC内必须唯一
   - 避免使用重复的ACL名称

4. **规则顺序**
   - ACL规则按顺序执行
   - 第一条匹配的规则决定流量处理
   - 建议从具体到一般排列规则

5. **协议端口约束**
   - ICMP协议端口必须为`ALL`
   - ALL协议端口必须为`ALL`
   - 违反约束会导致创建失败

6. **描述格式**
   - 规则描述必须使用大写字母
   - 建议使用英文描述便于管理

7. **批量操作**
   - 支持批量创建多个ACL
   - 每个ACL独立配置规则
   - 建议按业务层级分组配置

8. **标签管理**
   - 支持为ACL添加标签
   - 便于资源分类和管理
   - 建议添加环境、层级等标签

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少VPC管理权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含`QcloudVPCFullAccess`权限

#### 错误二：VPC不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=VPC not found
```

**原因**：指定的VPC ID或VPC名称不存在
**解决方案**：
- 确认VPC ID或VPC名称正确
- 检查VPC是否已被删除

#### 错误三：ACL名称重复

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Network ACL name already exists
```

**原因**：ACL名称在VPC内已存在
**解决方案**：
- 使用唯一的ACL名称
- 检查是否已有同名ACL
- 添加前缀或后缀区分

#### 错误四：规则格式错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid rule format
```

**原因**：规则格式不符合要求
**解决方案**：
- 检查规则格式是否正确
- 验证协议和端口约束
- 确保描述为大写字母

#### 错误五：协议端口不匹配

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Protocol and port mismatch
```

**原因**：协议和端口配置不匹配
**解决方案**：
- ICMP协议端口必须为`ALL`
- ALL协议端口必须为`ALL`
- 调整协议或端口配置

#### 错误六：CIDR格式错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid CIDR format
```

**原因**：CIDR格式不正确
**解决方案**：
- 检查CIDR格式是否正确
- 确保为有效的IP地址或网段
- 使用标准CIDR表示法