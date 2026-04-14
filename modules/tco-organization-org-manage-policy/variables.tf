variable "create" {
  description = "invite member or not"
  type        = bool
  default     = true
}

variable "policy_name" {
  description = "policy name"
  default = ""
  type = string
}

variable "content" {
  description = "Policy content. Refer to the CAM policy syntax."
  type = string
  default = ""
}

variable "type" {
  description = "Policy type. Default value is SERVICE_CONTROL_POLICY, other TAG_POLICY"
  default = "SERVICE_CONTROL_POLICY"
  type = string
}

variable "description" {
  description = "desc of the policy"
  default = ""
  type = string
}

variable "target_nodes" {
  type = map(object({
    node_id = number
  }))
  default = {}
  description = "target nodes to attach the policy"
}

variable "target_users" {
  type = map(object({
    user_id = number
  }))
  default = {}
  description = "target users to attach the policy"
}