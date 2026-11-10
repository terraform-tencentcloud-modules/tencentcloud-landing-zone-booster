# user config
variable "user_name" {
  description = "Name of the CAM user."
  type        = string
}

variable "user_phone_number" {
  description = "Phone number of the CAM user."
  type        = string
  default     = null
}

variable "phone_country_code" {
  description = "Country code of the phone number, for example: '86'."
  type        = string
  default     = null
}

variable "user_email" {
  description = "Email of the CAM user."
  type        = string
  default     = null
}

variable "user_remark" {
  description = "Remark of the CAM user."
  type        = string
  default     = null
}

variable "console_login" {
  description = "Indicate whether the CAM user can login to the web console or not."
  type        = bool
  default     = false
}

variable "use_api" {
  description = "Indicate whether to generate the API secret key or not."
  type        = bool
  default     = true
}

variable "need_reset_password" {
  description = "Indicate whether the CAM user need to reset the password when first logins."
  type        = bool
  default     = true
}

variable "user_password" {
  description = "The password of the CAM user. Password should be at least 8 characters and no more than 32 characters, includes uppercase letters, lowercase letters, numbers and special characters. Only required when console_login is true. If not set, a random password will be automatically generated."
  type        = string
  default     = null
  sensitive   = true
}

variable "force_delete" {
  description = "Indicate whether to force deletes the CAM user. If set false, the API secret key will be checked and failed when exists; otherwise the user will be deleted directly. Default is false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A list of tags used to associate different resources."
  type        = map(string)
  default     = null
}

# policy config
variable "cam_policy" {
  description = "CAM policy configurations"
  type = object({
    # predefined policies
    pre_policies = optional(list(string), [])
    
    # 多个策略配置
    custom_policies = optional(list(object({
      name        = string
      document    = string
      description = optional(string)
      tags        = optional(map(string))
    })), [])
  })
}