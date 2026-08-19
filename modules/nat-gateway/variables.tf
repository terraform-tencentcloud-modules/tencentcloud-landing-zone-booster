variable "vpc_id" {
  type        = string
  description = "ID of vpc where nat gateway created"
}

variable "nat_gateway_name" {
  type        = string
  description = "Nat gateway name"
}

variable "nat_gateway_zone" {
  type        = string
  default     = null
  description = "Nat gateway name"
}

variable "nat_gateway_eips" {
  type        = list(string)
  default     = []
  description = "EIP IP address set bound to the gateway. The value of at least 1 and at most 10 if do not apply for a whitelist."
}

variable "nat_gateway_public_ips" {
  description = "List of EIPs to be used for `nat_gateway`"
  type        = list(string)
  default     = []
}

variable "nat_product_version" {
  type        = number
  default     = 1
  description = "1: traditional NAT, 2: standard NAT, default value is 1."
}

variable "nat_gateway_bandwidth" {
  type        = number
  default     = 100
  description = "The maximum public network output bandwidth of NAT gateway (unit: Mbps). Valid values: 20, 50, 100, 200, 500, 1000, 2000, 5000. Default is 100. When the value of parameter nat_product_version is 2, which is the standard NAT type, this parameter does not need to be filled in and defaults to 5000."
}

variable "nat_gateway_concurrent" {
  type        = number
  default     = 1000000
  description = "The upper limit of concurrent connection of NAT gateway. Valid values: 1000000, 3000000, 10000000. Default is 1000000. When the value of parameter nat_product_version is 2, which is the standard NAT type, this parameter does not need to be filled in and defaults to 2000000."
}

variable "stock_public_ip_addresses_bandwidth_out" {
  description = "The elastic public IP bandwidth value (unit: Mbps) for binding NAT gateway. When this parameter is not filled in, it defaults to the bandwidth value of the elastic public IP, and for some users, it defaults to the bandwidth limit of the elastic public IP of that user type."
  type        = number
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "enable_flow_monitor" {
  type        = bool
  default     = false
  description = "Whether to enable flow monitor"
}