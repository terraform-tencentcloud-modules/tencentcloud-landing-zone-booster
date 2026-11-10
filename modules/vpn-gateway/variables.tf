# VPN Gateway
variable "create_vpn_gateway" {
  description = "Controls if VPN Gateway should be created (it affects almost all resources)."
  type        = bool
  default     = true
}

variable "zone" {
  description = "Zone of the VPN gateway."
  type        = string
  default     = ""
}

variable "vpn_gateway_name" {
  description = "Name of the VPN gateway. The length of character is limited to 1-60."
  type        = string
}

variable "bandwidth" {
  description = "The maximum public network output bandwidth of VPN gateway (unit: Mbps), the available values include: 5,10,20,50,100,200,500,1000. Default is 5. When charge type is PREPAID, bandwidth degradation operation is unsupported."
  type        = number
}

variable "type" {
  description = "Type of gateway instance, Default is IPSEC. Valid value: IPSEC, SSL, CCN and SSL_CCN."
  type        = string
  default     = "IPSEC"
}

variable "vpc_id" {
  description = "ID of the VPC. Required if vpn gateway is not in CCN or SSL_CCN type, and doesn't make sense for CCN or SSL_CCN vpn gateway."
  type        = string
  default     = "null"
}

variable "vpc_instance_name" {
  description = "Name of the VPC."
  type        = string
  default     = "null"
}

variable "charge_type" {
  description = "Charge Type of the VPN gateway. Valid value: PREPAID, POSTPAID_BY_HOUR. The default is POSTPAID_BY_HOUR."
  type        = string
  default     = "POSTPAID_BY_HOUR"
}

variable "prepaid_period" {
  description = "Period of instance to be prepaid. Valid value: 1, 2, 3, 4, 6, 7, 8, 9, 12, 24, 36. The unit is month. Caution: when this para and renew_flag para are valid, the request means to renew several months more pre-paid period. This para can only be changed on IPSEC vpn gateway."
  type        = number
}

variable "prepaid_renew_flag" {
  description = "Flag indicates whether to renew or not. Valid value: NOTIFY_AND_AUTO_RENEW, NOTIFY_AND_MANUAL_RENEW."
  type        = string
}

variable "max_connection" {
  description = "Maximum number of connected clients allowed for the SSL VPN gateway. Valid values: [5, 10, 20, 50, 100]. This parameter is only required for SSL VPN gateways."
  type        = number
}

variable "vpn_tags" {
  description = "Tags of the VPN Gateway to be created."
  type        = map(string)
  default     = {}
}