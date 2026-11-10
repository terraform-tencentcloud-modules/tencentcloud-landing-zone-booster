variable "project_id" {
  description = "Project ID of the security group."
  type        = number
  default     = null
}

variable "name" {
  description = "Name of the security group to be queried."
  type        = string
}

variable "description" {
  description = "Description of the security group."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags of the security group."
  type        = map(string)
  default     = null
}

# 入站规则变量
variable "ingress_rules" {
  description = "List of ingress rule. NOTE: this block is ordered, the first rule has the highest priority."
  type = list(object({
    action                 = string           # Rule policy of security group. Valid values: `ACCEPT` and `DROP`.
    cidr_block             = optional(string) # An IP address network or CIDR segment. NOTE: `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` are exclusive and cannot be set in the same time; One of `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` must be set.
    ipv6_cidr_block        = optional(string) # An IPV6 address network or CIDR segment, and conflict with `source_security_id` and `address_template_*`. NOTE: One of `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` must be set.
    protocol               = optional(string) # Type of IP protocol. Valid values: `TCP`, `UDP`, `ICMP`, `ICMPv6` and `ALL`. Default to all types protocol, and conflicts with `service_template_*`.
    port                   = optional(string) # Range of the port. The available value can be `all`, a single port, or a port range. E.g. `80`, `80,90`, `80-90` or `all`. Note: If the `Protocol` value is set to `ALL`, the `Port` value also needs to be set to `all`. Default to all ports, and conflicts with `service_template_*`.
    source_security_id     = optional(string) # ID of the nested security group, and conflicts with `cidr_block` and `address_template_*`. NOTE: One of `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` must be set.
    address_template_id    = optional(string) # Specify Address template ID like `ipm-xxxxxxxx`, conflict with `source_security_id` and `cidr_block`. NOTE: One of `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` must be set.
    address_template_group = optional(string) # Specify Group ID of Address template like `ipmg-xxxxxxxx`, conflict with `source_security_id` and `cidr_block`. NOTE: One of `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` must be set.
    service_template_id    = optional(string) # Specify Protocol template ID like `ppm-xxxxxxxx`, conflict with `protocol` and `port`.
    service_template_group = optional(string) # Specify Group ID of Protocol template ID like `ppmg-xxxxxxxx`, conflict with `protocol` and `port`.
    description            = optional(string) # Description of the security group rule.
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : contains(["ACCEPT", "DROP"], rule.action)
    ])
    error_message = "action must be either 'ACCEPT' or 'DROP'"
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : 
      rule.protocol == null || contains(["TCP", "UDP", "ICMP", "ICMPv6", "ALL"], rule.protocol)
    ])
    error_message = "protocol must be one of: TCP, UDP, ICMP, ICMPv6, ALL"
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : 
      (
        (rule.cidr_block != null ? 1 : 0) +
        (rule.ipv6_cidr_block != null ? 1 : 0) +
        (rule.source_security_id != null ? 1 : 0) +
        (rule.address_template_id != null ? 1 : 0) +
        (rule.address_template_group != null ? 1 : 0)
      ) == 1
    ])
    error_message = "Must specify exactly one source type: cidr_block, ipv6_cidr_block, source_security_id, address_template_id, or address_template_group"
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : 
      (
        (rule.protocol != null && rule.port != null) ||
        (rule.service_template_id != null) ||
        (rule.service_template_group != null)
      )
    ])
    error_message = "Must specify either protocol + port or service_template_*"
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : 
        rule.protocol != "ALL" || (rule.protocol == "ALL" && rule.port == "all")
    ])
    error_message = "When protocol is 'ALL', port must be 'all'"
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : 
      (
        (rule.service_template_id == null && rule.service_template_group == null) ||
        (rule.service_template_id != null && rule.protocol == null && rule.port == null) ||
        (rule.service_template_group != null && rule.protocol == null && rule.port == null)
      )
    ])
    error_message = "When using service_template, cannot set protocol and port"
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : 
        rule.cidr_block == null || can(cidrhost(rule.cidr_block, 0))
    ])
    error_message = "cidr_block must be a valid CIDR notation"
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : 
        rule.ipv6_cidr_block == null || can(cidrhost(rule.ipv6_cidr_block, 0))
    ])
    error_message = "ipv6_cidr_block must be a valid IPv6 CIDR notation"
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : 
        rule.port == null || rule.port == "all" || can(regex("^[0-9]+(-[0-9]+)?(,[0-9]+(-[0-9]+)?)*$", rule.port))
    ])
    error_message = "port must be 'all', a single port, or a port range (e.g., 80, 80-90, 80,90)"
  }
}

