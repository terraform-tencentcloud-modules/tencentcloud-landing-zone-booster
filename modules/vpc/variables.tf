################################################################################
# vars: common
################################################################################
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

################################################################################
# vars: VPC
################################################################################
variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "A network address block which should be a subnet of the three internal network segments (10.0.0.0/16, 172.16.0.0/12 and 192.168.0.0/16)."
  type        = string
  default     = null
}

variable "vpc_is_multicast" {
  description = "Indicates whether VPC multicast is enabled. The default value is false. Multicast are whitelist-restricted. We recommend disabling these features if they are not applicable to your environment."
  type        = bool
  default     = true
}

variable "vpc_dns_servers" {
  description = "The DNS server list of the VPC. And you can specify 0 to 5 servers to this list."
  type        = list(string)
  default     = []
}

variable "vpc_tags" {
  description = "Tags of the VPC."
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
  description = "Tags for the subnet."
  type        = map(string)
  default     = {}
}