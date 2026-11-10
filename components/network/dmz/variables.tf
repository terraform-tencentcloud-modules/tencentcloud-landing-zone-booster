################################################################################
# vpc common config
################################################################################
variable "vpc_region" {
  description = "The region of the vpc"
  type        = string
}

variable "vpc_common_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

################################################################################
# vpc inbound config
################################################################################
variable "vpc_inbound_name" {
  description = "The vpc name used to launch a new vpc when 'vpc_id' is not specified."
  type        = string
  default     = "my-vpc"
}

variable "vpc_inbound_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  type        = string
  default     = "172.16.0.0/16"
}

variable "vpc_inbound_is_multicast" {
  description = "Specify the vpc is multicast when 'vpc_id' is not specified."
  type        = bool
  default     = true
}

variable "vpc_inbound_dns_servers" {
  description = "Specify the vpc dns servers when 'vpc_id' is not specified."
  type        = list(string)
  default     = null
}

variable "vpc_inbound_tags" {
  description = "Additional tags for the vpc."
  type        = map(string)
  default     = {}
}

variable "vpc_inbound_subnet_cidrs" {
  description = "Specify the subnet cidr blocks when 'vpc_id' is not specified."
  type = list(object({
    subnet_name         = string # subnet name, limit 60
    subnet_cidr         = string # subnet cidr
    subnet_is_multicast = optional(bool, true) # Specify the subnet is multicast when 'vpc_id' is not specified.
    availability_zone   = optional(string)     # availability zone, If not settings, will setting with random from all.
  }))
}

variable "vpc_inbound_subnet_tags" {
  description = "Additional tags for the subnet."
  type        = map(string)
  default     = {}
}

################################################################################
# vpc outbound config
################################################################################
variable "vpc_outbound_name" {
  description = "The vpc name used to launch a new vpc when 'vpc_id' is not specified."
  type        = string
  default     = "my-vpc"
}

variable "vpc_outbound_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  type        = string
  default     = "172.16.0.0/16"
}

variable "vpc_outbound_is_multicast" {
  description = "Specify the vpc is multicast when 'vpc_id' is not specified."
  type        = bool
  default     = true
}

variable "vpc_outbound_dns_servers" {
  description = "Specify the vpc dns servers when 'vpc_id' is not specified."
  type        = list(string)
  default     = null
}

variable "vpc_outbound_tags" {
  description = "Additional tags for the vpc."
  type        = map(string)
  default     = {}
}

variable "vpc_outbound_subnet_cidrs" {
  description = "Specify the subnet cidr blocks when 'vpc_id' is not specified."
  type = list(object({
    subnet_name         = string # subnet name, limit 60
    subnet_cidr         = string # subnet cidr
    subnet_is_multicast = optional(bool, true) # Specify the subnet is multicast when 'vpc_id' is not specified.
    availability_zone   = optional(string)     # availability zone, If not settings, will setting with random from all.
  }))
}

variable "vpc_outbound_subnet_tags" {
  description = "Additional tags for the subnet."
  type        = map(string)
  default     = {}
}

################################################################################
# nat gateway config
################################################################################
variable "nat_gateway_name" {
  type        = string
  default     = ""
  description = "nat gateway name"
}

variable "nat_eips" {
  description = "List of EIPs to be used for `nat_gateway`"
  type        = list(string)
  default     = []
}

variable "nat_public_ips" {
  description = "List of EIPs to be used for `nat_gateway`"
  type        = list(string)
  default     = []
}

variable "nat_internet_max_bandwidth_out" {
  description = "max bandwidth of internet"
  type        = number
  default     = 100
}

variable "nat_product_version" {
  type        = number
  default     = 1
  description = "1: traditional NAT, 2: standard NAT, default value is 1."
}

variable "nat_gateway_bandwidth" {
  type        = number
  default     = 100
  description = "bandwidth of NAT Gateway"
}

variable "nat_gateway_concurrent" {
  description = "bandwidth of NAT Gateway"
  type        = number
  default     = 1000000
}

variable "nat_enable_flow_monitor" {
  default = false
  type = bool
  description = "Whether to enable flow monitor"
}

variable "nat_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

################################################################################
# CCN attachment config
################################################################################
variable "ccn_id" {
  description = "The ID of ccn which to attach."
  type        = string
  default     = null
}

variable "ccn_name" {
  description = "The ID of ccn which to attach."
  type        = string
  default     = null
}

variable "attachment_description" {
  description = "Description of the CCN to be created, and maximum length does not exceed 100 bytes."
  type        = string
  default     = ""
}

variable "ccn_uin" {
  description = "Uin of the ccn attached. If not set, which means the uin of this account. This parameter is used with case when attaching ccn of other account to the instance of this account. For now only support instance type `VPC`."
  type        = string
  default     = null
}