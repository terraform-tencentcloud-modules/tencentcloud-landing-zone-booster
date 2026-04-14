# 必需参数
variable "enable" {
  description = "(Required, Int) Turn the switch on or off. 0: turn off the switch; 1: Turn on the switch."
  type        = number
  validation {
    condition     = contains([0, 1], var.enable)
    error_message = "enable must be 0 or 1."
  }
}

variable "switch_id" {
  description = "(Required, String, ForceNew) Firewall switch ID."
  type        = string
}

variable "vpc_ins_id" {
  description = "(Required, String, ForceNew) Firewall instance id."
  type        = string
}