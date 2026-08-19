################################################################################
# vpc config
################################################################################
variable "vpc_name" {
  description = "The vpc name used to launch a new vpc when 'vpc_id' is not specified."
  type        = string
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  type        = string
}

variable "vpc_is_multicast" {
  description = "Specify the vpc is multicast when 'vpc_id' is not specified."
  type        = bool
  default     = null
}

variable "vpc_dns_servers" {
  description = "Specify the vpc dns servers when 'vpc_id' is not specified."
  type        = list(string)
  default     = null
}

variable "vpc_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

################################################################################
# vpc subnet config
################################################################################
variable "subnet_cidrs" {
  description = "Specify the subnet cidr blocks when 'vpc_id' is not specified."
  type = list(object({
    subnet_name         = string # subnet name, limit 60
    subnet_cidr         = string # subnet cidr
    availability_zone   = string # availability zone, If not settings, will setting with random from all.
    subnet_is_multicast = optional(bool) # Specify the subnet is multicast when 'vpc_id' is not specified.
    tags                = optional(map(string), {}) # Additional tags for the subnet.
  }))
}

variable "tags" {
  description = "Additional tags for the vpc."
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

variable "ccn_uin" {
  description = "Uin of the ccn attached. If not set, which means the uin of this account. This parameter is used with case when attaching ccn of other account to the instance of this account. For now only support instance type `VPC`."
  type        = string
  default     = null
}

variable "instance_region" {
  description = "The region of the vpc"
  type        = string
}

variable "attachment_desc" {
  description = "Description of the CCN to be created, and maximum length does not exceed 100 bytes."
  type        = string
  default     = null
}

variable "route_table_id" {
  description = "The ID of ccn route table which to associate."
  type        = string
  default     = null
}