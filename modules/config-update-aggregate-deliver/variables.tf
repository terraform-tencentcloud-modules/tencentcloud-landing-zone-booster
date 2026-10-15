variable "status" {
  description = "Delivery switch. Valid values: false (0 - disabled), true (1 - enabled)."
  type        = bool
}

variable "account_group_id" {
  description = "Account group ID. Identifies the resource (the resource id IS the account group id). ForceNew."
  type        = string
}

variable "deliver_name" {
  description = "Delivery service name (optional)."
  type        = string
  default     = null
}

variable "target_arn" {
  description = "Resource ARN. COS format: qcs::cos:$region:$account:prefix/$appid/$BucketName. CLS format: qcs::cls:$region:$account:cls/topicId. (optional)"
  type        = string
  default     = null
}

variable "deliver_prefix" {
  description = "Log prefix for stored delivery content (optional)."
  type        = string
  default     = null
}

variable "deliver_type" {
  description = "Delivery type. Valid values: COS, CLS. Defaults to COS on the cloud side when omitted."
  type        = string
  default     = null

  validation {
    condition     = var.deliver_type == null || contains(["COS", "CLS"], var.deliver_type)
    error_message = "deliver_type must be COS or CLS."
  }
}

variable "deliver_uin" {
  description = "Member account uin that supports cross-account delivery. Only the delegated administrator can be used. Default 0 means delivery to the administrator account (optional)."
  type        = number
  default     = null
}

variable "deliver_content_type" {
  description = "Delivery content type. Valid values: 1 (configuration change), 2 (resource list), 3 (all). Defaults to 1 on the cloud side when omitted."
  type        = number
  default     = null

  validation {
    condition     = var.deliver_content_type == null || contains([1, 2, 3], var.deliver_content_type)
    error_message = "deliver_content_type must be 1 (configuration change), 2 (resource list) or 3 (all)."
  }
}
