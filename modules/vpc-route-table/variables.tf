################################################################################
# vars: Route table
################################################################################
variable "vpc_id" {
  description = "The vpc id used to launch resources."
  type        = string
  default     = ""
}

variable "route_table_name" {
  description = "The route table ame of router table in the specified vpc."
  type        = string
  default     = ""
}

variable "tags" {
  description = "The tags of routing table."
  type        = map(string)
  default     = {}
}

################################################################################
# vars: Route table entry
################################################################################
variable "destination_cidrs" {
  description = "List of destination CIDR blocks of router table in the specified VPC."
  type        = list(object({
    destination_cidr = string # Destination address block.
    next_type        = string # Type of next-hop. Valid values: CVM, VPN, DIRECTCONNECT, PEERCONNECTION, HAVIP, NAT, NORMAL_CVM, EIP, LOCAL_GATEWAY, INTRANAT, USER_CCN and GWLB_ENDPOINT.
    next_hub         = string # ID of next-hop gateway. Note: when next_type is EIP, next_hub should be 0.
  }))
  default = []
}