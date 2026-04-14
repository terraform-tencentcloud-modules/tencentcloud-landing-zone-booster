variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
  default     = null
}

variable "vpc_name" {
  description = "The ID of the VPC."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The ID of the subnet within the VPC."
  type        = string
  default     = null
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = null
}

variable "deploy_region" {
  description = "The region to deploy the BH resource."
  type        = string
}

variable "deploy_zone" {
  description = "The availability zone to deploy the BH resource."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the resource."
  type        = string
  default     = null
}

variable "resource_edition" {
  description = "The edition of the BH resource (e.g., standard)."
  type        = string
  default     = null
}

variable "resource_node" {
  description = "The number of nodes for the BH resource."
  type        = number
  default     = null
}

variable "time_unit" {
  description = "The unit of the purchase time (m for month)."
  type        = string
  default     = null
}

variable "time_span" {
  description = "The length of purchase (e.g., 1)."
  type        = number
  default     = null
}

variable "pay_mode" {
  description = "The pay mode (1 for prepaid)."
  type        = number
  default     = 1
}

variable "auto_renew_flag" {
  description = "Whether to enable auto-renewal (1 for enable)."
  type        = number
  default     = 1
}

variable "intranet_access" {
  description = "Whether to enable intranet access (1 for enable)."
  type        = number
  default     = 1
}

variable "external_access" {
  description = "Whether to enable external access (1 for enable)."
  type        = number
  default     = 1
}