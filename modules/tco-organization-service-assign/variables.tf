variable "management_scope" {
  type        = number
  default     = 1
  description = "Management scope of the delegated admin. Valid values: 1 (all members), 2 (partial members). Default value: `1`."
}

variable "service_assign_list" {
  description = "A list of organization members. Key is unique member name."
  type = list(object({
    member_uin   = number # Member UIN
    service_name = string # Organization service product name
  }))
}