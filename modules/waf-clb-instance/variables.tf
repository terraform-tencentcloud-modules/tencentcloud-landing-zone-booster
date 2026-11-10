################################################################################
# Waf instance vars
################################################################################

variable "goods_category" {
  description = "Billing order parameters. support: premium_clb, enterprise_clb, ultimate_clb."
  type        = string
  default     = "premium_clb"
}

variable "instance_name" {
  description = "Waf instance name."
  type        = string
  default     = ""
}

variable "time_span" {
  description = "Time interval."
  type        = number
  default     = 1
}

variable "time_unit" {
  description = "Time unit, support d, m, y. d: day, m: month, y: year."
  type        = string
  default     = "m"
}

variable "auto_renew_flag" {
  description = "Auto renew flag, 1: enable, 0: disable."
  type        = number
  default     = 1
}

variable "elastic_mode" {
  description = "Is elastic billing enabled, 1: enable, 0: disable."
  type        = number
  default     = 1
}

variable "qps_limit" {
  description = "QPS Limit, Minimum setting 10000. Only elastic_mode is 1, can be set."
  type        = number
  default     = 200000
}

variable "api_security" {
  description = "Whether to purchase API Security, 1: yes, 0: no. Default is 0."
  type        = number
  default     = 0
}

variable "bot_management" {
  description = "Whether to purchase Bot management, 1: yes, 0: no. Default is 0."
  type        = number
  default     = 0
}