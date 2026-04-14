# 腾讯云云防火墙（CFW）VPC防火墙路由重配置模块

## 模块概述

本模块用于在腾讯云中配置和管理云防火墙（Cloud Firewall，CFW）的VPC防火墙路由重配置功能，主要提供以下核心能力：

- **路由重配置** - 自动重配置VPC防火墙相关路由
- **HAVIP支持** - 支持高可用虚拟IP（HAVIP）作为下一跳类型
- **VPC集成** - 与VPC防火墙无缝集成
- **网关管理** - 管理VPC防火墙网关路由配置
- **自动化部署** - 自动化路由重配置流程

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
| `QcloudCFWFullAccess` | 云防火墙全权限 |
| `QcloudVPCFullAccess` | VPC网络权限 |
| `QcloudHAVIPFullAccess` | HAVIP高可用虚拟IP权限 |

### 其他要求

- 需要已部署VPC防火墙实例
- 需要获取VPC防火墙的VPC ID
- 需要获取VPC防火墙的网关ID
- 需要确认网络拓扑和路由需求
- 需要规划HAVIP配置（如适用）

---

## 变量说明

### 必需配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `vpc_id` | `string` | 是 | - | VPC防火墙的VPC ID |
| `gateway_id` | `string` | 是 | - | VPC防火墙的网关ID |

### 固定配置参数

| 参数名 | 值 | 说明 |
|--------|----|------|
| `route_next_type` | `HAVIP` | 路由下一跳类型，固定为高可用虚拟IP |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# VPC防火墙路由重配置
vpc_id     = "vpc-abcdef123456"  # VPC防火墙的VPC ID
gateway_id = "vpngw-1234567890"  # VPC防火墙的网关ID
```

### 完整部署示例

```hcl
# 引用VPC防火墙路由重配置模块
module "vpc_fw_route_reconfig" {
  source = "../components/security/cfw/fw-vpc-route-reconfig"

  vpc_id     = "vpc-abcdef123456"  # 从VPC防火墙模块获取
  gateway_id = "vpngw-1234567890"  # 从VPC防火墙模块获取
}

# 输出重配置结果
output "route_reconfig_status" {
  description = "VPC防火墙路由重配置状态"
  value       = module.vpc_fw_route_reconfig
}
```

### 与VPC防火墙模块集成示例

```hcl
# 部署VPC防火墙
module "vpc_firewall" {
  source = "../components/security/cfw/fw-vpc"

  name        = "prod-vpc-fw"
  mode        = 0
  switch_mode = 1
  fw_cidr     = "auto"
  
  fw_instances = [
    {
      name = "vpc-fw-instance"
      fw_deploy = [
        {
          deploy_region = "ap-beijing"
          width         = 1000
          zone_set      = ["ap-beijing-1", "ap-beijing-2"]
          cross_a_zone  = 0
        }
      ]
      vpc_ids = ["vpc-abcdef123456"]
    }
  ]
}

# 部署路由重配置
module "vpc_fw_route_reconfig" {
  source = "../components/security/cfw/fw-vpc-route-reconfig"

  vpc_id     = module.vpc_firewall.vpc_instances.vpc_id  # 从VPC防火墙模块获取VPC ID
  gateway_id = module.vpc_firewall.vpc_instances.gateway_id  # 从VPC防火墙模块获取网关ID
}
```

---

## 使用示例

### 示例一：生产环境路由重配置

```hcl
# 生产环境VPC防火墙
module "prod_vpc_fw" {
  source = "../components/security/cfw/fw-vpc"

  name        = "prod-vpc-fw"
  mode        = 0
  switch_mode = 2  # 多点通信
  fw_cidr     = "10.20.30.0/24"
  
  fw_instances = [
    {
      name = "prod-fw-instance"
      fw_deploy = [
        {
          deploy_region = "ap-beijing"
          width         = 2000
          zone_set      = ["ap-beijing-1", "ap-beijing-2"]
          cross_a_zone  = 1
        }
      ]
      vpc_ids = ["vpc-prod-123456"]
    }
  ]
}

# 生产环境路由重配置
module "prod_route_reconfig" {
  source = "../components/security/cfw/fw-vpc-route-reconfig"

  vpc_id     = module.prod_vpc_fw.vpc_instances.vpc_id
  gateway_id = module.prod_vpc_fw.vpc_instances.gateway_id
}
```

### 示例二：多VPC环境路由重配置

```hcl
# 多VPC防火墙部署
module "multi_vpc_fw" {
  source = "../components/security/cfw/fw-vpc"

  name        = "multi-vpc-fw"
  mode        = 0
  switch_mode = 4  # 自定义路由
  fw_cidr     = "auto"
  
