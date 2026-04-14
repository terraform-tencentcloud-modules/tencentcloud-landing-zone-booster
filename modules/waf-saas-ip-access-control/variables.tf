# Required parameters
variable "action_type" {
  description = "(Required, Int, ForceNew) 42: blocklist; 40: allowlist."
  type        = number
  validation {
    condition     = contains([40, 42], var.action_type)
    error_message = "action_type must be 40 (allowlist) or 42 (blocklist)."
  }
}

variable "domain" {
  description = "(Required, String, ForceNew) Specific domain name, for example, test.qcloudwaf.com. Global domain name, that is, global."
  type        = string
}

variable "instance_id" {
  description = "(Required, String, ForceNew) Instance ID."
  type        = string
}

variable "ip_list" {
  description = "(Required, Set: [String]) IP parameter list."
  type        = set(string)
}

# Optional parameters
variable "job_type" {
  description = "(Optional, String) Scheduled configuration type."
  type        = string
  default     = null
}

variable "note" {
  description = "(Optional, String) Remarks."
  type        = string
  default     = null
}

# Scheduled configuration object
variable "job_date_time" {
  description = "(Optional, List) Details of scheduled configuration."
  type = list(object({
    time_t_zone = optional(string)
    
    cron = optional(list(object({
      days      = optional(set(number))
      end_time  = optional(string)
      start_time = optional(string)
      w_days    = optional(set(number))
    })))
    
    timed = optional(list(object({
      end_date_time   = optional(number)
      start_date_time = optional(number)
    })))
  }))
  default = []
}