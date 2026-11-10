variable "fw_group_id" {
  description = "(Optional, String) Firewall instance ID where the rule takes effect. Default is ALL."
  type        = string
  default     = "ALL"
}

variable "policies" {
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
      for policy in var.policies : contains(["net", "template"], policy.source_type)
    ])
    error_message = "All source_type values must be 'net' or 'template'."
  }
  
  validation {
    condition = alltrue([
      for policy in var.policies : contains(["net", "template", "domain"], policy.dest_type)
    ])
    error_message = "All dest_type values must be 'net', 'template', or 'domain'."
  }
  
  validation {
    condition = alltrue([
      for policy in var.policies : contains(["TCP", "UDP", "ICMP", "ANY", "HTTP", "HTTPS", "HTTP/HTTPS", "SMTP", "SMTPS", "SMTP/SMTPS", "FTP", "DNS", "TLS/SSL"], policy.protocol)
    ])
    error_message = "All protocol values must be valid protocol types."
  }
  
  validation {
    condition = alltrue([
      for policy in var.policies : contains(["accept", "drop", "log"], policy.rule_action)
    ])
    error_message = "All rule_action values must be 'accept', 'drop', or 'log'."
  }
}
