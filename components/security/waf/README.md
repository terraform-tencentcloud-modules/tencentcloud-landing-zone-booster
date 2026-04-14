# 腾讯云Web应用防火墙（WAF）模块

## 模块概述

本模块用于在腾讯云中部署和管理Web应用防火墙（WAF）服务，提供全面的Web应用安全防护，主要功能包括：

- **WAF实例管理** - 创建和管理CLB型WAF实例，支持多种版本（基础版、企业版、旗舰版）
- **域名防护配置** - 配置域名级别的WAF防护策略和负载均衡绑定
- **弹性计费模式** - 支持弹性QPS计费，按需扩展防护能力
- **API安全防护** - 提供API接口级别的安全防护能力
- **Bot管理** - 智能识别和防护恶意机器人流量
- **日志投递** - 支持访问日志和攻击日志投递到CLS日志服务
- **攻击日志配置** - 配置攻击日志的投递和管理
- **多负载均衡支持** - 支持CLB、APISIX、TSEGW等多种负载均衡器
- **流量模式选择** - 支持清洗模式和镜像模式两种流量处理方式

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
| `QcloudFinanceFullAccess` | 财务管理权限 |
| `QcloudBillingReadOnlyAccess` | 账单只读权限 |
| `QcloudWAFReadOnlyAccess` | WAF只读权限 |
| `QcloudWAFFullAccess` | WAF全权限 |
| `QcloudCLBReadOnlyAccess` | CLB只读权限 |
| `QcloudCLSFullAccess` | CLS日志服务权限 |

### 其他要求

- 需要确定WAF实例版本（基础版、企业版、旗舰版）
- 需要规划域名防护配置和负载均衡绑定
- 需要确定QPS限制和弹性计费模式
- 需要配置API安全和Bot管理功能
- 需要规划日志投递到CLS的配置
- 需要确定攻击日志投递策略
- 需要准备负载均衡器相关信息
- 需要确定地域和可用区配置

---

## 变量说明

### WAF实例配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `goods_category` | `string` | 否 | `premium_clb` | 计费类型：premium_clb(基础版), enterprise_clb(企业版), ultimate_clb(旗舰版) |
| `instance_name` | `string` | 否 | `""` | WAF实例名称 |
| `time_span` | `number` | 否 | `1` | 购买时长 |
| `time_unit` | `string` | 否 | `m` | 时间单位：d(天), m(月), y(年) |
| `auto_renew_flag` | `number` | 否 | `1` | 自动续费标识：1(启用), 0(禁用) |
| `elastic_mode` | `number` | 否 | `1` | 弹性计费模式：1(启用), 0(禁用) |
| `qps_limit` | `number` | 否 | `200000` | QPS限制，最小10000，仅弹性模式可设置 |
| `api_security` | `number` | 否 | `0` | API安全防护：1(启用), 0(禁用) |
| `bot_management` | `number` | 否 | `0` | Bot管理：1(启用), 0(禁用) |

### 域名配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `domain_configs` | `list(object)` | 否 | `[]` | 域名配置对象列表 |

### 域名配置对象字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `instance_id` | `string` | 否 | `null` | WAF实例ID |
| `domain` | `string` | 是 | - | 域名名称 |
| `region` | `string` | 是 | - | 负载均衡器地域 |
| `is_cdn` | `number` | 否 | `0` | 是否已启用代理：1(是), 0(否) |
| `status` | `number` | 否 | `1` | 绑定状态：0(未绑定), 1(绑定中) |
| `engine` | `number` | 否 | `20` | 防护状态 |
| `flow_mode` | `number` | 否 | `1` | 流量模式：0(镜像模式), 1(清洗模式) |
| `alb_type` | `string` | 否 | `clb` | 负载均衡类型：clb, apisix, tsegw |
| `bot_status` | `number` | 否 | `0` | Bot防护：1(启用), 0(禁用) |
| `api_safe_status` | `number` | 否 | `0` | API安全：1(启用), 0(禁用) |
| `ip_headers` | `list(string)` | 否 | `[]` | 自定义IP头（当is_cdn=3时需填写） |
| `load_balancer_set` | `list(object)` | 否 | `[]` | 绑定的负载均衡器列表 |

