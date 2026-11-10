# Tencent Cloud CLS Event Alarm Component

Terraform component under `components/audit-log/event-alert` for creating and managing event alarm systems in Tencent Cloud CLS (Cloud Log Service). It is part of the `audit-log` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates and manages CLS event alarms, with support for:

- **Alarm notice configuration** – create an alarm notice template supporting multiple receivers and callback mechanisms.
- **Multi-dimensional alarm rules** – configure multi-condition alarm rules based on log queries.
- **Multi-channel notification** – support Email, SMS, WeChat, and Phone as receiver channels.
- **Webhook integration** – support HTTP, WeCom (Enterprise WeChat), DingTalk and Lark callbacks.
- **Smart analysis** – support multi-dimensional analysis and multi-condition triggering.
- **Monitor time control** – define the time period during which notifications are received.
- **Tag management** – classify alarms and notices with tags.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.125 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.125 |

### IAM Permissions

The executing principal needs the following Tencent Cloud permissions:

| Permission | Description |
|------------|-------------|
| `QcloudCLSFullAccess` | Full access to CLS |
| `QcloudCamFullAccess` | Full access to CAM management |

### Prerequisites

- The target CLS logset and log topic must be created in advance.
- The notification receivers (UIN or CAM user group) must be configured in advance.
- For Webhook callbacks, the callback URL must be prepared in advance.

---

## Inputs

