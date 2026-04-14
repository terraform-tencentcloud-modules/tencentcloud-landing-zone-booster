# 必填参数
variable "product_code" {
  description = "产品代码"
  type        = string
}

variable "sub_product_code" {
  description = "子产品代码"
  type        = string
}

variable "region_code" {
  description = "区域代码，如 ap-guangzhou"
  type        = string
}

variable "zone_code" {
  description = "可用区代码，如 ap-guangzhou-3"
  type        = string
}

variable "pay_mode" {
  description = "支付模式，目前仅支持 PrePay（预付费/包年包月）"
  type        = string
  default     = "PrePay"
}

variable "parameter" {
  description = "产品详细信息的 JSON 字符串"
  type        = string
}

# 可选参数
variable "project_id" {
  description = "项目 ID"
  type        = number
  default     = 0
}

variable "period" {
  description = "购买时长，最大 36"
  type        = number
  default     = 1
}

variable "period_unit" {
  description = "购买时长单位：m（月）、y（年）"
  type        = string
  default     = "m"
}

variable "renew_flag" {
  description = "自动续费标识：NOTIFY_AND_MANUAL_RENEW（手动续费）、NOTIFY_AND_AUTO_RENEW（自动续费）、DISABLE_NOTIFY_AND_MANUAL_RENEW（禁止续费）"
  type        = string
  default     = "NOTIFY_AND_MANUAL_RENEW"
}

variable "create_timeout" {
  description = "创建超时时间"
  type        = string
  default     = "20m"
}
