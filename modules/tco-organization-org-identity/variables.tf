variable "identity_alias_name" {
  description = "Identity alias name"
  type        = string
  default     = "CrossOrgAccount"
}

variable "description" {
  description = "Identity description"
  type        = string
  default     = null
}

variable "identity_policies" {
  description = "Identity policies"
  type = list(object({
    policy_id       = optional(number) # CAM default policy ID. Valid and required when PolicyType is the 2-preset policy.
    policy_name     = optional(string) # CAM default policy name. Valid and required when PolicyType is the 2-preset policy.
    policy_type     = optional(number) # Policy type. Value 1-custom policy 2-preset policy; default value 2.
    policy_document = optional(string) # Customize policy content and follow CAM policy syntax. Valid and required when PolicyType is the 1-custom policy.
  }))
}