################################################################################
### EIP vars
################################################################################
variable "eip" {
  description = "EIP configuration object"
  type = object({
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
  })
  default = {}

  validation {
    condition     = contains(["EIP", "AnycastEIP", "HighQualityEIP", "AntiDDoSEIP", "ResidentialEIP"], var.eip.type)
    error_message = "Valid values for type: EIP, AnycastEIP, HighQualityEIP, AntiDDoSEIP, ResidentialEIP."
  }

  validation {
    condition     = contains(["BANDWIDTH_PACKAGE", "BANDWIDTH_POSTPAID_BY_HOUR", "BANDWIDTH_PREPAID_BY_MONTH", "TRAFFIC_POSTPAID_BY_HOUR"], var.eip.internet_charge_type)
    error_message = "Valid values for internet_charge_type: BANDWIDTH_PACKAGE, BANDWIDTH_POSTPAID_BY_HOUR, BANDWIDTH_PREPAID_BY_MONTH, TRAFFIC_POSTPAID_BY_HOUR."
  }

  validation {
    condition     = var.eip.internet_service_provider == null || contains(["BGP", "CMCC", "CTCC", "CUCC"], var.eip.internet_service_provider)
    error_message = "Valid values for internet_service_provider: BGP, CMCC, CTCC, CUCC."
  }

  validation {
    condition     = contains([0, 1, 2], var.eip.auto_renew_flag)
    error_message = "Valid values for auto_renew_flag: 0 (manual renew), 1 (automatic renew), 2 (explicit no automatic renew)."
  }

  validation {
    condition     = contains([1, 2, 3, 4, 6, 7, 8, 9, 12, 24, 36], var.eip.prepaid_period)
    error_message = "Valid values for prepaid_period: 1, 2, 3, 4, 6, 7, 8, 9, 12, 24, 36."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

