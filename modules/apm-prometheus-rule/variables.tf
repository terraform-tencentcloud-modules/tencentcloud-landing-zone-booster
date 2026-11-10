################################################################################
# APM Metric Match Rule Variables
################################################################################
variable "name" {
  description = "Metric match rule name."
  type        = string
}

variable "service_name" {
  description = "Applications where the rule takes effect. input an empty string for all applications."
  type        = string
}

variable "metric_match_type" {
  description = "Match type: 0 - precision match, 1 - prefix match, 2 - suffix match."
  type        = number
}

variable "metric_name_rule" {
  description = "Specifies the rule for customer-defined metric names with cache hit."
  type        = string
}

variable "instance_id" {
  description = "Business system ID."
  type        = string
}

variable "status" {
  description = "Rule status. 1 - enabled, 2 - disabled. Default value: 1."
  type        = number
  default     = 1
  validation {
    condition     = var.status == null ? true : contains([1, 2], var.status)
    error_message = "Status must be 1 (enabled) or 2 (disabled)."
  }
}