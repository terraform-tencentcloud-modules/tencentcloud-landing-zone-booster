variable "create" {
  type        = bool
  default     = true
  description = "invite member or not"
}

variable "name" {
  type        = string
  description = "Member name"
}

variable "node_id" {
  type        = number
  description = "Organization node ID."
}

variable "permission_ids" {
  type        = list(number)
  default     = []
  description = "Financial management permission IDs.Valid values:- 1: View bill.- 2: Check balance.- 3: Fund transfer.- 4: Combine bill.- 5: Issue an invoice.- 6: Inherit discount.- 7: Pay on behalf.value 1,2 is required."
}

variable "policy_type" {
  type        = string
  default     = "Financial"
  description = " Organization policy type.- Financial: Financial management policy."
}

variable "remark" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}

variable "is_allow_quit" {
  description = "(Optional, String, ForceNew) Whether to allow members to withdraw. Allow: Allow, Disallow: Denied. more see: invite_organization_member_operation"
  type        = string
  default     = "Allow"
}

variable "member_uin" {
  description = " (Required, Int, ForceNew) Invited account Uin. more see: invite_organization_member_operation"
  type        = string
}

variable "pay_uin" {
  default = null
  type = string
  description = "Payer Uin. Member needs to pay on behalf of."
}

variable "tags" {
  type = map(string)
  default = {}
}