### 负载均衡器配置字段说明

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `load_balancer_id` | `string` | 是 | - | 负载均衡器ID |
| `load_balancer_name` | `string` | 是 | - | 负载均衡器名称 |
| `listener_id` | `string` | 是 | - | 监听器ID |
| `listener_name` | `string` | 是 | - | 监听器名称 |
| `vport` | `number` | 是 | - | 负载均衡器端口 |
| `protocol` | `string` | 是 | - | 协议：http, https |
| `region` | `string` | 是 | - | 负载均衡器地域 |
| `zone` | `string` | 是 | - | 负载均衡器可用区 |
| `vip` | `string` | 否 | - | 负载均衡器IP |
| `load_balancer_type` | `string` | 否 | - | 负载均衡器网络类型 |

### 日志投递配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `cls_region` | `string` | 否 | `ap-shanghai` | CLS投递地域 |
| `log_topic_name` | `string` | 否 | `waf_post_logtopic` | CLS日志主题名称 |
| `log_type` | `number` | 否 | `1` | 日志类型：1(访问日志), 2(攻击日志) |
| `logset_name` | `string` | 否 | `waf_post_logset` | CLS日志集名称 |

### 攻击日志配置变量

| 变量名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| `attack_log_post` | `number` | 否 | `0` | 攻击日志投递：0(禁用), 1(启用) |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# WAF实例基础配置
goods_category  = "enterprise_clb"
instance_name   = "my-waf-instance"
time_span       = 12
time_unit       = "m"
auto_renew_flag = 1
elastic_mode    = 1
qps_limit       = 100000
api_security    = 1
bot_management  = 1

# 域名配置
domain_configs = [
  {
    domain      = "example.com"
    region      = "ap-guangzhou"
    is_cdn      = 0
    status      = 1
    engine      = 20
    flow_mode   = 1
    alb_type    = "clb"
    bot_status  = 1
    api_safe_status = 1
    ip_headers  = []
    load_balancer_set = [
      {
        load_balancer_id   = "lb-123456"
        load_balancer_name = "my-loadbalancer"
        listener_id        = "lbl-123456"
        listener_name      = "http-listener"
        vport              = 80
        protocol           = "http"
        region             = "ap-guangzhou"
        zone               = "ap-guangzhou-1"
        vip                = "192.168.1.1"
        load_balancer_type = "OPEN"
      }
    ]
  }
]

# 日志投递配置
cls_region      = "ap-shanghai"
log_topic_name  = "waf-access-logs"
log_type        = 1
logset_name     = "waf-logs"

# 攻击日志配置
attack_log_post = 1
```

### 生产环境配置示例

```hcl
# 生产环境WAF配置
goods_category  = "ultimate_clb"  # 旗舰版
instance_name   = "prod-waf-instance"
time_span       = 12
time_unit       = "m"
auto_renew_flag = 1
elastic_mode    = 1
qps_limit       = 500000
api_security    = 1
bot_management  = 1

# 生产环境域名配置
domain_configs = [
  {
    domain      = "api.example.com"
    region      = "ap-shanghai"
    is_cdn      = 0
    status      = 1
    engine      = 20
    flow_mode   = 1
    alb_type    = "clb"
    bot_status  = 1
    api_safe_status = 1
    load_balancer_set = [
      {
        load_balancer_id   = "lb-prod-001"
        load_balancer_name = "prod-api-lb"
        listener_id        = "lbl-prod-http"
        listener_name      = "prod-http"
        vport              = 80
        protocol           = "http"
        region             = "ap-shanghai"
        zone               = "ap-shanghai-2"
      },
      {
        load_balancer_id   = "lb-prod-002"
        load_balancer_name = "prod-api-https-lb"
        listener_id        = "lbl-prod-https"
        listener_name      = "prod-https"
        vport              = 443
        protocol           = "https"
        region             = "ap-shanghai"
        zone               = "ap-shanghai-2"
      }
    ]
  }
]

