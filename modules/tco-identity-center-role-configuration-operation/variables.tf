variable "create" {
  type        = bool
  default     = true
  description = "Whether to create the resources."
}

variable "zone_id" {
  type        = string
  default     = null
  description = "The zone id for Tencent Cloud provision role operation."
}

variable "target_uin" {
  type        = number
  default     = null
  description = "The target UIN for the provision operation."
}

variable "target_type" {
  type        = string
  default     = "MemberUin"
  description = "Type of the synchronized target account of the Tencent Cloud Organization. ManagerUin: admin account; MemberUin: member account."
}

variable "role_id" {
  type        = string
  default     = null
  description = "The role configuration ID."
}

variable "deployment_status" {
  type        = string
  default     = ""
  description = "Output from cic-role-assignment, if value is DeployedRequired, will trigger the redeploy"
}