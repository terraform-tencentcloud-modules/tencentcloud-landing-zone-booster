variable "member_name" {
  description = "The name of the organization member."
  type        = string
}

variable "node_id" {
  description = "Organization node ID."
  type        = number
  default     = null
}

variable "permission_ids" {
  description = <<-EOD
    Financial management permission IDs. Valid values:
    - 1: View bill
    - 2: Check balance
    - 3: Fund transfer
    - 4: Combine bill
    - 5: Issue an invoice
    - 6: Inherit discount
    - 7: Pay on behalf

    Values 1 and 2 are required.
  EOD
  type = list(number)
}

variable "policy_type" {
  description = "Organization policy type. Financial: Financial management policy."
  type        = string
}

variable "pay_uin" {
  description = "The UIN of the payment account on behalf. Required when permission_ids contains 7."
  type        = string
  default     = null
}

# Optional variables
variable "force_delete_account" {
  description = "Whether to force delete the member account when deleting the organization member. Only applicable to creation-type members, not invitation-type. Default is false."
  type        = bool
  default     = false
}

variable "is_modify_nick_name" {
  description = "Whether to synchronize organization member names to their account nicknames. Values: 1: Sync, 0: Do not sync. This parameter takes effect only when the name field is being modified."
  type        = bool
  default     = null
}

variable "record_id" {
  description = "Create member record ID. Required when creation failed and needs to be recreated."
  type        = number
  default     = null
}

variable "remark" {
  description = "Remark for the organization member."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags assigned to the organization member. Map of key-value strings."
  type        = map(string)
  default     = null
}

# Security information
variable "enable_bound" {
  description = "Whether to enable security information binding. Default is false. An activation email will be sent to the specified email address after binding."
  type        = bool
  default     = false
}

variable "email" {
  description = "The email address of the user or contact person."
  type        = string
  default     = null
}

variable "phone" {
  description = "The phone of the user or contact person."
  type        = string
  default     = null
}

variable "country_code" {
  description = "The country code for the phone number (e.g., 86 for China)."
  type        = number
  default     = 86
}