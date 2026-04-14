# role config
variable "role_name" {
  description = "Name of CAM role"
  type        = string
}

variable "description" {
  description = "Description of CAM role"
  type        = string
  default     = null
}

variable "console_login" {
	description = "Indicates whether the CAM role can login or not."
	type        = bool
  default     = false
}

variable "session_duration" {
	description = "The maximum validity period of the temporary key for creating a role."
	type        = number
  default     = 7200
}

variable "principal" {
	description = "Principal of CAM role, account_name can be member name or cam user name, if account_uin and account_name are empty, it will use the owner uin of current account"
	type = object({
    type         = number # Role principal type, 1 - Account, 2 - Service
    account_uin  = optional(string) # Account UIN
    account_name = optional(string) # Account Name
    service_name = optional(string) # Service name
  })
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