# 必需参数
variable "mode" {
  description = "(Required, Int) Mode 1: access mode; 0: new mode."
  type        = number
  validation {
    condition     = contains([0, 1], var.mode)
    error_message = "mode must be 0 or 1."
  }
}

variable "name" {
  description = "(Required, String) Firewall instance name."
  type        = string
}

variable "width" {
  description = "(Required, Int) Bandwidth."
  type        = number
}

variable "zone_set" {
  description = "(Required, Set: [String]) Zone list."
  type        = set(string)
}

# 可选参数
variable "cross_a_zone" {
  description = "(Optional, Int) Off-site disaster recovery 1: use off-site disaster recovery; 0: do not use off-site disaster recovery; if empty, the default is not to use off-site disaster recovery."
  type        = number
  default     = 0
  validation {
    condition     = var.cross_a_zone == null || contains([0, 1], var.cross_a_zone)
    error_message = "cross_a_zone must be 0 or 1."
  }
}

variable "nat_gw_list" {
  description = "(Optional, Set: [String]) A list of nat gateways connected to the access mode, at least one of NewModeItems and NatgwList is passed."
  type        = set(string)
  default     = []
}

variable "new_mode_items" {
  description = "(Optional, List) New mode passing parameters are added, at least one of new_mode_items and nat_gw_list is passed."
  type = list(object({
    eips    = set(string)
    vpc_list = set(string)
  }))
  default = []
}