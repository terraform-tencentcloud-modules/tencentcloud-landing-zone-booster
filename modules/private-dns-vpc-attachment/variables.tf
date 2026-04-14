variable "create" {
  type        = bool
  default     = true
  description = "Create or use an existed one"
}

variable "private_dns_zone_id" {
  type        = string
  default     = ""
  description = "Used when create is false. Specify an existed private_dns"
}

variable "vpc_sets" {
  description = "VPC set for the private DNS zone."
  type =  map(object({
    region      = string # Region of the VPC to associate with the DNS zone.
    uniq_vpc_id = string # Unique VPC ID to associate with DNS zone.
  }))
  default = {
    example = {
      region      = ""
      uniq_vpc_id = ""
    }
  }
}

variable "account_vpc_sets" {
  description = "Account VPC set for cross-account binding."
  type = map(object({
    uniq_vpc_id = string # Unique VPC ID to associate with DNS zone.
    region      = string # Region of the VPC to associate with the DNS zone.
    uin         = string # Vpc owner uin. To grant role authorization to this account. It is necessary to specify when cross-account association is needed.
  }))
  default = {
    example = {
      uniq_vpc_id = ""
      region      = ""
      uin         = ""
    }
  }
}