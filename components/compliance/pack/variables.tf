variable "system_compliance_pack_id" {
  type        = string
  description = "The compliance_pack_id of the system compliance pack to look up from tencentcloud_system_config_compliance_packs and create as a custom compliance pack."
  default     = null
}

variable "system_compliance_pack_name" {
  type        = string
  description = "The compliance_pack_name of the system compliance pack to look up from tencentcloud_system_config_compliance_packs and create as a custom compliance pack."
  default     = null
}

variable "compliance_pack_name" {
  type        = string
  description = "Custom compliance pack name. Defaults to the source system pack name when not set."
}

variable "risk_level" {
  type        = number
  description = "Custom compliance pack risk level (1: high, 2: medium, 3: low). Defaults to the source system pack risk_level when not set."
}

variable "description" {
  type        = string
  default     = null
  description = "Custom compliance pack description. Defaults to the source system pack description when not set."
}

variable "status" {
  type        = string
  default     = "ACTIVE"
  description = "Compliance pack status. Valid values: ACTIVE, UN_ACTIVE. Defaults to ACTIVE."
}

variable "exclude_rules" {
  type        = list(string)
  default     = []
  description = "List of rule identifiers to exclude from the source system pack when creating the custom compliance pack."
}

variable "custom_config_rules" {
  type = list(object({
    identifier              = string
    rule_name               = optional(string)
    description             = optional(string)
    risk_level              = optional(number)
    managed_rule_identifier = optional(string)
    config_rule_id          = optional(string)
    compliance_pack_id      = optional(string)
    input_parameter = optional(list(object({
      parameter_key = string
      type          = optional(string) # Parameter type: Require or Optional.
      value         = optional(string)
    })), [])
  }))
  default     = []
  description = "Additional custom compliance pack rules to merge with (and override by identifier) the source system pack rules. `identifier` is required for every rule."
}
