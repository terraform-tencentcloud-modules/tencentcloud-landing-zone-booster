# 腾讯云CLS事件告警管理模块

## 模块概述

本模块用于在腾讯云CLS（Cloud Log Service）中创建和管理事件告警系统，支持以下核心功能：

- **告警通知配置** - 创建告警通知模板，支持多种接收方式和回调机制
- **多维度告警规则** - 支持基于日志查询的多条件告警规则配置
- **多渠道通知** - 支持邮件、短信、微信、电话等多种通知渠道
- **Webhook集成** - 支持HTTP、企业微信、钉钉、飞书等回调集成
- **智能分析** - 支持多维分析和多条件触发机制
- **监控时段控制** - 支持自定义通知接收时间段
- **标签管理** - 支持告警和通知的标签分类管理

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
| `QcloudCLSFullAccess` | CLS日志服务全权限 |
| `QcloudCamFullAccess` | CAM权限管理全权限 |

### 其他要求

- 需要提前创建好CLS日志集和日志主题
- 需要配置好接收通知的用户或用户组
- 如需Webhook回调，需要提前准备好回调URL

---

## 变量说明

### 告警通知配置变量

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enable_notice` | `bool` | `false` | 是否启用告警通知 |
| `notice_name` | `string` | - | 告警通知名称 |
| `notice_type` | `string` | - | 通知类型（Trigger/Recovery/All） |
| `notice_receivers` | `list(object)` | `[]` | 通知接收者配置 |
| `↳ receiver_type` | `string` | - | 接收者类型（Uin/Group） |
| `↳ receiver_ids` | `list(number)` | - | 接收者ID列表 |
| `↳ receiver_channels` | `list(string)` | - | 接收渠道（Email/Sms/WeChat/Phone） |
| `↳ notice_content_id` | `string` | - | 通知内容ID |
| `↳ start_time` | `string` | - | 开始接收时间 |
| `↳ end_time` | `string` | - | 结束接收时间 |
| `web_callbacks` | `list(object)` | `[]` | Web回调配置 |
| `↳ callback_type` | `string` | - | 回调类型（Http/WeCom/DingTalk/Lark） |
| `↳ url` | `string` | - | 回调URL |
| `↳ method` | `string` | - | HTTP方法（POST/PUT） |
| `↳ web_callback_id` | `string` | - | 回调配置ID |
| `↳ notice_content_id` | `string` | - | 通知内容ID |
| `↳ remind_type` | `number` | - | 提醒类型（0:不提醒/1:指定人/2:所有人） |
| `↳ mobiles` | `list(string)` | - | 手机号列表 |
| `↳ user_ids` | `list(string)` | - | 用户ID列表 |
| `notice_tags` | `map(string)` | `null` | 通知标签 |

### 告警规则配置变量

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `alarms` | `list(object)` | `[]` | 告警规则列表 |
| `↳ name` | `string` | - | 告警规则名称 |
| `↳ trigger_count` | `number` | `1` | 连续触发次数（1-2000） |
| `↳ alarm_period` | `number` | `15` | 告警重复周期（分钟） |
| `↳ monitor_time_type` | `string` | - | 监控时间类型（Period/Time） |
| `↳ monitor_time_value` | `number` | - | 监控时间值（1-1440分钟） |
| `↳ message_template` | `string` | - | 自定义告警消息模板 |
| `↳ classifications` | `map(string)` | - | 告警分类信息 |
| `↳ status` | `bool` | `true` | 是否启用告警 |
| `↳ tags` | `map(string)` | - | 告警标签 |
| `↳ alarm_targets` | `list(object)` | - | 告警目标配置 |
| `↳↳ logset_id` | `string` | null | 日志集ID |
| `↳↳ logset_name` | `string` | null | 日志集Name |
| `↳↳ topic_id` | `string` | null | 日志主题ID |
| `↳↳ topic_name` | `string` | null | 日志主题Name |
| `↳↳ query` | `string` | - | 查询规则 |
| `↳↳ number` | `number` | - | 告警对象数量 |
| `↳↳ start_time_offset` | `number` | - | 开始时间偏移量 |
| `↳↳ end_time_offset` | `number` | - | 结束时间偏移量 |
| `↳↳ syntax_rule` | `number` | `0` | 语法规则（0:Lucene/1:CQL） |
| `↳ analysis_fields` | `list(object)` | `[]` | 分析字段配置 |
| `↳↳ name` | `string` | - | 字段名称 |
| `↳↳ type` | `string` | - | 分析类型（field/average/sum/min/max） |
| `↳↳ content` | `string` | - | 字段内容 |
| `↳↳ config_info` | `list(object)` | - | 配置信息 |
| `↳ multi_conditions` | `list(object)` | `[]` | 多条件配置 |
| `↳↳ condition` | `string` | - | 触发条件 |
| `↳↳ alarm_level` | `number` | `0` | 告警级别（0:警告/1:信息/2:严重） |
| `↳ alarm_notice_ids` | `list(string)` | `[]` | 告警通知ID列表 |
| `↳ monitor_notice` | `list(object)` | `[]` | 监控通知配置 |
| `↳↳ notices` | `list(object)` | - | 通知规则列表 |
| `↳↳↳ notice_id` | `string` | - | 通知模板ID |
| `↳↳↳ content_tmpl_id` | `string` | - | 内容模板ID |
| `↳↳↳ alarm_levels` | `list(number)` | - | 告警级别列表 |

---

## 变量配置

### terraform.tfvars 示例

```hcl
# 告警通知配置
enable_notice = true
notice_name   = "prod-alert-notice"
notice_type   = "All"

