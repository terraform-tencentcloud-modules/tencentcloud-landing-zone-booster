variable "status" {
  description = "Delivery switch. 0 (disabled), 1 (enabled). This is an account-level singleton: only ONE delivery config exists per account, so this module manages a single instance (do not declare multiple)."
  type        = bool
  default     = true
}

variable "deliver_name" {
  description = "Delivery service name."
  type        = string
  default     = null
}

variable "target_arn" {
  description = "Resource ARN. COS format: qcs::cos:$region:$account:prefix/$appid/$BucketName. CLS format: qcs::cls:$region:$account:cls/topicId."
  type        = string
  default     = null
}

variable "deliver_prefix" {
  description = "Log prefix for stored delivery content."
  type        = string
  default     = null
}

variable "deliver_type" {
  description = "Delivery type. Valid values: COS, CLS."
  type        = string
  default     = null

  validation {
    condition     = var.deliver_type == null || contains(["COS", "CLS"], var.deliver_type)
    error_message = "deliver_type must be COS or CLS."
  }
}

variable "deliver_content_type" {
  description = "Delivery content type. 1 (configuration change), 2 (resource list), 3 (all)."
  type        = number
  default     = null

  validation {
    condition     = var.deliver_content_type == null || contains([1, 2, 3], var.deliver_content_type)
    error_message = "deliver_content_type must be 1 (configuration change), 2 (resource list) or 3 (all)."
  }
}
