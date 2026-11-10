variable "network_acl_id" {
  description = "ID to be used on Network ACL"
  type        = string
}

variable "vpc_subnet_id" {
  description = "ID of the subnet to be attached to the Network ACL"
  type        = string
}