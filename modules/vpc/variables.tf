################################################################################
# data: tencentcloud_availability_zones
################################################################################
variable "vpc_region" {
  description = "The region of vpc."
  type        = string
}

################################################################################
# vars: common
################################################################################
variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The vpc id used to launch resources."
  type        = string
  default     = ""
}

variable "default_subnet_name" {
  description = "Specify the default subnet name when 'vpc_id' is not specified."
  type        = string
  default     = "default_subnet"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
  description = "List of available zones to launch resources."
  type        = list(string)
  default     = []
}

################################################################################
# vars: VPC
################################################################################
variable "vpc_name" {
  description = "The vpc name used to launch a new vpc when 'vpc_id' is not specified."
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  type        = string
  default     = null
}

variable "vpc_is_multicast" {
  description = "Specify the vpc is multicast when 'vpc_id' is not specified."
  type        = bool
  default     = true
}

variable "vpc_dns_servers" {
  description = "Specify the vpc dns servers when 'vpc_id' is not specified."
  type        = list(string)
  default     = []
}

variable "vpc_tags" {
  description = "Additional tags for the vpc."
  type        = map(string)
  default     = {}
}

################################################################################
# vars: Subnet
################################################################################
variable "subnet_cidrs" {
  description = "Specify the subnet cidr blocks when 'vpc_id' is not specified."
  type = list(object({
    subnet_name         = string # subnet name, limit 60
    subnet_cidr         = string # subnet cidr
    subnet_is_multicast = optional(bool, true) # Specify the subnet is multicast when 'vpc_id' is not specified.
    availability_zone   = optional(string)     # availability zone, If not settings, will setting with random from all.
  }))
  default = []
}

variable "subnet_tags" {
  description = "Additional tags for the subnet."
  type        = map(string)
  default     = {}
}

################################################################################
# vars: Route table
################################################################################
variable "create_route_table" {
  description = "Controls if separate route table for subnets should be created"
  type        = bool
  default     = false
}

variable "route_table_name" {
  description = "The route table ame of router table in the specified vpc."
  type        = string
  default     = ""
}

variable "route_table_id" {
  description = "The route table id of router table in the specified vpc."
  type        = string
  default     = ""
}

variable "destination_cidrs" {
  description = "List of destination CIDR blocks of router table in the specified VPC."
  type        = list(string)
  default     = []
}

variable "next_type" {
  description = "List of next hop types of router table in the specified vpc."
  type        = list(string)
  default     = []
}

variable "next_hub" {
  description = "List of next hop gateway id of router table in the specified vpc."
  type        = list(string)
  default     = []
}

variable "route_table_tags" {
  description = "Additional tags for the route table."
  type        = map(string)
  default     = {}
}

################################################################################
# vars: VPN Gateway
################################################################################
variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}

variable "vpn_gateway_name" {
  description = "Name of VPN gateway."
  type        = string
  default     = ""
}

variable "vpn_gateway_type" {
  description = "Type of VPN gateway. Valid value: IPSEC, SSL and CCN."
  type        = string
  default     = "IPSEC"
}

variable "vpn_gateway_bandwidth" {
  description = "bandwidth of VPN Gateway"
  type        = number
  default     = 5
}

variable "vpn_gateway_max_connection" {
  description = " Maximum number of connected clients allowed for the SSL VPN gateway. Valid values: [5, 10, 20, 50, 100]. This parameter is only required for SSL VPN gateways."
  type        = number
  default     = 5
}

variable "vpn_gateway_availability_zone" {
  description = "The Availability Zone for the VPN Gateway"
  type        = string
  default     = ""
}

variable "vpn_gateway_tags" {
  description = "Additional tags for the VPN gateway"
  type        = map(string)
  default     = {}
}

################################################################################
# vars: Network ACL
################################################################################
variable "manage_network_acl" {
  description = "Should be true to adopt and manage Network ACL for subnets"
  type        = bool
  default     = false
}

variable "network_acl_name" {
  description = "Name to be used on Network ACL"
  type        = string
  default     = ""
}

variable "network_acl_ingress" {
  description = "List of strings of ingress rules to set on the Network ACL, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`"
  type        = list(string)

  default = null
}

variable "network_acl_egress" {
  description = "List of strings of egress rules to set on the Network ACL, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`"
  type        = list(string)

  default = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]
}

variable "network_acl_tags" {
  description = "Additional tags for the Network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# vars: NAT Gateway
################################################################################
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for vpc."
  type        = bool
  default     = false
}

variable "nat_eip_name" {
  description = "List of EIPs to be used for `nat_gateway`"
  type        = string
  default     = ""
}

variable "nat_gateway_name" {
  description = "List of EIPs to be used for `nat_gateway`"
  type        = string
  default     = ""
}

variable "nat_gateway_bandwidth" {
  description = "bandwidth of NAT Gateway"
  type        = number
  default     = 100
}

variable "nat_gateway_concurrent" {
  description = "bandwidth of NAT Gateway"
  type        = number
  default     = 1000000
}

variable "nat_public_ips" {
  description = "List of EIPs to be used for `nat_gateway`"
  type        = list(string)
  default     = []
}

variable "nat_gateway_tags" {
  description = "Additional tags for the NAT gateway"
  type        = map(string)
  default     = {}
}

################################################################################
# vars: Attachment VPC to CCN
################################################################################
variable "create_ccn_attachment" {
  description = "Whether to create ccn attachment"
  type        = bool
  default     = false #todo: Compatibility needs
}

variable "ccn_id" {
  description = "ID of the CCN to be queried"
  type        = string
  default     = ""
}

variable "ccn_uin" {
  description = "Uin of the ccn attached. If not set, which means the uin of this account"
  type        = string
  default     = ""
}

variable "ccn_route_table_id" {
  description = "ccn route table id"
  type        = string
  default     = ""
}

variable "description" {
  description = "Remark of attachment"
  type        = string
  default     = ""
}