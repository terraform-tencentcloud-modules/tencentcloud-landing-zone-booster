variable "attack_log_post" {
  description = "(Required, Int) Attack log delivery switch. 0- Disable, 1- Enable."
  type        = number
  validation {
    condition     = contains([0, 1], var.attack_log_post)
    error_message = "attack_log_post must be 0 or 1."
  }
  default = 0
}

variable "instance_id" {
  description = "(Required, String, ForceNew) Waf instance ID."
  type        = string
}