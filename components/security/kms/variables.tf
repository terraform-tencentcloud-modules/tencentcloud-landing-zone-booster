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
  description = "Parameter with product details"
  type = object({
    goodsNum            = optional(number, 1)
    autoRenewFlag       = optional(number, 0)
    sv_kms_pg_pro       = optional(bool, true)
    sv_kms_exp_data_key = optional(number, 1000)
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