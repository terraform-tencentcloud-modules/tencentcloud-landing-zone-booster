# 可选参数
variable "cls_region" {
  description = "(Optional, String) The region where the CLS is delivered. The default value is ap-shanghai."
  type        = string
  default     = "ap-shanghai"
}

variable "log_topic_name" {
  description = "(Optional, String) The name of the log subject where the submitted CLS is located. The default value is waf_post_logtopic."
  type        = string
  default     = "waf_post_logtopic"
}

variable "log_type" {
  description = "(Optional, Int) 1- Access log, 2- Attack log, the default is access log."
  type        = number
  default     = 1
  validation {
    condition     = contains([1, 2], var.log_type)
    error_message = "log_type must be 1 or 2."
  }
}

variable "logset_name" {
  description = "(Optional, String) The name of the log set where the delivered CLS is located. The default value is waf_post_logset."
  type        = string
  default     = "waf_post_logset"
}