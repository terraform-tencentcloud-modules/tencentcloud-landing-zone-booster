# 必需参数
variable "brokers" {
  description = "(Required, String) The supporting environment is IP:PORT, The external network environment is domain:PORT."
  type        = string
}

variable "ckafka_id" {
  description = "(Required, String) CKafka ID."
  type        = string
}

variable "ckafka_region" {
  description = "(Required, String) The region where CKafka is located for delivery."
  type        = string
}

variable "compression" {
  description = "(Required, String) Default to none, supports snappy, gzip, and lz4 compression, recommended snappy."
  type        = string
  validation {
    condition     = contains(["none", "snappy", "gzip", "lz4"], var.compression)
    error_message = "compression must be one of: none, snappy, gzip, lz4."
  }
}

variable "kafka_version" {
  description = "(Required, String) Version number of Kafka cluster."
  type        = string
}

variable "log_type" {
  description = "(Required, Int) 1- Access log, 2- Attack log, the default is access log."
  type        = number
  validation {
    condition     = contains([1, 2], var.log_type)
    error_message = "log_type must be 1 or 2."
  }
}

variable "topic" {
  description = "(Required, String) Theme name, default not to pass or pass empty string, default value is waf_post_access_log."
  type        = string
  default     = "waf_post_access_log"
}

variable "vip_type" {
  description = "(Required, Int) 1. External network TGW, 2. Supporting environment, default is supporting environment."
  type        = number
  default     = 2
  validation {
    condition     = contains([1, 2], var.vip_type)
    error_message = "vip_type must be 1 or 2."
  }
}

# 可选参数
variable "sasl_enable" {
  description = "(Optional, Int) Whether to enable SASL verification, default not enabled, 0-off, 1-on."
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1], var.sasl_enable)
    error_message = "sasl_enable must be 0 or 1."
  }
}

variable "sasl_password" {
  description = "(Optional, String) SASL password."
  type        = string
  default     = null
  sensitive   = true
}

variable "sasl_user" {
  description = "(Optional, String) SASL username."
  type        = string
  default     = null
}

# write_config 对象参数
variable "write_config" {
  description = "(Optional, List) Enable access to certain fields of the log and check if they have been delivered."
  type = list(object({
    enable_body    = optional(number, 0)
    enable_bot     = optional(number, 0)
    enable_headers = optional(number, 0)
  }))
  default = []
}