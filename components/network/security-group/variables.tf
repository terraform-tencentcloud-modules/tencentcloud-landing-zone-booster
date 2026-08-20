variable "security_groups" {
  description = "List of security groups to be created."
  type = list(object({
    name        = string                # Name of the security group to be queried.
    project_id  = optional(number)      # Project ID of the security group.
    description = optional(string)      # Description of the security group.
    tags        = optional(map(string)) # Tags of the security group.
    ingress_rules = optional(list(object({ # List of ingress rule. NOTE: this block is ordered, the first rule has the highest priority
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
    })), [])
    egress_rules = optional(list(object({ # List of egress rule. NOTE: this block is ordered, the first rule has the highest priority.
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
    })), [])
  }))
  default = []
}