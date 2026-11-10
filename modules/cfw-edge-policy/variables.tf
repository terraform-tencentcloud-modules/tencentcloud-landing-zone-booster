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