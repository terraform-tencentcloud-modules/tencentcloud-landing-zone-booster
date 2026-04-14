################################################################################
# APM Association Relationship Variables
################################################################################

variable "product_name" {
  description = "Associated product name. currently only supports Prometheus."
  type        = string
}

variable "status" {
  description = "Status of the association relationship: association status: 1 (enabled), 2 (disabled)."
  type        = number
  validation {
    condition     = contains([1, 2], var.status)
    error_message = "Status must be 1 (enabled) or 2 (disabled)."
  }
}

variable "instance_id" {
  description = "Business system ID."
  type        = string
}

variable "peer_id" {
  description = "Associated product instance ID."
  type        = string
  default     = null
}

variable "topic" {
  description = "Specifies the CKafka message topic."
  type        = string
  default     = null
}