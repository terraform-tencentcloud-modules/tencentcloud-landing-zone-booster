variable "alarm_policies" {
  description = "A map of config alarm policies to create. Key is a logical name used as the for_each key."
  type = map(object({
    name = string
    # Event type. Only value 1 (Resource Non-Compliance Event) is supported. ForceNew.
    type = number
    # Event scope. Valid values: 1 (current account), 2 (multi-account).
    event_scope = list(number)
    # Risk level list. Valid values: 1 (high), 2 (medium), 3 (low).
    risk_level = list(number)
    # Notification time range, format: HH:mm:ss~HH:mm:ss (e.g. 09:30:00~23:30:00).
    notice_time = string
    # Notification mechanism.
    notification_mechanism = string
    # Policy status. Valid values: 1 (enabled), 2 (disabled).
    status = number
    # Notification weekday list, 1-7 represent Monday to Sunday.
    notice_period = list(number)
    # Policy description.
    description = optional(string)
  }))

  validation {
    condition = alltrue([
      for k, v in var.alarm_policies : v.type == 1
    ])
    error_message = "The type of an alarm policy must be 1 (Resource Non-Compliance Event)."
  }

  validation {
    condition = alltrue([
      for k, v in var.alarm_policies :
      length(v.event_scope) > 0 && alltrue([for s in v.event_scope : contains([1, 2], s)])
    ])
    error_message = "event_scope must contain at least one value and each value must be 1 (current account) or 2 (multi-account)."
  }

  validation {
    condition = alltrue([
      for k, v in var.alarm_policies :
      length(v.risk_level) > 0 && alltrue([for r in v.risk_level : contains([1, 2, 3], r)])
    ])
    error_message = "risk_level must contain at least one value and each value must be 1 (high), 2 (medium) or 3 (low)."
  }

  validation {
    condition = alltrue([
      for k, v in var.alarm_policies : contains([1, 2], v.status)
    ])
    error_message = "status must be 1 (enabled) or 2 (disabled)."
  }

  validation {
    condition = alltrue([
      for k, v in var.alarm_policies :
      length(v.notice_period) > 0 && alltrue([for p in v.notice_period : p >= 1 && p <= 7])
    ])
    error_message = "notice_period must contain at least one weekday and each value must be between 1 (Monday) and 7 (Sunday)."
  }
}
