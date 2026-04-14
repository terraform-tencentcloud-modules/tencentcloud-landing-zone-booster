################################################################################
# CFW Instance Variables
################################################################################
# required
variable "region" {
  description = "Deployment Region"
  type        = string
}

variable "zone" {
  description = "Available Zone"
  type        = string
}

variable "pay_mode" {
  description = "Payment mode, Only support `PrePay`"
  type        = string
  default     = "PrePay"
}

variable "parameter" {
  description = "产品详细信息的 JSON 字符串"
  type = object({
    # Common 
    goodsNum = optional(number, 1)
    # Version
    sv_cloudfirewall_basic_aeps     = optional(bool, false) # advanced edition
    sv_cloudfirewall_basic_eeps     = optional(bool, false) # enterprise edition
    sv_cloudfirewall_basic_ueps     = optional(bool, false) # ultimate edition
    # Log analysis and Log storage
    sv_cloudfirewall_extended_clasps  = optional(bool, false) # Log analysis
    sv_cloudfirewall_extended_clsesps = optional(number, 0)   # Log storage, unit GB, step size of 1000
    # Extended configuration
    sv_cloudfirewall_extended_ibtesps = optional(number, 0) # North-South protection bandwidth, unit Mbps, step size 1
    sv_cloudfirewall_extended_vpcbges = optional(number, 0) # VPC firewall bandwidth, unit Gbps, step size of 1
    sv_cloudfirewall_extended_vpc     = optional(number, 0) # VPC firewall bandwidth, unit Mbps, step size of 1
    sv_cloudfirewall_extended_ndr     = optional(number, 0) # Full traffic detection and response NDR bandwidth, unit Gbps, step size of 1
    sv_cloudfirewall_extended_pcs     = optional(number, 0) # Network Honeypot, step size of 1
    sv_cloudfirewall_extended_sub     = optional(number, 0) # General Instance, step size of 1
    sv_cloudfirewall_extended_subs    = optional(number, 0) # General Rule, step size of 100
    sv_cloudfirewall_extended_ates    = optional(number, 0) # Address Template, step size of 10
    sv_cloudfirewall_extended_spt     = optional(bool, false) # Critical Protection Toolkit
    # unknown
    sv_cloudfirewall_extended_ex   = optional(number, 0)
    sv_cloudfirewall_extended_nats = optional(number, 0)
    sv_cloudfirewall_extended_sra  = optional(number, 0)
    sv_cloudfirewall_extended_srb  = optional(number, 0)
  })
}

# optional
variable "project_id" {
  description = "Project ID"
  type        = number
  default     = 0
}

variable "period" {
  description = "Purchase duration, max number is 36, default value is 1."
  type        = number
  default     = 1
}

variable "period_unit" {
  description = "Purchase duration unit. valid values: m: month, y: year. default value is: m."
  type        = string
  default     = "m"
}

variable "renew_flag" {
  description = "Auto-renewal flag. valid values: NOTIFY_AND_MANUAL_RENEW: manually renew, NOTIFY_AND_AUTO_RENEW: automatically renew, DISABLE_NOTIFY_AND_MANUAL_RENEW: renewal is disabled. default value is NOTIFY_AND_MANUAL_RENEW."
  type        = string
  default     = "NOTIFY_AND_MANUAL_RENEW"
}

variable "create_timeout" {
  description = "Create timeout, default is 20m"
  type        = string
  default     = "20m"
}