variable "users" {
  type        = any
  default     = {}
  description = "Map of users to create. Name is the map key.see `tencentcloud_cam_user` "
}

variable "groups" {
  type        = any
  default     = {}
  description = "Map of groups to create. Name is the map key.see `tencentcloud_cam_group` "
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
