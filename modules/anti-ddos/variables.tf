variable "instance_charge_type" {
  type        = string
  description = "Payment Type: Payment Mode: PREPAID (Prepaid) / POSTPAID_BY_MONTH (Postpaid)."
  validation {
    condition     = contains(["PREPAID", "POSTPAID_BY_MONTH"], var.instance_charge_type)
    error_message = "Instance charge type must be either PREPAID or POSTPAID_BY_MONTH."
  }
}

variable "package_type" {
  type        = string
  description = "High-defense package types: Enterprise, Standard, StandardPlus (Standard Edition 2.0)."
  validation {
    condition     = contains(["Enterprise", "Standard", "StandardPlus"], var.package_type)
    error_message = "Package type must be either Enterprise, Standard, or StandardPlus."
  }
}

variable "instance_charge_prepaid" {
  type = list(object({
    period = optional(number)     # Purchase period in months.
    renew_flag = optional(string) # OTIFY_AND_MANUAL_RENEW: Notify the user of the expiration date and do not automatically renew. NOTIFY_AND_AUTO_RENEW: Notify the user of the expiration date and automatically renew. DISABLE_NOTIFY_AND_MANUAL_RENEW: Do not notify the user of the expiration date and do not automatically renew. The default is: Notify the user of the expiration date and do not automatically renew.
  }))
  default     = []
  description = "Prepaid configuration."
  validation {
    condition     = length(var.instance_charge_prepaid) <= 1
    error_message = "Only one prepaid configuration is allowed."
  }
}

variable "enterprise_package_config" {
  type = list(object({
    region                    = string # The region where the high-defense package was purchased.
    protect_ip_count          = number # Number of protected IPs.
    basic_protect_bandwidth   = number # Guaranteed protection bandwidth.
    bandwidth                 = number # Service bandwidth scale.
    elastic_protect_bandwidth = optional(number, 0)   # Elastic bandwidth (Gbps), selectable elastic bandwidth [0, 400, 500, 600, 800, 1000], default is 0.
    elastic_bandwidth_flag    = optional(bool, false) # Whether to enable elastic service bandwidth. The default value is false.
  }))
  default     = []
  description = "Enterprise package configuration."
  validation {
    condition     = length(var.enterprise_package_config) <= 1
    error_message = "Only one enterprise package configuration is allowed."
  }
}

variable "standard_package_config" {
  type = list(object({
    region                 = string # The region where the high-defense package was purchased.
    protect_ip_count       = number # Number of protected IPs.
    bandwidth              = number # Protected service bandwidth 50Mbps.
    elastic_bandwidth_flag = optional(bool, false) # Whether to enable elastic service bandwidth. The default value is false.
  }))
  default     = []
  description = "Standard package configuration."
  validation {
    condition     = length(var.standard_package_config) <= 1
    error_message = "Only one standard package configuration is allowed."
  }
}

variable "standard_plus_package_config" {
  type = list(object({
    region                 = string # The region where the high-defense package was purchased.
    protect_count          = string # Protection Count: TWO_TIMES: Two full-power protections; UNLIMITED: Infinite protections.
    protect_ip_count       = number # Number of protected IPs.
    bandwidth              = number # 50Mbps protected bandwidth.
    elastic_bandwidth_flag = optional(bool, false) # Whether to enable elastic service bandwidth. The default value is false.
  }))
  default     = []
  description = "Standard Plus package configuration."
  validation {
    condition     = length(var.standard_plus_package_config) <= 1
    error_message = "Only one standard plus package configuration is allowed."
  }
}

variable "tag_info_list" {
  type = list(object({
    key   = string # Tag key.
    value = string # Tag value.
  }))
  default     = []
  description = "Tag information list."
}