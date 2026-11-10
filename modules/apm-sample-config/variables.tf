################################################################################
# APM Sampling Rule Variables
################################################################################
variable "instance_id" {
  description = "Business system ID."
  type        = string
}

variable "sample_rate" {
  description = "Sampling rate."
  type        = number
}

variable "service_name" {
  description = "Application name."
  type        = string
}

variable "sample_name" {
  description = "Sampling rule name."
  type        = string
}

variable "tags" {
  description = "Sampling tags."
  type = list(object({
    key   = string  # Key value definition.
    value = string  # Value definition.
  }))
  default = []
}

variable "operation_name" {
  description = "API name."
  type        = string
  default     = null
}

variable "operation_type" {
  description = "0: exact match (default); 1: prefix match; 2: suffix match."
  type        = number
  default     = 0
}