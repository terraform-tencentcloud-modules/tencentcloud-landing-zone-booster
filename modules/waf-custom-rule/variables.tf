################################################################################
# Waf clb domain vars
################################################################################

variable "name" {
  description = "Rule Name."
  type        = string
}

variable "sort_id" {
  description = "Priority, value range 0-100."
  type        = string
}

variable "redirect" {
  description = "If the action is a redirect, it represents the redirect address; Other situations can be left blank."
  type        = string
  default     = "/"
}

variable "expire_time" {
  description = "Expiration time, measured in seconds, such as 1677254399."
  type        = string
}

variable "status" {
  description = "The status of the switch, 1 is on, 0 is off, default 1."
  type        = string
  default     = "1"
}

variable "domain" {
  description = "Domain name that needs to add policy."
  type        = string
}

variable "action_type" {
  description = "Action type, 1 represents blocking, 2 represents captcha, 3 represents observation, and 4 represents redirection."
  type        = string
  default     = "1"
}

variable "strategies" {
  description = "Strategies detail."
  type        = list(object({
    field        = string
    compare_func = string
    content      = string
    arg          = string
  }))
  default     = []
}
