variable "create" {
  type        = bool
  default     = true
  description = "Create or use an existed one"
}

variable "domain" {
  default = ""
  type = string
}

variable "dns_forward_status" {
  type        = string
  default     = "DISABLED"
  description = "Whether to enable subdomain recursive DNS. Valid values: ENABLED, DISABLED. Default value: DISABLED."
}

variable "remark" {
  type        = string
  default     = "remark"
  description = "The remark of Domain."
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the resource."
  default     = {
    env = "nonprod"
  }
}

#variable "vpc_set" {
#  description = "VPC set for the private DNS zone."
#  type = object({
#    region      = string # Region of the VPC to associate with the DNS zone.
#    uniq_vpc_id = string # Unique VPC ID to associate with DNS zone.
#  })
#}

#variable "account_vpc_set" {
#  description = "Account VPC set for cross-account binding."
#  type = object({
#    uin         = string
#    uniq_vpc_id = string
#    region      = string
#    vpc_name    = string
#  })
#}