variable "vpc_id" {
  type        = string
  description = "ID of vpc where nat gateway created"
}

variable "nat_gateways" {
  description = "NAT Gateway configurations"
  type = map(object({
    name                 = string
    zone                 = optional(string)
    product_version      = optional(number, 2) # 1: traditional NAT, 2: standard NAT
    bandwidth            = optional(number, 100)
    concurrent           = optional(number, 1000000)
    public_bandwidth_out = optional(number)
    enable_flow_monitor  = optional(bool, false)
    public_ips           = optional(list(string), []) 
    eips = optional(list(object({
      name                       = optional(string, "Unnamed")
      type                       = optional(string, "EIP")
      internet_charge_type       = optional(string, "TRAFFIC_POSTPAID_BY_HOUR")
      internet_max_bandwidth_out = optional(number, 5)
      internet_service_provider  = optional(string, "BGP")
      prepaid_period             = optional(number, 1)
      auto_renew_flag            = optional(number, 0)
      bandwidth_package_id       = optional(string)
      egress                     = optional(string)
      anycast_zone               = optional(string)
      anti_ddos_package_id       = optional(string)
    })))
  }))
  default = {}

  validation {
    condition = alltrue([
      for eip in flatten([for ng in var.nat_gateways : coalesce(ng.eips, [])]) :
      contains(["EIP", "AnycastEIP", "HighQualityEIP", "AntiDDoSEIP", "ResidentialEIP"], eip.type)
    ])
    error_message = "Valid values for eips[].type: EIP, AnycastEIP, HighQualityEIP, AntiDDoSEIP, ResidentialEIP."
  }

  validation {
    condition = alltrue([
      for eip in flatten([for ng in var.nat_gateways : coalesce(ng.eips, [])]) :
      contains(["BANDWIDTH_PACKAGE", "BANDWIDTH_POSTPAID_BY_HOUR", "BANDWIDTH_PREPAID_BY_MONTH", "TRAFFIC_POSTPAID_BY_HOUR"], eip.internet_charge_type)
    ])
    error_message = "Valid values for eips[].internet_charge_type: BANDWIDTH_PACKAGE, BANDWIDTH_POSTPAID_BY_HOUR, BANDWIDTH_PREPAID_BY_MONTH, TRAFFIC_POSTPAID_BY_HOUR."
  }

  validation {
    condition = alltrue([
      for eip in flatten([for ng in var.nat_gateways : coalesce(ng.eips, [])]) :
      eip.internet_service_provider == null || contains(["BGP", "CMCC", "CTCC", "CUCC"], eip.internet_service_provider)
    ])
    error_message = "Valid values for eips[].internet_service_provider: BGP, CMCC, CTCC, CUCC."
  }

  validation {
    condition = alltrue([
      for eip in flatten([for ng in var.nat_gateways : coalesce(ng.eips, [])]) :
      contains([0, 1, 2], eip.auto_renew_flag)
    ])
    error_message = "Valid values for eips[].auto_renew_flag: 0 (manual renew), 1 (automatic renew), 2 (explicit no automatic renew)."
  }

  validation {
    condition = alltrue([
      for eip in flatten([for ng in var.nat_gateways : coalesce(ng.eips, [])]) :
      contains([1, 2, 3, 4, 6, 7, 8, 9, 12, 24, 36], eip.prepaid_period)
    ])
    error_message = "Valid values for eips[].prepaid_period: 1, 2, 3, 4, 6, 7, 8, 9, 12, 24, 36."
  }
}

variable "nat_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "eip_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}