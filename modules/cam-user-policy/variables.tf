variable "users" {
  description = "CAM user configurations"
  type = list(object({
    name                = string
    remark              = optional(string, "")
    force_delete        = optional(bool, false)
    use_api             = optional(bool, true)
    console_login       = optional(bool, false)
    password            = optional(string)
    need_reset_password = optional(bool, true)
    phone_num           = optional(string)
    country_code        = optional(string)
    email               = optional(string)
    tags                = optional(map(string))
  }))
  
  validation {
    condition = alltrue([
      for user in var.cam_users : 
      length(user.name) >= 1 && length(user.name) <= 64
    ])
    error_message = "The username length must be between 1 and 64 characters."
  }
  
  validation {
    condition = alltrue([
      for user in var.cam_users : 
      can(regex("^[a-zA-Z0-9+=,.@_-]+$", user.name))
    ])
    error_message = "Usernames can only contain letters, numbers, and special characters +=,.@_- ."
  }
  
  validation {
    condition = alltrue([
      for user in var.cam_users : 
      user.remark == null || length(user.remark) <= 300
    ])
    error_message = "The user's remark cannot exceed 300 characters in length."
  }
  
  validation {
    condition = alltrue([
      for user in var.cam_users : 
      user.password == null || (
        length(user.password) >= 8 && 
        length(user.password) <= 32 &&
        can(regex("[A-Z]", user.password)) &&
        can(regex("[a-z]", user.password)) &&
        can(regex("[0-9]", user.password)) &&
        can(regex("[!@#$%^&*()_+-=]", user.password))
      )
    ])
    error_message = "The password must be 8 to 32 characters long, consisting of both uppercase and lowercase letters, numbers, and special characters."
  }
  
  validation {
    condition = alltrue([
      for user in var.cam_users : 
      user.phone_num == null || can(regex("^1[3-9]\\d{9}$", user.phone_num))
    ])
    error_message = "The mobile phone number format is incorrect. It should be a 11-digit mobile phone number."
  }
  
  validation {
    condition = alltrue([
      for user in var.cam_users : 
      user.country_code == null || can(regex("^\\d{1,3}$", user.country_code))
    ])
    error_message = "The country code should consist of 1 to 3 digits."
  }
  
  validation {
    condition = alltrue([
      for user in var.cam_users : 
      user.email == null || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", user.email))
    ])
    error_message = "The email address format is incorrect."
  }
  
  validation {
    condition = alltrue([
      for user in var.cam_users : 
      user.tags == null || alltrue([
        for k, v in user.tags : 
        length(k) <= 128 && length(v) <= 256
      ])
    ])
    error_message = "The maximum length of the tag key is 128 characters, and the maximum length of the tag value is 256 characters."
  }
  
  validation {
    condition = alltrue([
      for user in var.cam_users : 
      !user.console_login || user.password != null || user.need_reset_password
    ])
    error_message = "When enabling console login, a password must be set or the option to reset the password on the first login must be enabled."
  }
}

variable "policies" {
  type        = any
  default     = {}
  description = "Map of policies to create. Name is the map key.see `tencentcloud_cam_policy` "
}

// The variables below are key descriptions for each policy resource. They are not used
variable "policy_name" {
  type        = string
  default     = ""
  description = "Name of CAM policy."
}

variable "document" {
  type        = string
  default     = ""
  description = "Document of the CAM policy. The syntax refers to CAM POLICY. There are some notes when using this para in terraform: 1. The elements in JSON claimed supporting two types as string and array only support type array; 2. Terraform does not support the root syntax, when it appears, it must be replaced with the uin it stands for."
}

variable "policy_description" {
  type        = string
  default     = ""
  description = "Description of the CAM policy."
}

// The variables below are key descriptions for each group resource. They are not used
variable "group_name" {
  type        = string
  default     = ""
  description = "Name of CAM group."
}

variable "group_remark" {
  type        = string
  default     = ""
  description = "Description of the CAM group."
}

variable "policy_names" {
  type        = list(string)
  default     = []
  description = "name of the policies"
}

variable "user_names" {
  type        = list(string)
  default     = []
  description = "User name set as ID of the CAM group members."
}

// The variables below are key descriptions for each user resource. They are not used
variable "user_name" {
  type        = string
  default     = ""
  description = "Name."
}

variable "user_remark" {
  type        = string
  default     = ""
  description = "Remark of the CAM user."
}

variable "need_reset_password" {
  type        = bool
  default     = false
  description = "Indicate whether the CAM user need to reset the password when first logins."
}

variable "password" {
  type        = string
  default     = ""
  description = "The password of the CAM user. Password should be at least 8 characters and no more than 32 characters, includes uppercase letters, lowercase letters, numbers and special characters. Only required when console_login is true. If not set, a random password will be automatically generated."
}

variable "phone_num" {
  type        = string
  default     = ""
  description = "Phone number of the CAM user."
}

variable "email" {
  type        = string
  default     = ""
  description = "Email of the CAM user."
}

variable "user_tags" {
  type = map(string)
  default = {
    created = "terraform-test"
  }
  description = "A list of tags used to associate different resources."
}

variable "policy_id" {
  type        = string
  default     = ""
  description = "ID of the policy."
}