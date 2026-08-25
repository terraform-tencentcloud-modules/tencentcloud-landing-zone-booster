variable "zone_id" {
  description = "Identity Center Zone ID"
  type        = string
}

variable "role_config" {
  description = "Identity Center Role Configurations"
  type = list(object({
    role_name   = string                 # Access configuration name
    description = optional(string)       # Access configuration description
    relay_state = optional(string)       # Initial access page
    preset_policy_names = optional(list(string)) # Attached the preset policy name list
    custom_policies = optional(list(object({
      name            = string # Attached the custom policy name
      policy_document = string # Attached the custom policy document
    })))
  }))

  default = []
}

variable "session_duration" {
  description = "Session duration in seconds (900-43200), default 7200 (2 hours)"
  type        = number
  default     = 7200

  validation {
    condition     = var.session_duration >= 900 && var.session_duration <= 43200
    error_message = "Session duration must be between 900 (15 minutes) and 43200 (12 hours) seconds."
  }
}

variable "role_assignments" {
  description = "Role assignments to sync roles to member accounts"
  type = list(object({
    role_name            = string           # Role configuration name (must match role_config.role_name)
    principal_id         = string           # CIC user ID (u-******) or group ID (g-******)
    principal_type       = string           # Principal type: User or Group
    target_name          = optional(string) # Target account name (will lookup UIN from organization members)
    target_uin           = optional(number) # Target account UIN (required if target_account_name not provided)
    target_type          = string           # Target type: ManagerUin or MemberUin
    deprovision_strategy = optional(string) # DeprovisionForLastRoleAssignmentOnAccount or None (default)
  }))
  default = []
}
