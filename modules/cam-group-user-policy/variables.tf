variable "users" {
  type = map(object({
    user_remark         = optional(string, "")
    console_login       = optional(bool, true)
    use_api             = optional(bool, true)
    need_reset_password = optional(bool, true)
    password            = optional(string)
    phone_num           = optional(string, "")
    email               = optional(string, "")
    country_code        = optional(string, "86")
    force_delete        = optional(bool, true)
    user_tags           = optional(map(string), {})
  }))
  default     = {}
  description = "Map of users to create. The map key is used as the user name (see `tencentcloud_cam_user`)."

  validation {
    condition = alltrue([
      for user in var.users :
      user.user_remark == null || length(user.user_remark) <= 300
    ])
    error_message = "The user's remark cannot exceed 300 characters in length."
  }

  validation {
    condition = alltrue([
      for user in var.users :
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
      for user in var.users :
      user.phone_num == null || user.phone_num == "" || can(regex("^1[3-9]\\d{9}$", user.phone_num))
    ])
    error_message = "The mobile phone number format is incorrect. It should be an 11-digit mobile phone number."
  }

  validation {
    condition = alltrue([
      for user in var.users :
      user.country_code == null || can(regex("^\\d{1,3}$", user.country_code))
    ])
    error_message = "The country code should consist of 1 to 3 digits."
  }

  validation {
    condition = alltrue([
      for user in var.users :
      user.email == null || user.email == "" || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", user.email))
    ])
    error_message = "The email address format is incorrect."
  }

  validation {
    condition = alltrue([
      for user in var.users :
      user.user_tags == null || alltrue([
        for k, v in user.user_tags :
        length(k) <= 128 && length(v) <= 256
      ])
    ])
    error_message = "The maximum length of the tag key is 128 characters, and the maximum length of the tag value is 256 characters."
  }

  validation {
    condition = alltrue([
      for user in var.users :
      !user.console_login || user.password != null || user.need_reset_password
    ])
    error_message = "When enabling console login, a password must be set or the option to reset the password on the first login must be enabled."
  }
}

variable "groups" {
  type = map(object({
    name                = optional(string)
    group_remark        = optional(string)
    pre_policy_names    = optional(list(string), [])
    custom_policy_names = optional(list(string), [])
    user_names          = optional(list(string), [])
  }))
  default     = {}
  description = "Map of groups to create. The map key is used as the group name when `name` is not set (see `tencentcloud_cam_group`)."

  validation {
    condition = alltrue([
      for group in var.groups :
      group.name == null || (length(group.name) >= 1 && length(group.name) <= 128)
    ])
    error_message = "The group name length must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for group in var.groups :
      group.group_remark == null || length(group.group_remark) <= 300
    ])
    error_message = "The group remark cannot exceed 300 characters in length."
  }

  validation {
    condition = alltrue([
      for group in var.groups :
      group.user_names == null || length(distinct(group.user_names)) == length(group.user_names)
    ])
    error_message = "Duplicate user names are not allowed within a single group's user_names."
  }
}

variable "policies" {
  type = map(object({
    document    = optional(string)
    description = optional(string)
  }))
  default     = {}
  description = "Map of custom policies to create. The map key is used as the policy name (see `tencentcloud_cam_policy`)."

  validation {
    condition = alltrue([
      for policy in var.policies :
      policy.document == null || length(policy.document) <= 6144
    ])
    error_message = "The policy document cannot exceed 6144 characters in length."
  }

  validation {
    condition = alltrue([
      for policy in var.policies :
      policy.description == null || length(policy.description) <= 300
    ])
    error_message = "The policy description cannot exceed 300 characters in length."
  }
}

// The variables below are key descriptions for each policy resource. They are not used
# variable "policy_name" {
#   type        = string
#   default     = ""
#   description = "Name of CAM policy."
# }

# variable "document" {
#   type        = string
#   default     = ""
#   description = "Document of the CAM policy. The syntax refers to CAM POLICY. There are some notes when using this para in terraform: 1. The elements in JSON claimed supporting two types as string and array only support type array; 2. Terraform does not support the root syntax, when it appears, it must be replaced with the uin it stands for."
# }

# variable "policy_description" {
#   type        = string
#   default     = ""
#   description = "Description of the CAM policy."
# }

# // The variables below are key descriptions for each group resource. They are not used
# variable "group_name" {
#   type        = string
#   default     = ""
#   description = "Name of CAM group."
# }

# variable "group_remark" {
#   type        = string
#   default     = ""
#   description = "Description of the CAM group."
# }

# variable "policy_names" {
#   type        = list(string)
#   default     = []
#   description = "name of the policies"
# }

# variable "user_names" {
#   type        = list(string)
#   default     = []
#   description = "User name set as ID of the CAM group members."
# }

# // The variables below are key descriptions for each user resource. They are not used
# variable "user_name" {
#   type        = string
#   default     = ""
#   description = "Name."
# }

# variable "user_remark" {
#   type        = string
#   default     = ""
#   description = "Remark of the CAM user."
# }

# variable "need_reset_password" {
#   type        = bool
#   default     = false
#   description = "Indicate whether the CAM user need to reset the password when first logins."
# }

# variable "password" {
#   type        = string
#   default     = ""
#   description = "The password of the CAM user. Password should be at least 8 characters and no more than 32 characters, includes uppercase letters, lowercase letters, numbers and special characters. Only required when console_login is true. If not set, a random password will be automatically generated."
# }

# variable "phone_num" {
#   type        = string
#   default     = ""
#   description = "Phone number of the CAM user."
# }

# variable "email" {
#   type        = string
#   default     = ""
#   description = "Email of the CAM user."
# }

# variable "user_tags" {
#   type = map(string)
#   default = {
#     created = "terraform-test"
#   }
#   description = "A list of tags used to associate different resources."
# }

# variable "policy_id" {
#   type        = string
#   default     = ""
#   description = "ID of the policy."
# }
