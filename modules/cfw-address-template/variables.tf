# 必需参数
variable "type" {
  description = "1: ip template; 5: domain name templates."
  type        = number
  validation {
    condition     = contains([1, 5], var.type)
    error_message = "type must be 1 or 5."
  }
}

variable "name" {
  description = "Template name."
  type        = string
}

variable "detail" {
  description = "Template Detail."
  type        = string
}

variable "ip_string" {
  description = "Type is 1, ip template eg: 1.1.1.1,2.2.2.2; Type is 5, domain name template eg: www.qq.com, www.tencent.com."
  type        = string
}