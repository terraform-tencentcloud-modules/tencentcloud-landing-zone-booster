################################################################################
# Waf cc vars
################################################################################

variable "domain" {
  description = "Domain."
  type        = string
}

variable "name" {
  description = "Rule Name."
  type        = string
}

variable "status" {
  description = "Rule Status, 0 rule close, 1 rule open."
  type        = number
}

variable "advance" {
  description = "Session match mode, 0 use session, 1 use ip."
  type        = string
}

variable "limit" {
  description = "CC detection threshold."
  type        = string
}

variable "interval" {
  description = "Interval."
  type        = string
}

variable "url" {
  description = "Check URL."
  type        = string
}

variable "match_func" {
  description = "Match method, 0 equal, 1 contains, 2 prefix."
  type        = number
}

variable "action_type" {
  description = "Rule Action, 20 log, 21 captcha, 22 deny, 23 accurate deny."
  type        = string
}

variable "priority" {
  description = "Rule Priority."
  type        = number
}

variable "valid_time" {
  description = "Action ValidTime, minute unit. Min: 60, Max: 604800."
  type        = number
}

variable "edition" {
  description = "WAF edition. clb-waf means clb-waf, sparta-waf means saas-waf."
  type        = string
}

variable "type" {
  description = "Operate Type."
  type        = number
}

variable "event_id" {
  description = "Event ID."
  type        = number
  default     = 0
}

variable "session_applied" {
  description = "Advance mode use session id."
  type        = set(number)
  default     = []
}