# 通知接收者配置
notice_receivers = [
  {
    receiver_type     = "Uin"
    receiver_ids      = [100000000001, 100000000002]
    receiver_channels = ["Email", "Sms", "WeChat"]
    start_time        = "09:00"
    end_time          = "18:00"
  },
  {
    receiver_type     = "Group"
    receiver_ids      = [200000000001]
    receiver_channels = ["Email"]
  }
]

# Webhook回调配置
web_callbacks = [
  {
    callback_type = "Http"
    url           = "https://api.example.com/alert"
    method        = "POST"
  },
  {
    callback_type = "WeCom"
    url           = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxx"
  }
]

# 告警规则配置
alarms = [
  {
    name             = "high-error-rate"
    trigger_count    = 3
    alarm_period     = 15
    monitor_time_type  = "Period"
    monitor_time_value = 5
    message_template   = "错误率超过阈值，请及时处理"
    
    # 告警目标配置
    alarm_targets = [
      {
        logset_id         = "logset-xxxxxx"
        topic_id          = "topic-xxxxxx"
        query             = "status:error | select count(*) as error_count"
        number            = 1
        start_time_offset = 15
        end_time_offset   = 0
        syntax_rule       = 0
      }
    ],
    
    # 多维分析配置
    analysis_fields = [
      {
        name    = "error_count"
        type    = "sum"
        content = "error_count"
      }
    ],
    
    # 多条件配置
    multi_conditions = [
      {
        condition   = "$1.error_count > 100"
        alarm_level = 2
      }
    ],
    
    # 告警通知关联
    alarm_notice_ids = ["notice-xxxxxx"]
  },
  {
    name             = "slow-response"
    trigger_count    = 2
    alarm_period     = 30
    monitor_time_type  = "Time"
    monitor_time_value = 10
    
    alarm_targets = [
      {
        logset_id         = "logset-xxxxxx"
        topic_id          = "topic-xxxxxx"
        query             = "response_time > 5000"
        number            = 5
        start_time_offset = 10
        end_time_offset   = 0
      }
    ],
    
    multi_conditions = [
      {
        condition   = "$1 > 0"
        alarm_level = 1
      }
    ]
  }
]
```

### 简单配置示例

```hcl
# 基础告警配置
alarms = [
  {
    name             = "basic-error-alert"
    trigger_count    = 1
    alarm_period     = 15
    monitor_time_type  = "Period"
    monitor_time_value = 5
    
    alarm_targets = [
      {
        logset_id         = "your-logset-id"
        topic_id          = "your-topic-id"
        query             = "error"
        number            = 10
        start_time_offset = 15
        end_time_offset   = 0
      }
    ],
    
    multi_conditions = [
      {
        condition   = "$1 > 0"
        alarm_level = 0
      }
    ]
  }
]
```

---

## 使用示例

### 示例一：错误率监控告警

```hcl
# 监控应用错误率，当5分钟内错误数超过100时触发严重告警
alarms = [
  {
    name             = "app-error-monitor"
    trigger_count    = 1
    alarm_period     = 5
    monitor_time_type  = "Period"
    monitor_time_value = 5
    
    alarm_targets = [
      {
        logset_id         = "app-logset"
        topic_id          = "app-topic"
        query             = "level:error | select count(*) as error_count"
        number            = 1
        start_time_offset = 5
        end_time_offset   = 0
      }
    ],
    
    analysis_fields = [
      {
        name    = "error_count"
        type    = "sum"
        content = "error_count"
      }
    ],
    
    multi_conditions = [
      {
        condition   = "$1.error_count > 100"
        alarm_level = 2
      }
    ],
    
    alarm_notice_ids = [tencentcloud_cls_alarm_notice.notice[0].id]
  }
]
```

### 示例二：响应时间监控

```hcl
# 监控API响应时间，当平均响应时间超过2秒时触发告警
alarms = [
  {
    name             = "api-response-time"
    trigger_count    = 2
    alarm_period     = 10
    monitor_time_type  = "Period"
    monitor_time_value = 5
    
    alarm_targets = [
      {
        logset_id         = "api-logset"
        topic_id          = "api-topic"
        query             = "method:GET path:/api/* | select avg(response_time) as avg_time"
        number            = 1
        start_time_offset = 5
        end_time_offset   = 0
      }
    ],
    
    analysis_fields = [
      {
        name    = "avg_time"
        type    = "average"
        content = "avg_time"
      }
    ],
    
    multi_conditions = [
      {
        condition   = "$1.avg_time > 2000"
        alarm_level = 1
      }
    ]
  }
]
```

### 示例三：安全事件监控

```hcl
# 监控安全相关事件，如登录失败、权限变更等
alarms = [
  {
    name             = "security-events"
    trigger_count    = 1
    alarm_period     = 15
    monitor_time_type  = "Period"
    monitor_time_value = 5
    
    alarm_targets = [
      {
        logset_id         = "security-logset"
        topic_id          = "auth-topic"
        query             = "event:(login_failed OR permission_changed OR access_denied)"
        number            = 1
        start_time_offset = 10
        end_time_offset   = 0
      }
    ],
    
    multi_conditions = [
      {
        condition   = "$1 > 0"
        alarm_level = 2
      }
    ],
    
    # 配置分类信息
    classifications = {
      category = "security"
      severity = "high"
    }
  }
]
```

### 示例四：业务指标监控

```hcl
# 监控业务关键指标，如订单量、支付成功率等
alarms = [
  {
    name             = "business-metrics"
    trigger_count    = 3
    alarm_period     = 30
    monitor_time_type  = "Period"
    monitor_time_value = 10
    
    alarm_targets = [
      {
        logset_id         = "business-logset"
        topic_id          = "order-topic"
        query             = "type:order | select count_if(status='success') as success_count, count(*) as total_count"
        number            = 1
        start_time_offset = 10
        end_time_offset   = 0
      }
    ],
    
    analysis_fields = [
      {
        name    = "success_rate"
        type    = "field"
        content = "success_count / total_count * 100"
      }
    ],
    
    multi_conditions = [
      {
        condition   = "$1.success_rate < 95"
        alarm_level = 1
      }
    ],
    
    message_template = "支付成功率下降至 {{success_rate}}%，请及时检查"
  }
]
```

---

## 配置说明

### 告警触发逻辑

```
告警触发流程：
┌─────────────────────────────────────┐
│  监控时间窗口内执行日志查询          │
│         │                           │
│   满足触发条件 → 判断连续触发次数    │
│         │                           │
│   达到触发次数 → 发送告警通知        │
│         │                           │
│   在告警周期内不会重复发送相同告警   │
└─────────────────────────────────────┘
```

### 通知渠道支持

| 渠道类型 | 支持方式 | 配置说明 |
|----------|----------|----------|
| **邮件** | Email | 需要配置接收者邮箱 |
| **短信** | Sms | 需要配置接收者手机号 |
| **微信** | WeChat | 需要配置企业微信接收者 |
| **电话** | Phone | 需要配置接收者手机号 |
| **HTTP** | Webhook | 需要配置回调URL |
| **企业微信** | WeCom | 需要配置Webhook URL |
| **钉钉** | DingTalk | 需要配置Webhook URL |
| **飞书** | Lark | 需要配置Webhook URL |

### 监控时间类型说明

| 类型 | 说明 | 示例 |
|------|------|------|
| **Period** | 周期性监控 | 每5分钟执行一次查询 |
| **Time** | 定时监控 | 在特定时间点执行查询 |

### 分析类型说明

| 类型 | 说明 | 适用场景 |
|------|------|----------|
| **field** | 字段分析 | 直接使用字段值 |
| **average** | 平均值 | 计算数值字段平均值 |
| **sum** | 求和 | 计算数值字段总和 |
| **min** | 最小值 | 找出数值字段最小值 |
| **max** | 最大值 | 找出数值字段最大值 |

---

## 注意事项

> ⚠️ **重要提示，操作前请仔细阅读**

1. **权限配置**
   - 确保执行账号具有CLS和CAM相关权限
   - 接收者需要提前在CAM中配置好

2. **日志集和主题**
   - 需要提前创建好CLS日志集和日志主题
   - 确保查询语法与日志格式匹配

3. **通知配置限制**
   - `alarm_notice_ids`和`monitor_notice`不能同时配置
   - 通知接收时间段需要合理配置

4. **查询性能**
   - 复杂的查询语句可能影响性能
   - 建议优化查询语法，减少数据扫描量

5. **告警频率控制**
   - 合理配置`alarm_period`避免告警风暴
   - 根据业务重要性设置不同的告警级别

6. **Webhook安全**
   - 回调URL需要支持公网访问
   - 建议使用HTTPS协议确保安全

7. **多条件配置**
   - 多条件之间是AND关系
   - 条件表达式需要正确引用分析字段

8. **语法规则**
   - Lucene语法（0）：支持全文检索和字段查询
   - CQL语法（1）：支持类SQL查询语法

---

## 故障排除

### 常见错误及解决方案

#### 错误一：权限不足

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**原因**：执行账号缺少CLS或CAM权限
**解决方案**：
- 确认Provider配置的密钥具有所需权限
- 检查是否包含`QcloudCLSFullAccess`、`QcloudCamFullAccess`权限

#### 错误二：日志集不存在

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Logset not found
```

**原因**：指定的日志集ID不存在
**解决方案**：
- 确认日志集ID正确
- 检查日志集是否已被删除

#### 错误三：查询语法错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid query syntax
```

**原因**：查询语句语法错误
**解决方案**：
- 检查查询语法是否符合Lucene或CQL规范
- 验证字段名称和运算符是否正确

#### 错误四：接收者配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid receiver configuration
```

**原因**：通知接收者配置不正确
**解决方案**：
- 确认接收者类型为Uin或Group
- 检查接收者ID是否存在
- 验证接收渠道配置正确

#### 错误五：Webhook配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid web callback configuration
```

**原因**：Webhook回调配置不正确
**解决方案**：
- 确认回调类型支持（Http/WeCom/DingTalk/Lark）
- 检查URL格式是否正确
- 验证HTTP方法为POST或PUT

#### 错误六：监控时间配置错误

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid monitor time configuration
```

**原因**：监控时间配置超出范围
**解决方案**：
- 确认`monitor_time_value`在1-1440分钟范围内
- 检查`monitor_time_type`为Period或Time
- 验证`alarm_period`为支持的值（0,5,10,15,30,60,120,180,360,1440）