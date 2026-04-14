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
    eips     = set(string)
    vpc_list = set(string)
  }))
  default = []
}

variable "switches" {
  description = "(Required, List) Switch list"
  type        = list(object({
    enable    = number # Switch, 0: off, 1: on.
    subnet_id = string # Subnet id. 
  }))
}

variable "inbound_policies" {
  description = "List of VPC firewall inbound policies"
  type = list(object({
    port           = string # The port for the access control policy. Value: -1/-1: All ports 80: Port 80.
    protocol       = string # Protocol. If Direction=1, optional values: TCP, UDP, ANY; If Direction=0, optional values: TCP, UDP, ICMP, ANY, HTTP, HTTPS, HTTP/HTTPS, SMTP, SMTPS, SMTP/SMTPS, FTP, and DNS.
    rule_action    = string # How the traffic set in the access control policy passes through the cloud firewall. Values: accept, drop, log.
    source_content = string # Access source example: net:IP/CIDR(192.168.0.2).
    source_type    = string # Access source type: for inbound rules, the type can be net, location, vendor, template; for outbound rules, it can be net, instance, tag, template, group.
    target_content = string # Example of access purpose: net: IP/CIDR(192.168.0.2) domain: domain name rules, such as *.qq.com.
    target_type    = string # Access purpose type: For inbound rules, the type can be net, instance, tag, template, group; for outbound rules, it can be net, location, vendor, template.
    enable            = optional(string, "true") # Rule status, true means enabled, false means disabled. Default is true.
    scope             = optional(string, "ALL")  #  Scope of effective rules. ALL: Global effectiveness; ap-guangzhou: Effective territory; cfwnat-xxx: Effectiveness based on instance dimension.
    description       = optional(string, "")     # Description.
    param_template_id = optional(string)         # Parameter template id. Note: This field may return null, indicating that no valid value can be obtained.
  }))
}

variable "outbound_policies" {
  description = "List of VPC firewall outbound policies"
  type = list(object({
    port           = string # The port for the access control policy. Value: -1/-1: All ports 80: Port 80.
    protocol       = string # Protocol. If Direction=1, optional values: TCP, UDP, ANY; If Direction=0, optional values: TCP, UDP, ICMP, ANY, HTTP, HTTPS, HTTP/HTTPS, SMTP, SMTPS, SMTP/SMTPS, FTP, and DNS.
    rule_action    = string # How the traffic set in the access control policy passes through the cloud firewall. Values: accept, drop, log.
    source_content = string # Access source example: net:IP/CIDR(192.168.0.2).
    source_type    = string # Access source type: for inbound rules, the type can be net, location, vendor, template; for outbound rules, it can be net, instance, tag, template, group.
    target_content = string # Example of access purpose: net: IP/CIDR(192.168.0.2) domain: domain name rules, such as *.qq.com.
    target_type    = string # Access purpose type: For inbound rules, the type can be net, instance, tag, template, group; for outbound rules, it can be net, location, vendor, template.
    enable            = optional(string, "true") # Rule status, true means enabled, false means disabled. Default is true.
    scope             = optional(string, "ALL")  # Scope of effective rules. ALL: Global effectiveness; ap-guangzhou: Effective territory; cfwnat-xxx: Effectiveness based on instance dimension.
    description       = optional(string, "")     # Description.
    param_template_id = optional(string)         # Parameter template id. Note: This field may return null, indicating that no valid value can be obtained.
  }))
}