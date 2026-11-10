variable "instance_name" {
  description = "Name of the WAF instance"
  type        = string
}

variable "goods_category" {
  description = "(Required, String) Billing order parameters. support premium_saas, enterprise_saas, ultimate_saas."
  type        = string
}

variable "api_security" {
  description = "(Optional, Int) Whether to purchase API Security, 1: yes, 0: no. Default is 0."
  type        = number
  default     = 0
}

variable "auto_renew_flag" {
  description = "(Optional, Int) Auto renew flag, 1: enable, 0: disable."
  type        = number
  default     = 0
}

variable "bot_management" {
  description = "(Optional, Int) Whether to purchase Bot management, 1: yes, 0: no. Default is 0."
  type        = number
  default     = 0
}

variable "elastic_mode" {
  description = "(Optional, Int) Is elastic billing enabled, 1: enable, 0: disable."
  type        = number
  default     = 0
}

variable "qps_limit" {
  description = "QPS Limit, Minimum setting 10000. Only elastic_mode is 1, can be set."
  type        = number
  default     = null
}

variable "real_region" {
  description = "(Optional, String) region. If Region is ap-guangzhou, support: gz, sh, bj, cd (Means: GuangZhou, ShangHai, BeiJing, ChengDu); If Region is ap-seoul, support: hk, sg, th, kr, in, de, ca, use, sao, usw, jkt (Means: HongKong, Singapore, Bandkok, Seoul, Mumbai, Frankfurt, Toronto, Virginia, SaoPaulo, SiliconValley, Jakarta)."
  type        = string
  default     = "sg"
}

variable "time_span" {
  description = "(Optional, Int) Time interval"
  type        = number
  default     = 1
}

variable "time_unit" {
  description = "(Optional, String) Time unit, support d, m, y. d: day, m: month, y: year."
  type        = string
  default     = "m"
}