# 生产环境日志配置
cls_region      = "ap-shanghai"
log_topic_name  = "prod-waf-logs"
log_type        = 1
logset_name     = "prod-security-logs"
attack_log_post = 1
```

### 多域名配置示例

```hcl
# 多域名WAF配置
goods_category  = "enterprise_clb"
instance_name   = "multi-domain-waf"

# 多个域名配置
domain_configs = [
  # 主域名
  {
    domain      = "example.com"
    region      = "ap-beijing"
    flow_mode   = 1
    load_balancer_set = [
      {
        load_balancer_id   = "lb-main"
        load_balancer_name = "main-lb"
        listener_id        = "lbl-main"
        listener_name      = "main-listener"
        vport              = 80
        protocol           = "http"
        region             = "ap-beijing"
        zone               = "ap-beijing-1"
      }
    ]
  },
  # API子域名
  {
    domain      = "api.example.com"
    region      = "ap-beijing"
    flow_mode   = 1
    bot_status  = 1
    api_safe_status = 1
    load_balancer_set = [
      {
        load_balancer_id   = "lb-api"
        load_balancer_name = "api-lb"
        listener_id        = "lbl-api"
        listener_name      = "api-listener"
        vport              = 8080
        protocol           = "http"
        region             = "ap-beijing"
        zone               = "ap-beijing-1"
      }
    ]
  }
]
```

### 最小化配置示例

```hcl
# 最小化WAF配置
goods_category = "premium_clb"

# 仅配置一个域名
domain_configs = [
  {
    domain = "test.example.com"
    region = "ap-guangzhou"
    load_balancer_set = [
      {
        load_balancer_id   = "lb-test"
        load_balancer_name = "test-lb"
        listener_id        = "lbl-test"
        listener_name      = "test-listener"
        vport              = 80
        protocol           = "http"
        region             = "ap-guangzhou"
        zone               = "ap-guangzhou-1"
      }
    ]
  }
]
```

---

## 使用示例

### 示例一：电商网站防护配置

```hcl
# 电商网站WAF配置
goods_category  = "ultimate_clb"  # 旗舰版提供最高防护
instance_name   = "ecommerce-waf"
time_span       = 12
auto_renew_flag = 1
elastic_mode    = 1
qps_limit       = 1000000  # 支持高并发
api_security    = 1
bot_management  = 1

# 电商域名配置
domain_configs = [
  {
    domain      = "shop.example.com"
    region      = "ap-shanghai"
    flow_mode   = 1  # 清洗模式
    bot_status  = 1  # 启用Bot防护
    api_safe_status = 1  # 启用API安全
    load_balancer_set = [
      {
        load_balancer_id   = "lb-ecom-http"
        load_balancer_name = "ecommerce-http"
        listener_id        = "lbl-http"
        listener_name      = "http-port"
        vport              = 80
        protocol           = "http"
        region             = "ap-shanghai"
        zone               = "ap-shanghai-2"
      },
      {
        load_balancer_id   = "lb-ecom-https"
        load_balancer_name = "ecommerce-https"
        listener_id        = "lbl-https"
        listener_name      = "https-port"
        vport              = 443
        protocol           = "https"
        region             = "ap-shanghai"
        zone               = "ap-shanghai-2"
      }
    ]
  }
]

# 完整的日志监控
cls_region      = "ap-shanghai"
log_topic_name  = "ecommerce-waf-logs"
log_type        = 1
logset_name     = "ecommerce-security"
attack_log_post = 1
```

### 示例二：API网关防护配置

```hcl
# API网关WAF配置
goods_category  = "enterprise_clb"
instance_name   = "api-gateway-waf"

