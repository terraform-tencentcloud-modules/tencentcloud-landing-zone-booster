variable "ccn_id" {
  description = "(Optional, String) Cloud networking id, suitable for cloud networking mode."
  type        = string
  default     = null
}

variable "ccn_name" {
  description = "(Optional, String) Cloud networking name, suitable for cloud networking mode."
  type        = string
  default     = null
}

variable "name" {
  description = "(Required, String) VPC firewall (group) name."
  type        = string
}

variable "mode" {
  description = "(Required, Int) Mode 0: private network mode; 1: CCN cloud networking mode."
  type        = number
  validation {
    condition     = contains([0, 1], var.mode)
    error_message = "mode must be 0 or 1."
  }
}

variable "switch_mode" {
  description = "(Required, Int) Switch mode of firewall instance. 1: Single point intercommunication; 2: Multi-point communication; 4: Custom Routing."
  type        = number
  validation {
    condition     = contains([1, 2, 4], var.switch_mode)
    error_message = "switch_mode must be 1, 2, or 4."
  }
}

variable "fw_vpc_cidr" {
  description = "(Optional, String) auto Automatically select the firewall network segment; 10.10.10.0/24 The firewall network segment entered by the user."
  type        = string
  default     = "auto"
}

variable "fw_instances" {
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

variable "vpc_fw_group_id" {
  description = "(Optional, String) Firewall instance ID where the rule takes effect. Default is ALL."
  type        = string
  default     = null
}

variable "vpc_fw_policies" {
  description = "List of VPC firewall policies"
  type = list(object({
    description    = string
    source_type    = string
    source_content = string
    dest_type      = string
    dest_content   = string
    protocol       = string
    port           = string
    rule_action    = string
    enable         = optional(string, "true")
  }))
  
  validation {
    condition = alltrue([
      for policy in var.vpc_fw_policies : contains(["net", "template"], policy.source_type)
    ])
    error_message = "All source_type values must be 'net' or 'template'."
  }
  
  validation {
    condition = alltrue([
      for policy in var.vpc_fw_policies : contains(["net", "template", "domain"], policy.dest_type)
    ])
    error_message = "All dest_type values must be 'net', 'template', or 'domain'."
  }
  
  validation {
    condition = alltrue([
      for policy in var.vpc_fw_policies : contains(["TCP", "UDP", "ICMP", "ANY", "HTTP", "HTTPS", "HTTP/HTTPS", "SMTP", "SMTPS", "SMTP/SMTPS", "FTP", "DNS", "TLS/SSL"], policy.protocol)
    ])
    error_message = "All protocol values must be valid protocol types."
  }
  
  validation {
    condition = alltrue([
      for policy in var.vpc_fw_policies : contains(["accept", "drop", "log"], policy.rule_action)
    ])
    error_message = "All rule_action values must be 'accept', 'drop', or 'log'."
  }
}