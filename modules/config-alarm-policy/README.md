# Config Alarm Policy Module

Manage [Tencent Cloud Config alarm policies](https://www.tencentcloud.com/document/product/1211) (`tencentcloud_config_alarm_policy`) in a Landing Zone. An alarm policy notifies you (e.g. via the notification mechanism) when a resource compliance event occurs, so you can react to non-compliant resources across the current account or multiple accounts.

This module follows the "single-big-object `for_each`" convention used across `tc-modules`: a single map variable `alarm_policies` drives all instances, keyed by a logical name.

## Features

- Create multiple alarm policies in one declaration via `for_each`.
- Plan-time `validation` that fails fast with readable messages when field values are out of the allowed ranges.
- All required fields of the resource are exposed; `description` is optional.

## Usage

```hcl
module "config_alarm_policy" {
  source = "../../tc-modules/modules/config-alarm-policy"

  alarm_policies = {
    daily_high_risk = {
      name                   = "daily-high-risk-alarm"
      type                   = 1 # Resource Non-Compliance Event (only supported value)
      event_scope            = [1] # current account
      risk_level             = [1, 2, 3] # high, medium, low
      notice_time            = "09:30:00~23:30:00"
      notification_mechanism = "email" # adjust to your actual mechanism
      status                 = 1 # enabled
      notice_period          = [1, 2, 3, 4, 5] # Mon-Fri
      description            = "Notify on resource non-compliance during business hours"
    }

    multi_account_weekend = {
      name                   = "multi-account-weekend-alarm"
      type                   = 1
      event_scope            = [2] # multi-account
      risk_level             = [1] # high only
      notice_time            = "00:00:00~23:59:59"
      notification_mechanism = "sms"
      status                 = 2 # disabled
      notice_period          = [6, 7] # Sat-Sun
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | >= 1.81.136 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `alarm_policies` | A map of config alarm policies to create. Key is a logical name used as the `for_each` key. | `map(object({ name = string, type = number, event_scope = list(number), risk_level = list(number), notice_time = string, notification_mechanism = string, status = number, notice_period = list(number), description = optional(string) }))` | n/a | yes |

### Alarm policy object fields

| Field | Description |
|-------|-------------|
| `name` | Alarm policy name. |
| `type` | Event type. Only `1` (Resource Non-Compliance Event) is supported. `ForceNew`. |
| `event_scope` | Event scope. `1` (current account), `2` (multi-account). At least one value required. |
| `risk_level` | Risk level list. `1` (high), `2` (medium), `3` (low). At least one value required. |
| `notice_time` | Notification time range, format `HH:mm:ss~HH:mm:ss` (e.g. `09:30:00~23:30:00`). |
| `notification_mechanism` | Notification mechanism. |
| `status` | Policy status. `1` (enabled), `2` (disabled). |
| `notice_period` | Notification weekday list, `1`-`7` represent Monday to Sunday. At least one value required. |
| `description` | Policy description (optional). |

## Outputs

Because the resource is created with `for_each`, every output is a `map` keyed by the same logical name used in `var.alarm_policies`.

| Name | Description |
|------|-------------|
| `alarm_policy_ids` | Map of alarm policy logical name to its resource id (same as `alarm_policy_unique_ids`). |
| `alarm_policy_unique_ids` | Map of alarm policy logical name to its unique alarm policy id (`alarm_policy_id`). |
| `names` | Map of alarm policy logical name to its name. |
| `status` | Map of alarm policy logical name to its status (1 enabled, 2 disabled). |

## Notes / Constraints

- `type` is `ForceNew`: changing it triggers resource recreation.
- `event_scope`, `risk_level` and `notice_period` are lists of integers; each must be non-empty and within the documented value ranges (enforced by `validation`).
- `notice_time` must follow the `HH:mm:ss~HH:mm:ss` format expected by the cloud API.

## Authors

`tc-modules` maintainers.