# API网关域名配置
domain_configs = [
  {
    domain      = "api.company.com"
    region      = "ap-beijing"
    alb_type    = "apisix"  # API网关类型
    flow_mode   = 1
    bot_status  = 1
    api_safe_status = 1  # 重点保护API
    load_balancer_set = [
      {
        load_balancer_id   = "lb-api-gw"
        load_balancer_name = "api-gateway"
        listener_id        = "lbl-api"
        listener_name      = "api-listener"
        vport              = 8000
        protocol           = "http"
        region             = "ap-beijing"
        zone               = "ap-beijing-3"
      }
    ]
  }
]

# API访问日志详细记录
cls_region      = "ap-beijing"
log_topic_name  = "api-gateway-logs"
log_type        = 1
logset_name     = "api-security"
attack_log_post = 1
```

### 示例三：CDN加速网站防护

```hcl
# CDN网站WAF配置
goods_category = "premium_clb"

# CDN域名配置
domain_configs = [
  {
    domain      = "cdn.example.com"
    region      = "ap-guangzhou"
    is_cdn      = 1  # 已启用CDN
    flow_mode   = 0  # 镜像模式适合CDN
    load_balancer_set = [
      {
        load_balancer_id   = "lb-cdn"
        load_balancer_name = "cdn-lb"
        listener_id        = "lbl-cdn"
        listener_name      = "cdn-listener"
        vport              = 80
        protocol           = "http"
        region             = "ap-guangzhou"
        zone               = "ap-guangzhou-1"
      }
    ]
  }
]

# 基础日志配置
cls_region = "ap-guangzhou"
log_type   = 1
```

### 示例四：高安全要求的金融应用

```hcl
# 金融应用WAF配置
goods_category  = "ultimate_clb"  # 旗舰版
instance_name   = "finance-waf"
time_span       = 24  # 2年订阅
time_unit       = "m"
auto_renew_flag = 1

# 金融域名严格防护
domain_configs = [
  {
    domain      = "bank.example.com"
    region      = "ap-shanghai"
    flow_mode   = 1  # 清洗模式
    bot_status  = 1  # Bot防护
    api_safe_status = 1  # API安全
    load_balancer_set = [
      {
        load_balancer_id   = "lb-finance-https"
        load_balancer_name = "finance-https"
        listener_id        = "lbl-https"
        listener_name      = "https-port"
        vport              = 443
        protocol           = "https"
        region             = "ap-shanghai"
        zone               = "ap-shanghai-2"
      }
    ]
  }
]

