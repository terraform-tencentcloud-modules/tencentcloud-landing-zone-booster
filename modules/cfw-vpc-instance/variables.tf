# 必需参数
variable "mode" {
  description = "(Required, Int) Mode 0: private network mode; 1: CCN cloud networking mode."
  type        = number
  validation {
    condition     = contains([0, 1], var.mode)
    error_message = "mode must be 0 or 1."
  }
}

variable "name" {
  description = "(Required, String) VPC firewall (group) name."
  type        = string
}

variable "switch_mode" {
  description = "(Required, Int) Switch mode of firewall instance. 1: Single point intercommunication; 2: Multi-point communication; 4: Custom Routing."
  type        = number
  validation {
    condition     = contains([1, 2, 4], var.switch_mode)
    error_message = "switch_mode must be 1, 2, or 4."
  }
}

variable "vpc_fw_instances" {
  description = "(Required, List) List of firewall instances under firewall (group)."
  type = list(object({
    name = string
    fw_deploy = list(object({
      deploy_region  = string
      width          = number
      zone_set       = set(string)
      cross_a_zone   = optional(number)
    }))
    vpc_ids = optional(set(string))
  }))
}

# 可选参数
variable "ccn_id" {
  description = "(Optional, String) Cloud networking id, suitable for cloud networking mode."
  type        = string
  default     = null
}

variable "fw_vpc_cidr" {
  description = "(Optional, String) auto Automatically select the firewall network segment; 10.10.10.0/24 The firewall network segment entered by the user."
  type        = string
  default     = "auto"
}