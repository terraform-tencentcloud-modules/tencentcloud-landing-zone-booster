variable "organization_id" {
  type        = string
  description = "Organization ID"
}

variable "org_service_policies" {
  description = "Organization management policy"
  type = list(object({
    name        = string           # Policy name. The length is 1~128 characters, which can include Chinese characters, English letters, numbers, and underscores.
    path        = string           # Policy file path.
    description = optional(string) # Policy description.
    targets     = list(object({
      target_id   = optional(number, null) # Binding target ID of the policy. Member Uin or Department ID.
      target_name = optional(string, null) # Binding target ID of the policy. Member Uin or Department ID.
      target_type = string                 # Target type. Valid values: `NODE`: Department. `MEMBER`: Check Member.
    }))
  }))
}