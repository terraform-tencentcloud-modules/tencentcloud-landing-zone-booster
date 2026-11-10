variable "config_rules" {
  description = "A map of config rules to create. Key is a logical name used as the for_each key."
  type = map(object({
    # Rule template identifier. For system preset rules use the identifier name; for custom rules use the cloud function ARN (region:functionName).
    identifier = string
    # Rule template type. Valid values: SYSTEM, CUSTOMIZE.
    identifier_type = string
    # Rule name.
    rule_name = string
    # Supported resource type list (e.g. QCS::CAM::User).
    resource_type = list(string)
    # Trigger type list, up to 2 entries.
    trigger_type = list(object({
      # Trigger message type. Valid values: ScheduledNotification, ConfigurationItemChangeNotification.
      message_type = string
      # Maximum execution frequency (only for ScheduledNotification). e.g. TwentyFour_Hours.
      maximum_execution_frequency = optional(string)
    }))
    # Risk level. Valid values: 1 (high risk), 2 (medium risk), 3 (low risk).
    risk_level = number
    # Rule input parameter list.
    input_parameter = optional(list(object({
      parameter_key = string
      type          = optional(string)
      value         = optional(string)
    })), [])
    # Rule description (0~1024 characters).
    description = optional(string)
    # Region scope list; rule only applies to resources in the specified regions.
    regions_scope = optional(list(string))
    # Tag scope list; rule only applies to resources with the specified tags.
    tags_scope = optional(list(object({
      tag_key   = string
      tag_value = string
    })), [])
    # Resource ID list excluded from rule evaluation.
    exclude_resource_ids_scope = optional(list(string))
    # Rule status. Valid values: ACTIVE (enabled), UN_ACTIVE (disabled).
    status = optional(string)
  }))

  validation {
    condition = alltrue([
      for k, v in var.config_rules : contains(["SYSTEM", "CUSTOMIZE"], v.identifier_type)
    ])
    error_message = "identifier_type must be SYSTEM or CUSTOMIZE."
  }

  validation {
    condition = alltrue([
      for k, v in var.config_rules : contains([1, 2, 3], v.risk_level)
    ])
    error_message = "risk_level must be 1 (high risk), 2 (medium risk) or 3 (low risk)."
  }

  validation {
    condition = alltrue([
      for k, v in var.config_rules : v.status == null || contains(["ACTIVE", "UN_ACTIVE"], v.status)
    ])
    error_message = "status must be ACTIVE or UN_ACTIVE."
  }

  validation {
    condition = alltrue([
      for k, v in var.config_rules : alltrue([
        for rt in v.resource_type : can(regex("^QCS::", rt))
      ])
    ])
    error_message = "Each item in resource_type must be a valid resource type identifier starting with 'QCS::' (e.g. QCS::CAM::User)."
  }

  validation {
    condition = alltrue([
      for k, v in var.config_rules : alltrue([
        for tt in v.trigger_type : contains(["ScheduledNotification", "ConfigurationItemChangeNotification"], tt.message_type)
      ])
    ])
    error_message = "Each trigger_type message_type must be ScheduledNotification or ConfigurationItemChangeNotification."
  }
}
