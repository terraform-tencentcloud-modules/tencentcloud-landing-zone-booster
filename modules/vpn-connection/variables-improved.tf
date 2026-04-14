# 改进的变量文件示例
variable "availability_zone" {
  description = "Availability zone for VPN gateway"
  type        = string
  default     = ""
}

variable "customer_gateway_name" {
  description = "Name of the customer gateway"
  type        = string
  default     = "example"
}

variable "customer_gateway_public_ip" {
  description = "Public IP address of customer gateway"
  type        = string
}

variable "vpn_gateway_name" {
  description = "Name of the VPN gateway"
  type        = string
  default     = "example"
}

variable "vpn_connection_name" {
  description = "Name of the VPN connection"
  type        = string  
  default     = "example"
}

variable "vpc_id" {
  description = "VPC ID for VPN gateway"
  type        = string
}

variable "pre_share_key" {
  description = "Pre-shared key for VPN connection"
  type        = string
  sensitive   = true
}

variable "ike_local_identity" {
  description = "IKE local identity type"
  type        = string
  default     = "ADDRESS"
}

variable "ike_proto_encry_algorithm" {
  description = "IKE protocol encryption algorithm"
  type        = string
  default     = "3DES-CBC"
}

variable "ike_proto_authen_algorithm" {
  description = "IKE protocol authentication algorithm"
  type        = string
  default     = "MD5"
}

variable "local_cidr_blocks" {
  description = "Local CIDR blocks for security group policy"
  type        = list(string)
  default     = ["172.16.0.0/16"]
}

variable "remote_cidr_blocks" {
  description = "Remote CIDR blocks for security group policy"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "vpn_gateway_id" {
  description = "ID of the VPN gateway"
  type        = string
}

variable "ike_exchange_mode" {
  description = "IKE exchange mode"
  type        = string
  default     = "MAIN"
}

variable "ike_local_address" {
  description = "IKE local address"
  type        = string
  default     = ""
}

variable "ike_remote_identity" {
  description = "IKE remote identity type"
  type        = string
  default     = "ADDRESS"
}

variable "ike_remote_address" {
  description = "IKE remote address"
  type        = string
}

variable "ike_dh_group_name" {
  description = "IKE DH group name"
  type        = string
  default     = "GROUP1"
}

variable "ike_sa_lifetime_seconds" {
  description = "IKE SA lifetime in seconds"
  type        = number
  default     = 86400
}

variable "ipsec_encrypt_algorithm" {
  description = "IPSec encryption algorithm"
  type        = string
  default     = "3DES-CBC"
}

variable "ipsec_integrity_algorithm" {
  description = "IPSec integrity algorithm"
  type        = string
  default     = "MD5"
}

variable "ipsec_sa_lifetime_seconds" {
  description = "IPSec SA lifetime in seconds"
  type        = number
  default     = 3600
}

variable "ipsec_pfs_dh_group" {
  description = "IPSec PFS DH group"
  type        = string
  default     = "DH-GROUP1"
}

variable "ipsec_sa_lifetime_traffic" {
  description = "IPSec SA lifetime traffic"
  type        = number
  default     = 2560
}