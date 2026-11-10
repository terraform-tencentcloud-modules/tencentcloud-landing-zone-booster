variable "compliance_packs" {
  description = "A map of config compliance packs to create. Key is a logical name used as the for_each key."
  type = map(object({
    compliance_pack_name = string
    # Risk level of the compliance pack. Valid values: 1 (high), 2 (medium), 3 (low).
    risk_level = number
    # List of compliance pack rules. The set is keyed by `identifier`.
    config_rules = set(object({
      # Rule identifier (managed rule name or custom rule cloud function ARN). Required.
      identifier = string
      # Rule name.
      rule_name = optional(string)
      # Rule description.
      description = optional(string)
      # Rule risk level. Valid values: 1 (high), 2 (medium), 3 (low).
      risk_level = optional(number)
      # Managed rule identifier (preset rule identity).
      managed_rule_identifier = optional(string)
      # Config rule ID.
      config_rule_id = optional(string)
      # Compliance pack ID that this rule belongs to.
      compliance_pack_id = optional(string)
      # Rule input parameters.
      input_parameter = optional(list(object({
        parameter_key = string
        type          = optional(string)
        value         = optional(string)
      })), [])
    }))
    # Description of the compliance pack.
    description = optional(string)
    # Compliance pack status. Valid values: ACTIVE, UN_ACTIVE. Defaults to ACTIVE when omitted.
    status = optional(string)
  }))

  validation {
    condition = alltrue([
      for k, v in var.compliance_packs : contains([1, 2, 3], v.risk_level)
    ])
    error_message = "risk_level must be 1 (high), 2 (medium) or 3 (low)."
  }

  validation {
    condition = alltrue([
      for k, v in var.compliance_packs :
      v.status == null || contains(["ACTIVE", "UN_ACTIVE"], v.status)
    ])
    error_message = "status must be ACTIVE or UN_ACTIVE."
  }

  validation {
    condition = alltrue([
      for k, v in var.compliance_packs :
      alltrue([
        for r in v.config_rules : r.risk_level == null || contains([1, 2, 3], r.risk_level)
      ])
    ])
    error_message = "Each config rule's risk_level (when set) must be 1 (high), 2 (medium) or 3 (low)."
  }
}