  fw_instances = [
    {
      name = "multi-fw-instance"
      fw_deploy = [
        {
          deploy_region = "ap-shanghai"
          width         = 3000
          zone_set      = ["ap-shanghai-1", "ap-shanghai-2"]
          cross_a_zone  = 1
        }
      ]
      vpc_ids = ["vpc-web-123", "vpc-app-456", "vpc-db-789"]
    }
  ]
}

# 多VPC路由重配置
module "multi_route_reconfig" {
  source = "../components/security/cfw/fw-vpc-route-reconfig"

  vpc_id     = module.multi_vpc_fw.vpc_instances.vpc_id
  gateway_id = module.multi_vpc_fw.vpc_instances.gateway_id
}
```

---

## 配置说明

### 功能说明

#### 路由重配置功能
- **自动路由优化**：自动重配置VPC防火墙相关路由表
- **HAVIP集成**：使用高可用虚拟IP作为路由下一跳
- **故障切换**：支持高可用性和故障切换能力
- **性能优化**：优化网络流量路径，提升性能

#### HAVIP（高可用虚拟IP）
- **高可用性**：提供虚拟IP的高可用性保障
- **负载均衡**：支持流量负载均衡
- **故障检测**：自动检测和切换故障节点
- **透明切换**：对上层应用透明，无需修改配置

### 工作流程

1. **获取VPC信息**：从VPC防火墙模块获取VPC ID和网关ID
2. **路由分析**：分析当前路由配置和优化需求
3. **重配置执行**：执行路由重配置操作
4. **HAVIP配置**：配置高可用虚拟IP作为下一跳
5. **验证测试**：验证路由重配置结果

### 集成架构

```
+----------------+      +-----------------+      +-------------------+
|   VPC防火墙模块  | ---> | 路由重配置模块   | ---> |    网络路由表      |
| (fw-vpc)       |      | (fw-vpc-route)  |      |                   |
+----------------+      +-----------------+      +-------------------+
       |                         |                         |
       v                         v                         v
+----------------+      +-----------------+      +-------------------+
|   VPC实例信息   |      |   HAVIP配置     |      |   优化后的路由     |
+----------------+      +-----------------+      +-------------------+
```

### 最佳实践

1. **部署顺序**：先部署VPC防火墙，再部署路由重配置
2. **依赖管理**：确保路由重配置模块依赖VPC防火墙模块的输出
3. **测试验证**：部署后验证路由配置和网络连通性
4. **监控告警**：配置路由变更监控和异常告警
5. **备份恢复**：定期备份路由配置，准备恢复方案

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **依赖关系**
   - 本模块依赖VPC防火墙模块的输出
   - 确保VPC防火墙已成功部署
   - 验证VPC ID和网关ID的正确性

2. **网络影响**
   - 路由重配置可能影响网络连通性
   - 建议在业务低峰期执行
   - 准备回滚方案

3. **HAVIP配置**
   - 确认HAVIP功能已启用
   - 检查HAVIP配额和限制
   - 验证HAVIP的高可用性

4. **权限要求**
   - 需要VPC、CFW、HAVIP相关权限
   - 验证操作权限是否充足
   - 检查资源操作限制

5. **地域限制**
   - 确认地域支持HAVIP功能
   - 检查地域间的网络连通性
   - 验证跨地域部署需求

6. **兼容性**
   - 确认Terraform版本兼容性
   - 检查Provider版本要求
   - 验证模块版本兼容性

7. **监控告警**
   - 配置路由变更监控
   - 设置异常告警阈值
   - 监控网络性能指标

---

## 故障排除

### 常见错误及解决方案

#### 错误一：VPC防火墙未找到
```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=VPC firewall not found
```

**原因**：指定的VPC ID或网关ID不存在
**解决方案**：
- 检查VPC防火墙是否已部署
- 验证VPC ID和网关ID的正确性
- 确认VPC防火墙状态正常

#### 错误二：权限不足
```
Error: [TencentCloudSDKError] Code=PermissionDenied
Message=Insufficient permissions
```

**原因**：当前账号权限不足
**解决方案**：
- 检查CFW、VPC、HAVIP相关权限
- 申请必要权限
- 验证资源操作权限

#### 错误三：HAVIP不支持
```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=HAVIP not supported
```

**原因**：当前地域不支持HAVIP功能
**解决方案**：
- 检查地域是否支持HAVIP
- 确认HAVIP功能已启用
- 联系技术支持确认支持情况

#### 错误四：路由配置冲突
```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Route configuration conflict
```

**原因**：路由配置存在冲突
**解决方案**：
- 检查现有路由配置
- 解决路由冲突问题
- 重新执行路由重配置

#### 错误五：网络超时
```
Error: [TencentCloudSDKError] Code=RequestTimeout
Message=Network timeout
```

**原因**：网络连接超时
**解决方案**：
- 检查网络连通性
- 重试操作
- 调整超时时间配置