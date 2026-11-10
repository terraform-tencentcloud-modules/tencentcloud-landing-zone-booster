variable "vpc_id" {
  description = "VPC ID to be used on Network ACL"
  type        = string
  default     = null
}

variable "vpc_name" {
  description = "VPC Name to be used on Network ACL"
  type        = string
  default     = null
}

variable "network_acl_name" {
  description = "Name to be used on Network ACL"
  type        = string
}

variable "network_acl_ingress" {
  description = "Ingress rules. A rule must match the following format: [action]#[cidr_ip]#[port]#[protocol]#[description]. The available value of `action` is `ACCEPT` and `DROP`. The `cidr_ip` must be an IP address network or segment. The `port` valid format is `80`, `80-90` or `ALL`. The available value of 'protocol' is `TCP`, `UDP`, `ICMP` and `ALL`. When `protocol` is `ICMP` or `ALL`, the 'port' must be `ALL`. The `description` content must be in uppercase."
  type        = list(string)
  default     = []
}

variable "network_acl_egress" {
  description = "Egress rules. A rule must match the following format: [action]#[cidr_ip]#[port]#[protocol]#[description]. The available value of `action` is `ACCEPT` and `DROP`. The `cidr_ip` must be an IP address network or segment. The `port` valid format is `80`, `80-90` or `ALL`. The available value of `protocol` is `TCP`, `UDP`, `ICMP` and `ALL`. When `protocol` is `ICMP` or `ALL`, the `port` must be `ALL`. The `description` content must be in uppercase."
  type        = list(string)
  default     = []
}

variable "network_acl_tags" {
  description = "Additional tags for the Network ACL"
  type        = map(string)
  default     = null
}