# 完整的审计日志
cls_region      = "ap-shanghai"
log_topic_name  = "finance-waf-audit"
log_type        = 2  # 攻击日志
logset_name     = "finance-security"
attack_log_post = 1
```

---

## 配置说明

### WAF版本功能对比

| 版本 | 编码 | 防护能力 | 适用场景 | 价格 |
|------|------|----------|----------|------|
| **基础版** | premium_clb | 基础Web防护 | 小型网站、测试环境 | 低 |
| **企业版** | enterprise_clb | 增强防护+Bot管理 | 中型企业、生产环境 | 中 |
| **旗舰版** | ultimate_clb | 全面防护+API安全 | 大型企业、金融级 | 高 |

### 流量模式说明

#### 清洗模式（flow_mode = 1）
- **工作原理**：流量先经过WAF清洗再转发到后端
- **优势**：提供实时防护，恶意流量被拦截
- **适用**：生产环境、高安全要求场景
- **延迟**：略有增加

#### 镜像模式（flow_mode = 0）
- **工作原理**：流量镜像到WAF进行分析，不影响正常流量
- **优势**：零延迟，不影响业务性能
- **适用**：监控分析、CDN加速场景
- **防护**：仅检测不拦截

### 弹性计费模式

- **启用（elastic_mode = 1）**：按实际QPS计费，支持动态扩容
- **禁用（elastic_mode = 0）**：固定QPS额度，超过则被限制
- **QPS限制**：最小10000，可根据业务峰值设置
- **成本优化**：根据业务流量模式选择合适的QPS限制

### 安全功能配置

#### API安全防护（api_security）
- **功能**：专门防护API接口的攻击
- **适用**：RESTful API、微服务架构
- **防护**：API注入、越权访问、参数污染等

#### Bot管理（bot_management）
- **功能**：智能识别恶意机器人流量
- **防护**：爬虫、刷单、撞库、CC攻击等
- **策略**：基于行为分析、指纹识别、挑战响应

### 负载均衡器类型

| 类型 | 编码 | 说明 | 适用场景 |
|------|------|------|----------|
| **CLB** | clb | 传统负载均衡器 | 常规Web应用 |
| **APISIX** | apisix | API网关 | 微服务架构 |
| **TSEGW** | tsegw | 流量引擎网关 | 高性能场景 |

### 日志投递配置

#### 日志类型选择
- **访问日志（log_type = 1）**：记录所有请求访问信息
- **攻击日志（log_type = 2）**：只记录被拦截的攻击请求

#### CLS配置建议
- **地域选择**：选择离业务最近的地域减少延迟
- **主题命名**：按业务功能命名便于检索
- **日志集管理**：按环境或项目划分日志集

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **版本选择**
   - 确认WAF版本符合业务需求和预算
   - 旗舰版提供最全面的防护功能
   - 基础版适合测试和小型应用

2. **域名配置**
   - 确保域名已备案且解析正常
   - 确认负载均衡器配置正确
   - 检查地域和可用区匹配

3. **流量模式**
   - 生产环境建议使用清洗模式
   - CDN场景可使用镜像模式
   - 确认流量模式符合业务需求

4. **弹性计费**
   - 弹性模式可按需扩展但成本较高
   - 固定模式成本可控但可能限流
   - 根据业务流量特征选择合适模式

5. **安全功能**
   - API安全防护会增加资源消耗
   - Bot管理需要额外授权
   - 确认已购买相关安全功能

6. **日志配置**
   - CLS服务需要额外费用
   - 攻击日志投递需要额外配置
   - 确认CLS地域可用性

7. **权限验证**
   - 确认有足够的WAF操作权限
   - 检查负载均衡器访问权限
   - 验证CLS日志服务权限

8. **网络连通性**
   - 确认WAF地域与业务地域一致
   - 检查负载均衡器网络配置
   - 验证域名解析正常

9. **性能考虑**
   - 合理设置QPS限制避免过度配置
   - 考虑业务峰值流量
   - 监控WAF性能指标

10. **合规性要求**
    - 确保配置符合安全合规标准
    - 保留足够的日志用于审计
    - 遵循数据安全规范

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足

```
Error: [TencentCloudSDKError] Code=PermissionDenied
Message=Insufficient permissions
```

**原因**：当前账号权限不足
**解决方案**：
- 检查WAF相关权限
- 申请QcloudWAFFullAccess权限
- 验证负载均衡器权限

#### 错误二：地域不支持

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**原因**：选择的地域不支持WAF
**解决方案**：
- 检查地域可用性
- 选择支持的地域
- 联系腾讯云支持

#### 错误三：域名配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid domain configuration
```

**原因**：域名配置参数错误
**解决方案**：
- 检查domain_configs格式
- 确认负载均衡器信息正确
- 验证地域匹配

#### 错误四：QPS限制过低

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=QPS limit too low
```

**原因**：QPS限制设置过低
**解决方案**：
- 增加qps_limit值
- 确认弹性模式已启用
- 联系腾讯云调整配额

#### 错误五：负载均衡器绑定失败

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=LoadBalancer not found
```

**原因**：负载均衡器不存在或权限不足
**解决方案**：
- 检查负载均衡器ID是否正确
- 确认有负载均衡器访问权限
- 验证负载均衡器状态正常

#### 错误六：CLS配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=CLS configuration error
```

**原因**：CLS日志配置错误
**解决方案**：
- 检查CLS地域可用性
- 确认日志主题和日志集存在
- 验证CLS服务权限

#### 错误七：版本功能未购买

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Feature not purchased
```

**原因**：使用了未购买的功能
**解决方案**：
- 确认已购买相应WAF版本
- 检查API安全或Bot管理是否已启用
- 联系腾讯云购买所需功能