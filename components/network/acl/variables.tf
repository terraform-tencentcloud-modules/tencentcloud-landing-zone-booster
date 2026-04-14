variable "network_acls" {
  description = "List of network acl to be created."
  type = list(object({
    acl_name = string                 # Name of the network acl to be queried, must be unique.
    vpc_id   = optional(string, null) # VPC ID to be used on Network ACL
    vpc_name = optional(string, null) # VPC Name to be used on Network ACL
    ingress_rules = optional(list(object({ # Ingress rules. A rule must match the following format: [action]#[cidr_ip]#[port]#[protocol]#[description].
      action   = string # The available value of `action` is `ACCEPT` and `DROP`.
      cidr     = string # The `cidr` must be an IP address network or segment. 
      port     = string # The `port` valid format is `80`, `80-90` or `ALL`. 
      protocol = string # The available value of 'protocol' is `TCP`, `UDP`, `ICMP` and `ALL`. When `protocol` is `ICMP` or `ALL`, the 'port' must be `ALL`.
      desc     = string # The `description` content must be in uppercase.
    })), [])
    egress_rules = optional(list(object({ # Egress rules. A rule must match the following format: [action]#[cidr_ip]#[port]#[protocol]#[description].
      action   = string # The available value of `action` is `ACCEPT` and `DROP`.
      cidr     = string # The `cidr_ip` must be an IP address network or segment. 
      port     = string # The `port` valid format is `80`, `80-90` or `ALL`. 
      protocol = string # The available value of `protocol` is `TCP`, `UDP`, `ICMP` and `ALL`. When `protocol` is `ICMP` or `ALL`, the `port` must be `ALL`. 
      desc     = string # The `description` content must be in uppercase.
    })), [])
    tags = optional(map(string))  # Tags of the network acl.
  }))
  default = []
}