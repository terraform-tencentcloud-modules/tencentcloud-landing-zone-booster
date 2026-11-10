variable "instance_charge_type" {
  type        = string
  description = "Payment Type: Payment Mode: PREPAID (Prepaid) / POSTPAID_BY_MONTH (Postpaid)."
  validation {
    condition     = contains(["PREPAID", "POSTPAID_BY_MONTH"], var.instance_charge_type)
    error_message = "Instance charge type must be either PREPAID or POSTPAID_BY_MONTH."
  }
}

# POSTPAID_BY_MONTH
variable "instance_charge_prepaid_period" {
  description = "Purchase period in months."
  type        = number
  default     = null
}

variable "instance_charge_prepaid_renew_flag" {
  description = "OTIFY_AND_MANUAL_RENEW: Notify the user of the expiration date and do not automatically renew. NOTIFY_AND_AUTO_RENEW: Notify the user of the expiration date and automatically renew. DISABLE_NOTIFY_AND_MANUAL_RENEW: Do not notify the user of the expiration date and do not automatically renew. The default is: Notify the user of the expiration date and do not automatically renew."
  type        = string
  default     = "OTIFY_AND_MANUAL_RENEW"
}

variable "package_type" {
  type        = string
  description = "High-defense package types: Enterprise, Standard, StandardPlus (Standard Edition 2.0)."
  validation {
    condition     = contains(["Enterprise", "Standard", "StandardPlus"], var.package_type)
    error_message = "Package type must be either Enterprise, Standard, or StandardPlus."
  }
}

# Standard
variable "standard_region" {
  description = "The region where the high-defense package was purchased."
  type        = string
  default     = null
}

variable "standard_protect_ip_count" {
  description = "Number of protected IPs, such as 1, 10, 50, 100"
  type        = number
  default     = null
}

variable "standard_bandwidth" {
  description = "Protected service bandwidth 50Mbps."
  type        = number
  default     = null
}

variable "standard_elastic_bandwidth_flag" {
  description = "Whether to enable elastic service bandwidth. The default value is false."
  type        = bool
  default     = false
}

# StandardPlus
variable "standard_plus_region" {
  description = "The region where the high-defense package was purchased."
  type        = string
  default     = null
}

variable "standard_plus_protect_count" {
  description = "Protection Count: TWO_TIMES: Two full-power protections; UNLIMITED: Infinite protections."
  type        = string
  default     = null
}

variable "standard_plus_protect_ip_count" {
  description = "Number of protected IPs, such as 1, 10, 50, 100"
  type        = number
  default     = null
}

variable "standard_plus_bandwidth" {
  description = "Protected service bandwidth 50Mbps."
  type        = number
  default     = null
}

variable "standard_plus_elastic_bandwidth_flag" {
  description = "Whether to enable elastic service bandwidth. The default value is false."
  type        = bool
  default     = false
}

# Enterprise
variable "enterprise_region" {
  description = "The region where the high-defense package was purchased."
  type        = string
  default     = null
}

variable "enterprise_protect_ip_count" {
  description = "Number of protected IPs, such as 1, 10, 50, 100"
  type        = number
  default     = null
}

variable "enterprise_basic_protect_bandwidth" {
  description = "Guaranteed protection bandwidth."
  type        = number
  default     = null
}

variable "enterprise_bandwidth" {
  description = "Service bandwidth scale."
  type        = number
  default     = null
}

variable "enterprise_elastic_protect_bandwidth" {
  description = "Elastic bandwidth (Gbps), selectable elastic bandwidth [0, 400, 500, 600, 800, 1000], default is 0."
  type        = number
  default     = 0
}

variable "enterprise_elastic_bandwidth_flag" {
  description = "Whether to enable elastic service bandwidth. The default value is false."
  type        = bool
  default     = false
}

variable "tag_info_list" {
  type = list(object({
    key   = string # Tag key.
    value = string # Tag value.
  }))
  default     = []
  description = "Tag information list."
}