# 基础网络配置
variable "deploy_region" {
  description = "The region to deploy the BH resource."
  type        = string
  default     = "ap-guangzhou"
}

variable "deploy_zone" {
  description = "The availability zone to deploy the BH resource."
  type        = string
  default     = "ap-guangzhou-6"
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet within the VPC."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "192.168.0.0/16"
}

variable "cidr_block" {
  description = "The CIDR block for the resource."
  type        = string
  default     = "192.168.11.0/24"
}

# 资源规格与配置
variable "resource_edition" {
  description = "The edition of the BH resource (e.g., standard)."
  type        = string
  default     = "standard"
}

variable "resource_node" {
  description = "The number of nodes for the BH resource."
  type        = number
  default     = 20
}

# 计费相关配置
variable "time_unit" {
  description = "The unit of the purchase time (m for month)."
  type        = string
  default     = "m"
}

variable "time_span" {
  description = "The length of purchase (e.g., 1)."
  type        = number
  default     = 1
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

# 访问配置
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