# 出站规则变量
variable "egress_rules" {
  description = "List of egress rule. NOTE: this block is ordered, the first rule has the highest priority."
  type = list(object({
    action                 = string           # Rule policy of security group. Valid values: `ACCEPT` and `DROP`.
    cidr_block             = optional(string) # An IP address network or CIDR segment. NOTE: `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` are exclusive and cannot be set in the same time; One of `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` must be set.
    ipv6_cidr_block        = optional(string) # An IPV6 address network or CIDR segment, and conflict with `source_security_id` and `address_template_*`. NOTE: One of `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` must be set.
    protocol               = optional(string) # Type of IP protocol. Valid values: `TCP`, `UDP`, `ICMP`, `ICMPv6` and `ALL`. Default to all types protocol, and conflicts with `service_template_*`.
    port                   = optional(string) # Range of the port. The available value can be `all`, a single port, or a port range. E.g. `80`, `80,90`, `80-90` or `all`. Note: If the `Protocol` value is set to `ALL`, the `Port` value also needs to be set to `all`. Default to all ports, and conflicts with `service_template_*`.
    source_security_id     = optional(string) # ID of the nested security group, and conflicts with `cidr_block` and `address_template_*`. NOTE: One of `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` must be set.
    address_template_id    = optional(string) # Specify Address template ID like `ipm-xxxxxxxx`, conflict with `source_security_id` and `cidr_block`. NOTE: One of `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` must be set.
    address_template_group = optional(string) # Specify Group ID of Address template like `ipmg-xxxxxxxx`, conflict with `source_security_id` and `cidr_block`. NOTE: One of `cidr_block`, `ipv6_cidr_block`, `source_security_id` and `address_template_*` must be set.
    service_template_id    = optional(string) # Specify Protocol template ID like `ppm-xxxxxxxx`, conflict with `protocol` and `port`.
    service_template_group = optional(string) # Specify Group ID of Protocol template ID like `ppmg-xxxxxxxx`, conflict with `protocol` and `port`.
    description            = optional(string) # Description of the security group rule.
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules : contains(["ACCEPT", "DROP"], rule.action)
    ])
    error_message = "action must be either 'ACCEPT' or 'DROP'"
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : 
      rule.protocol == null || contains(["TCP", "UDP", "ICMP", "ICMPv6", "ALL"], rule.protocol)
    ])
    error_message = "protocol must be one of: TCP, UDP, ICMP, ICMPv6, ALL"
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : 
      (
        (rule.cidr_block != null ? 1 : 0) +
        (rule.ipv6_cidr_block != null ? 1 : 0) +
        (rule.source_security_id != null ? 1 : 0) +
        (rule.address_template_id != null ? 1 : 0) +
        (rule.address_template_group != null ? 1 : 0)
      ) == 1
    ])
    error_message = "Must specify exactly one source type: cidr_block, ipv6_cidr_block, source_security_id, address_template_id, or address_template_group"
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : 
      (
        (rule.protocol != null && rule.port != null) ||
        (rule.service_template_id != null) ||
        (rule.service_template_group != null)
      )
    ])
    error_message = "Must specify either protocol + port or service_template_*"
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : 
        rule.protocol != "ALL" || (rule.protocol == "ALL" && rule.port == "all")
    ])
    error_message = "When protocol is 'ALL', port must be 'all'"
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : 
      (
        (rule.service_template_id == null && rule.service_template_group == null) ||
        (rule.service_template_id != null && rule.protocol == null && rule.port == null) ||
        (rule.service_template_group != null && rule.protocol == null && rule.port == null)
      )
    ])
    error_message = "When using service_template, cannot set protocol and port"
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : 
        rule.cidr_block == null || can(cidrhost(rule.cidr_block, 0))
    ])
    error_message = "cidr_block must be a valid CIDR notation"
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : 
        rule.ipv6_cidr_block == null || can(cidrhost(rule.ipv6_cidr_block, 0))
    ])
    error_message = "ipv6_cidr_block must be a valid IPv6 CIDR notation"
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : 
        rule.port == null || rule.port == "all" || can(regex("^[0-9]+(-[0-9]+)?(,[0-9]+(-[0-9]+)?)*$", rule.port))
    ])
    error_message = "port must be 'all', a single port, or a port range (e.g., 80, 80-90, 80,90)"
  }
}