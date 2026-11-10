variable "assume_role_policies" {
  description = "Assume role policies"
  type = list(object({
    assume_role_name = string           # Identity alias name
    description      = optional(string) # Identity description
    policies = list(object({
      policy_id       = optional(number) # CAM default policy ID. Valid and required when PolicyType is the 2-preset policy.
      policy_name     = optional(string) # CAM default policy name. Valid and required when PolicyType is the 2-preset policy.
      policy_type     = optional(number) # Policy type. Value 1-custom policy 2-preset policy; default value 2.
      policy_document = optional(string) # Customize policy content and follow CAM policy syntax. Valid and required when PolicyType is the 1-custom policy.
    }))
    members = list(object({
      member_uin   = optional(number) # Member uin
      member_name  = optional(string) # Member name
    }))
  }))
}