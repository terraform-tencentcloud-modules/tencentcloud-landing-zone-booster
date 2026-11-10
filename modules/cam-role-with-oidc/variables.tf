variable "create_oidc" {
  description = "Whether to create a oidc sso."
  type        = bool
  default     = true
}

variable "create_role" {
  description = "Whether to create a role."
  type        = bool
  default     = true
}

variable "create_policy" {
  description = "Whether to create a policy."
  type        = bool
  default     = false
}

variable "client_ids" {
  description = "Client ids."
  type        = set(string)
  default     = [""]
}

variable "identity_key" {
  description = "Sign the public key."
  type        = string
  default     = ""
}

variable "identity_url" {
  description = "Identity provider URL."
  type        = string
  default     = ""
}

variable "oidc_name" {
  description = "The name of cam oidc sso."
  type        = string
  default     = ""
}

variable "oidc_description" {
  description = "The description of cam oidc sso."
  type        = string
  default     = ""
}

variable "role_document" {
  description = <<EOF
  Document of the CAM role. The syntax refers to CAM POLICY. There are some notes when using this para in terraform: 
  1. The elements in json claimed supporting two types as string and array only support type array; 
  2. Terraform does not support the root syntax, when appears, it must be replaced with the uin it stands for.
  EOF
  type        = string
  default     = ""
}

variable "role_name" {
  description = "Name of CAM role."
  type        = string
  default     = ""
}

variable "console_login" {
  description = "Indicates whether the CAM role can login or not."
  type        = bool
  default     = false
}

variable "role_description" {
  description = "Description of the CAM role."
  type        = string
  default     = ""
}

variable "role_tags" {
  description = "A list of tags used to associate different resources."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Name of CAM policy."
  type        = string
  default     = ""
}

variable "policy_description" {
  description = "Description of the CAM policy."
  type        = string
  default     = ""
}

variable "policy_document" {
  description = <<EOF
  Document of the CAM policy. The syntax refers to CAM POLICY. There are some notes when using this para in terraform: 
  1. The elements in JSON claimed supporting two types as string and array only support type array; 
  2. Terraform does not support the root syntax, when it appears, it must be replaced with the uin it stands for.
  EOF
  type        = string
  default     = ""
}

variable "policy_id" {
  description = "ID of the policy."
  type        = string
  default     = ""
}