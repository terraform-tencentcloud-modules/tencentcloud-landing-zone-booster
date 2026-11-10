variable "remediations" {
  description = "A map of config remediation settings to create. Key is a logical name used as the for_each key."
  type = map(object({
    # Config rule ID to bind the remediation setting to.
    rule_id = string
    # Remediation type. Valid value: SCF.
    remediation_type = string
    # Remediation template ID (e.g. SCF function resource path: qcs::scf:ap-guangzhou:uin/functions/xxx).
    remediation_template_id = string
    # Remediation execution mode. Valid values: MANUAL_EXECUTION, AUTO_EXECUTION, NON_EXECUTION, NOT_CONFIG.
    invoke_type = string
    # Template source. Valid value: CUSTOM.
    source_type = optional(string)
  }))

  validation {
    condition = alltrue([
      for k, v in var.remediations : contains(["SCF"], v.remediation_type)
    ])
    error_message = "remediation_type must be SCF."
  }

  validation {
    condition = alltrue([
      for k, v in var.remediations : contains(["MANUAL_EXECUTION", "AUTO_EXECUTION", "NON_EXECUTION", "NOT_CONFIG"], v.invoke_type)
    ])
    error_message = "invoke_type must be MANUAL_EXECUTION, AUTO_EXECUTION, NON_EXECUTION or NOT_CONFIG."
  }

  validation {
    condition = alltrue([
      for k, v in var.remediations : v.source_type == null || contains(["CUSTOM"], v.source_type)
    ])
    error_message = "source_type must be CUSTOM."
  }
}
