# 必需参数
variable "enable" {
  description = "(Required, Int) Switch, 0: off, 1: on."
  type        = number
  validation {
    condition     = contains([0, 1], var.enable)
    error_message = "enable must be 0 or 1."
  }
}

variable "nat_ins_id" {
  description = "(Required, String, ForceNew) Firewall instance id."
  type        = string
}

variable "subnet_id" {
  description = "(Required, String, ForceNew) subnet id."
  type        = string
}