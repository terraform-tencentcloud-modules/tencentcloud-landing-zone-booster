################################################################################
# CSIP Instance Variables
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
    sv_soccloud_pc_ae  = optional(bool, false) # Advanced Edition
    sv_soccloud_pc_ee  = optional(bool, false) # Enterprise Edition
    sv_soccloud_pc_fe  = optional(bool, false) # Flagship Edition/Ultimate
    sv_soccloud_pc_la  = optional(bool, false) # Log Analytical
    sv_soccloud_pc_ma  = optional(bool, false) # Organization Account Limit
    sv_soccloud_pc_mas = optional(bool, false) # Organization Account Unlimited
    sv_soccloud_pc_ss  = optional(bool, false) # Asset Scan
    autoRenewFlag      = optional(number, 0)
    goodsNum           = optional(number, 1)
    tag                = optional(list(string), [])
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