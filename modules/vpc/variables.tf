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
  description = "The DNS server list of the VPC. And you can specify 0 to 5 servers to this list."
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