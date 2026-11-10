variable "zone_id" {
  description = "cic zone id"
  type        = string
}

variable "roles" {
  description = "A map of role configurations for creation."
  type = list(object({
    role_name        = string                 # permission name
    relay_state      = optional(string)       # Initial access page. It indicates the initial access page URL when CIC users use the access configuration to access the target account of the Tencent Cloud Organization. This page must be the Tencent Cloud console page. The default is null, which indicates navigating to the home page of the Tencent Cloud console.
    session_duration = optional(number)       # Session duration. It indicates the maximum session duration when CIC users use the access configuration to access the target account of the Tencent Cloud Organization. Unit: seconds. Value range: 900-43,200 (15 minutes to 12 hours). Default value: 3600 (1 hour)
    description      = optional(string)       # permission description
    policies         = optional(list(string), []) # policies to attach to this role
    custom_policies  = optional(list(object({  # multi custom policies
      role_policy_name     = string # (Required, String, ForceNew) Role policy name.
      role_policy_document = string # (Required, String, ForceNew) Role policy document.
    })), [])
  }))
}