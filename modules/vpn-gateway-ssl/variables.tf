# Customer Gateway
variable "local_address" {
  description = "List of local CIDR."
  type        = list(string)
}

variable "remote_address" {
  description = "Remote CIDR for client."
  type        = string
}

variable "ssl_vpn_server_name" {
  description = "The name of ssl vpn server to be created."
  type        = string
}

variable "ssl_vpn_protocol" {
  description = "The protocol of ssl vpn. Default value: UDP."
  type        = string
}

variable "ssl_vpn_port" {
  description = "The port of ssl vpn. Default value: 1194."
  type        = string
}

variable "integrity_algorithm" {
  description = "The integrity algorithm. Valid values: SHA1, MD5 and NONE. Default value: NONE."
  type        = string
}

variable "encrypt_algorithm" {
  description = "The encrypt algorithm. Valid values: AES-128-CBC, AES-192-CBC, AES-256-CBC, NONE.Default value: NONE."
  type        = string
}

variable "compress" {
  description = "If need compressed. Default value: False."
  type        = bool
}

variable "vpn_gateway_id" {
  description = "VPN gateway ID."
  type        = string
}

variable "ssl_vpn_client_name" {
  description = "VPN gateway ID."
  type        = string
}