### Alarm notice configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_enable_notice"></a> [enable\_notice](#input\_enable\_notice) | `bool` | `false` | Whether to enable the alarm notice. |
| <a name="input_notice_name"></a> [notice\_name](#input\_notice\_name) | `string` | - (required when `enable_notice = true`) | Alarm notice name. |
| <a name="input_notice_type"></a> [notice\_type](#input\_notice\_type) | `string` | - (required when `enable_notice = true`) | Notice type: `Trigger`, `Recovery` or `All`. |
| <a name="input_notice_receivers"></a> [notice\_receivers](#input\_notice\_receivers) | `list(object)` | `[]` | Alarm notice receivers. |
| `↳ receiver_type` | `string` | - | Receiver type: `Uin` or `Group`. |
| `↳ receiver_ids` | `list(number)` | - | Receiver ID list. |
| `↳ receiver_channels` | `list(string)` | - | Receiver channels: `Email`, `Sms`, `WeChat`, `Phone`. |
| `↳ notice_content_id` | `string` | - | Notice content ID. |
| `↳ start_time` | `string` | - | Start time allowed to receive messages. |
| `↳ end_time` | `string` | - | End time allowed to receive messages. |
| <a name="input_notice_web_callbacks"></a> [notice\_web\_callbacks](#input\_notice\_web\_callbacks) | `list(object)` | `[]` | Web callback configurations. |
| `↳ callback_type` | `string` | - | Callback type: `Http`, `WeCom`, `DingTalk` or `Lark`. |
| `↳ url` | `string` | - | Callback URL. |
| `↳ web_callback_id` | `string` | - | Integration configuration ID. |
| `↳ method` | `string` | - | HTTP method: `POST` or `PUT`. |
| `↳ notice_content_id` | `string` | - | Notice content ID. |
| `↳ remind_type` | `number` | - | Remind type: `0` do not remind, `1` specified person, `2` everyone. |
| `↳ mobiles` | `list(string)` | - | Telephone number list. |
| `↳ user_ids` | `list(string)` | - | User ID list. |
| <a name="input_notice_tags"></a> [notice\_tags](#input\_notice\_tags) | `map(string)` | `null` | Tags for the notice. |

### Alarm rule configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_alarms"></a> [alarms](#input\_alarms) | `list(object)` | `[]` | Alarm rule list. |
| `↳ name` | `string` | - | Alarm rule name. |
| `↳ trigger_count` | `number` | `1` | Continuous trigger cycles (1-2000). |
| `↳ alarm_period` | `number` | `15` | Alarm repeat cycle in minutes (`0,5,10,15,30,60,120,180,360,1440`). |
| `↳ monitor_time_type` | `string` | - | Monitor time type: `Period` (periodic) or `Time` (fixed). |
| `↳ monitor_time_value` | `number` | - | Time period (minutes) or point in time (1-1440). |
| `↳ message_template` | `string` | - | Custom alarm message template. |
| `↳ classifications` | `map(string)` | - | Alarm classification map. Key must match `^[a-z]([a-z0-9_]{0,49})$`, value ≤ 200 chars, max 20 entries. |
| `↳ status` | `bool` | `true` | Whether to enable the alarm policy. |
| `↳ tags` | `map(string)` | - | Tags for the alarm. |
| `↳ alarm_targets` | `list(object)` | - (at least 1 required) | Alarm targets. |
| `↳↳ logset_id` | `string` | `null` | Logset ID. |
| `↳↳ logset_name` | `string` | `null` | Logset name. |
| `↳↳ topic_id` | `string` | `null` | Log topic ID. |
| `↳↳ topic_name` | `string` | `null` | Log topic name. |
| `↳↳ query` | `string` | - | Query rule. |
| `↳↳ number` | `number` | - | Number of alarm objects. |
| `↳↳ start_time_offset` | `number` | - | Search start time offset (minutes). |
| `↳↳ end_time_offset` | `number` | - | Search end time offset (minutes). |
| `↳↳ syntax_rule` | `number` | `0` | Retrieve grammar: `0` Lucene, `1` CQL. |
| `↳ analysis_fields` | `list(object)` | `[]` | Multi-dimensional analysis fields. |
| `↳↳ name` | `string` | - | Field name. |
| `↳↳ type` | `string` | - | Analysis type: `field`, `average`, `sum`, `min`, `max`. |
| `↳↳ content` | `string` | - | Field content. |
| `↳↳ config_info` | `list(object)` | `[]` | Analysis config key/value list (`key`, `value`). |
| `↳ multi_conditions` | `list(object)` | `[]` | Multi trigger conditions. |
| `↳↳ condition` | `string` | - | Trigger condition expression. |
| `↳↳ alarm_level` | `number` | `0` | Alarm level: `0` Warning, `1` Info, `2` Critical. |
| `↳ alarm_notice_ids` | `list(string)` | `[]` | Alarm notice IDs. |
| `↳ monitor_notice` | `list(object)` | `[]` | Monitor notice config for observable platform (at most 1). |
| `↳↳ notices` | `list(object)` | - | Monitor notice rule list. |
| `↳↳↳ notice_id` | `string` | - | Observable platform notification template ID. |
| `↳↳↳ content_tmpl_id` | `string` | - | Observable platform content template ID. |
| `↳↳↳ alarm_levels` | `list(number)` | - | Alarm levels: `0` Warning, `1` Info, `2` Critical. |

> **Note**: `alarm_notice_ids` and `monitor_notice` cannot be set at the same time.

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_notice_id"></a> [alarm\_notice\_id](#output\_alarm\_notice\_id) | The ID of the created alarm notice (empty if `enable_notice = false`). |
| <a name="output_alarm_ids"></a> [alarm\_ids](#output\_alarm\_ids) | The map/list of created alarm policy IDs. |

---

## Configuration Examples

### `terraform.tfvars` example

```hcl
# Alarm notice configuration
enable_notice = true
notice_name   = "prod-alert-notice"
notice_type   = "All"

# Notice receivers
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

# Web callbacks (variable name: notice_web_callbacks)
notice_web_callbacks = [
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

# Alarm rules
alarms = [
  {
    name              = "high-error-rate"
    trigger_count     = 3
    alarm_period      = 15
    monitor_time_type = "Period"
    monitor_time_value = 5
    message_template  = "Error rate exceeded the threshold, please handle it in time"

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
    ]

    analysis_fields = [
      {
        name    = "error_count"
        type    = "sum"
        content = "error_count"
      }
    ]

    multi_conditions = [
      {
        condition   = "$1.error_count > 100"
        alarm_level = 2
      }
    ]

    alarm_notice_ids = ["notice-xxxxxx"]
  },
  {
    name              = "slow-response"
    trigger_count     = 2
    alarm_period      = 30
    monitor_time_type = "Time"
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
    ]

    multi_conditions = [
      {
        condition   = "$1 > 0"
        alarm_level = 1
      }
    ]
  }
]
```

### Simple configuration example

```hcl
alarms = [
  {
    name              = "basic-error-alert"
    trigger_count     = 1
    alarm_period      = 15
    monitor_time_type = "Period"
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
    ]

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

## Usage Examples

### Example 1: Error rate monitoring

```hcl
# Monitor the application error rate; trigger a Critical alarm when errors > 100 within 5 minutes.
alarms = [
  {
    name              = "app-error-monitor"
    trigger_count     = 1
    alarm_period      = 5
    monitor_time_type = "Period"
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
    ]

    analysis_fields = [
      {
        name    = "error_count"
        type    = "sum"
        content = "error_count"
      }
    ]

    multi_conditions = [
      {
        condition   = "$1.error_count > 100"
        alarm_level = 2
      }
    ]

    alarm_notice_ids = [tencentcloud_cls_alarm_notice.notice[0].id]
  }
]
```

### Example 2: Response time monitoring

```hcl
# Monitor API response time; trigger an alarm when average response time > 2s.
alarms = [
  {
    name              = "api-response-time"
    trigger_count     = 2
    alarm_period      = 10
    monitor_time_type = "Period"
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
    ]

    analysis_fields = [
      {
        name    = "avg_time"
        type    = "average"
        content = "avg_time"
      }
    ]

    multi_conditions = [
      {
        condition   = "$1.avg_time > 2000"
        alarm_level = 1
      }
    ]
  }
]
```

### Example 3: Security event monitoring

```hcl
# Monitor security events such as login failures and permission changes.
alarms = [
  {
    name              = "security-events"
    trigger_count     = 1
    alarm_period      = 15
    monitor_time_type = "Period"
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
    ]

    multi_conditions = [
      {
        condition   = "$1 > 0"
        alarm_level = 2
      }
    ]

    classifications = {
      category = "security"
      severity = "high"
    }
  }
]
```

### Example 4: Business metrics monitoring

```hcl
# Monitor key business metrics such as payment success rate.
alarms = [
  {
    name              = "business-metrics"
    trigger_count     = 3
    alarm_period      = 30
    monitor_time_type = "Period"
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
    ]

    analysis_fields = [
      {
        name    = "success_rate"
        type    = "field"
        content = "success_count / total_count * 100"
      }
    ]

    multi_conditions = [
      {
        condition   = "$1.success_rate < 95"
        alarm_level = 1
      }
    ]

    message_template = "Payment success rate dropped to {{success_rate}}%, please check."
  }
]
```

---

## Configuration Notes

### Alarm triggering logic

```
Alarm trigger flow:
┌─────────────────────────────────────┐
│  Execute log query within the        │
│  monitor time window                 │
│         │                           │
│  Condition met → check trigger count │
│         │                           │
│  Reach trigger count → send alarm    │
│         │                           │
│  No duplicate alarms within          │
│  alarm_period                        │
└─────────────────────────────────────┘
```

### Supported notification channels

| Channel | Type | Notes |
|---------|------|-------|
| Email | Email | Receiver email required |
| SMS | Sms | Receiver phone number required |
| WeChat | WeChat | Enterprise WeChat receiver required |
| Phone | Phone | Receiver phone number required |
| HTTP | Webhook | Callback URL required |
| WeCom | WeCom | Webhook URL required |
| DingTalk | DingTalk | Webhook URL required |
| Lark | Lark | Webhook URL required |

### Monitor time type

| Type | Description | Example |
|------|-------------|---------|
| Period | Periodic monitoring | Execute query every 5 minutes |
| Time | Fixed-time monitoring | Execute query at a specific point in time |

### Analysis type

| Type | Description | Use case |
|------|-------------|----------|
| field | Field analysis | Use the field value directly |
| average | Average | Average of a numeric field |
| sum | Sum | Sum of a numeric field |
| min | Minimum | Minimum of a numeric field |
| max | Maximum | Maximum of a numeric field |

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Permissions**
   - Ensure the executing account has CLS and CAM permissions.
   - Receivers must be configured in CAM in advance.

2. **Logset and topic**
   - The CLS logset and topic must be created in advance.
   - Ensure the query syntax matches the log format.

3. **Notice configuration limits**
   - `alarm_notice_ids` and `monitor_notice` cannot be set at the same time.
   - Configure the receiver time window reasonably.

4. **Query performance**
   - Complex queries may affect performance.
   - Optimize the query syntax to reduce scanned data.

5. **Alarm frequency control**
   - Configure `alarm_period` properly to avoid alarm storms.
   - Set different alarm levels based on business importance.

6. **Webhook security**
   - The callback URL must be publicly accessible.
   - Use HTTPS for security.

7. **Multi-conditions**
   - Multiple conditions are combined with AND.
   - Condition expressions must correctly reference analysis fields.

8. **Syntax rule**
   - Lucene (`0`): full-text search and field query.
   - CQL (`1`): SQL-like query syntax.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks CLS or CAM permissions.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check `QcloudCLSFullAccess` and `QcloudCamFullAccess` are included.

#### Error 2: Logset not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Logset not found
```

**Cause**: The specified logset ID does not exist.
**Solution**:
- Confirm the logset ID is correct.
- Check whether the logset has been deleted.

#### Error 3: Invalid query syntax

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid query syntax
```

**Cause**: The query statement has a syntax error.
**Solution**:
- Check the query syntax against Lucene or CQL rules.
- Verify field names and operators.

#### Error 4: Invalid receiver configuration

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid receiver configuration
```

**Cause**: The notice receiver configuration is incorrect.
**Solution**:
- Confirm `receiver_type` is `Uin` or `Group`.
- Check the receiver IDs exist.
- Verify the receiver channels are valid.

#### Error 5: Invalid web callback configuration

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid web callback configuration
```

**Cause**: The web callback configuration is incorrect.
**Solution**:
- Confirm `callback_type` is `Http`, `WeCom`, `DingTalk` or `Lark`.
- Check the URL format.
- Verify `method` is `POST` or `PUT`.

#### Error 6: Invalid monitor time configuration

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid monitor time configuration
```

**Cause**: The monitor time configuration is out of range.
**Solution**:
- Ensure `monitor_time_value` is within 1-1440 minutes.
- Check `monitor_time_type` is `Period` or `Time`.
- Verify `alarm_period` is one of `0,5,10,15,30,60,120,180,360,1440`.

## License

See [LICENSE](../../../LICENSE) for full details.
