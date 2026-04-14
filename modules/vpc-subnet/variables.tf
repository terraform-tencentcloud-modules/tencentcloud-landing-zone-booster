variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The vpc id used to launch resources."
  type        = string
  default     = "1"
}

variable "subnet_name" {
  description = "Specify the subnet name when 'vpc_id' is not specified."
  default     = "subnet"
}

variable "subnet_cidr" {
  description = "Specify the subnet cidr blocks when 'vpc_id' is not specified."
  type        = string
}

variable "availability_zone" {
  description = "Specify the subnet availability zone."
  type        = string
  default     = ""
}

variable "subnet_is_multicast" {
  description = "Specify the subnet is multicast when 'vpc_id' is not specified."
  default     = true
}

variable "subnet_tags" {
  description = "Additional tags for the subnet."
  type        = map(string)
  default     = {}
}

variable "route_table_id" {
  description = "route_table_id of subnet."
  type        = string
  default     = null
}