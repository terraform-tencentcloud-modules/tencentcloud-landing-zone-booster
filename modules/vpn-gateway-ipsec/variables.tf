# Customer Gateway
variable "customer_gateway_name" {
  description = "Name of the customer gateway. The length of character is limited to 1-60."
  type        = string
}

variable "customer_gateway_address" {
  description = "Public IP of the customer gateway."
  type        = string
}

variable "customer_gateway_tags" {
  description = "A list of tags used to associate customer gateway."
  type        = map(string)
  default     = {}
}

# VPN Connection
variable "connection_name" {
  description = "Name of the VPN connection. The length of character is limited to 1-60."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC. Required if vpn gateway is not in CCN type, and doesn't make sense for CCN vpn gateway."
  type        = string
}

variable "vpn_gateway_id" {
  description = "ID of the VPN gateway."
  type        = string
}

variable "pre_share_key" {
  description = "Pre-shared key of the VPN connection."
  type        = string
  default     = "test"
}

variable "ike_version" {
  description = "Version of the IKE operation specification, values: IKEV1, IKEV2. Default value is IKEV1."
  type        = string
  default     = "IKEV1"
}

variable "ike_proto_encry_algorithm" {
  description = "Proto encrypt algorithm of the IKE operation specification. Valid values: 3DES-CBC, AES-CBC-128, AES-CBC-192, AES-CBC-256, DES-CBC, SM4, AES128GCM128, AES192GCM128, AES256GCM128,AES128GCM128, AES192GCM128, AES256GCM128. Default value is 3DES-CBC."
  type        = string
  default     = "3DES-CBC"
}

variable "ike_proto_authen_algorithm" {
  description = "Proto authenticate algorithm of the IKE operation specification. Valid values: MD5, SHA, SHA-256. Default Value is MD5."
  type        = string
  default     = "SHA"
}

variable "ike_local_identity" {
  description = "Local identity way of IKE operation specification. Valid values: ADDRESS, FQDN. Default value is ADDRESS."
  type        = string
  default     = "ADDRESS"
}
variable "ike_exchange_mode" {
  description = "Exchange mode of the IKE operation specification. Valid values: AGGRESSIVE, MAIN. Default value is MAIN."
  type        = string
  default     = "AGGRESSIVE"
}

variable "ike_local_address" {
  description = "Local address of IKE operation specification, valid when ike_local_identity is ADDRESS, generally the value is public_ip_address of the related VPN gateway."
  type        = string
}

variable "ike_remote_identity" {
  description = "Remote identity way of IKE operation specification. Valid values: ADDRESS, FQDN. Default value is ADDRESS."
  type        = string
  default     = "ADDRESS"
}

variable "ike_remote_address" {
  description = "Remote address of IKE operation specification, valid when ike_remote_identity is ADDRESS, generally the value is public_ip_address of the related customer gateway."
  type        = string
  default     = null
}

variable "ike_dh_group_name" {
  description = "DH group name of the IKE operation specification. Valid values: GROUP1, GROUP2, GROUP5, GROUP14, GROUP24. Default value is GROUP1."
  type        = string
  default     = "GROUP2"
}

variable "ike_sa_lifetime_seconds" {
  description = "SA lifetime of the IKE operation specification, unit is second. The value ranges from 60 to 604800. Default value is 86400 seconds."
  type        = number
  default     = 86400
}

variable "ipsec_encrypt_algorithm" {
  description = "Encrypt algorithm of the IPSEC operation specification. Valid values: 3DES-CBC, AES-CBC-128, AES-CBC-192, AES-CBC-256, DES-CBC, SM4, NULL, AES128GCM128, AES192GCM128, AES256GCM128. Default value is 3DES-CBC."
  type        = string
  default     = "3DES-CBC"
}

variable "ipsec_integrity_algorithm" {
  description = "Integrity algorithm of the IPSEC operation specification. Valid values: SHA1, MD5, SHA-256. Default value is MD5."
  type        = string
  default     = "MD5"
}

variable "ipsec_sa_lifetime_seconds" {
  description = "SA lifetime of the IPSEC operation specification, unit is second. Valid value ranges: [180~604800]. Default value is 3600 seconds."
  type        = number
  default     = "3600"
}

variable "ipsec_sa_lifetime_traffic" {
  description = "SA lifetime of the IPSEC operation specification, unit is second. Valid value ranges: [180~604800]. Default value is 3600 seconds."
  type        = number
  default     = "2560"
}

variable "ipsec_pfs_dh_group" {
  description = "PFS DH group. Valid value: GROUP1, GROUP2, GROUP5, GROUP14, GROUP24, NULL. Default value is NULL."
  type        = string
  default     = null
}

variable "dpd_action" {
  description = "The action after DPD timeout. Valid values: clear (disconnect) and restart (try again). It is valid when DpdEnable is 1."
  type        = string
  default     = "restart"
}

variable "dpd_enable" {
  description = "Specifies whether to enable DPD. Valid values: 0 (disable) and 1 (enable)."
  type        = number
  default     = 1
}

variable "dpd_timeout" {
  description = "DPD timeout period.Valid value ranges: [30~60], Default: 30; unit: second. If the request is not responded within this period, the peer end is considered not exists. This parameter is valid when the value of DpdEnable is 1."
  type        = number
  default     = 30
}

variable "enable_health_check" {
  description = "Whether intra-tunnel health checks are supported."
  type        = bool
  default     = false
}

variable "health_check_local_ip" {
  description = "Health check the address of this terminal."
  type        = string
  default     = null
}

variable "health_check_remote_ip" {
  description = "Health check peer address."
  type        = string
  default     = null
}

variable "spd_policy" {
  type        = list(map(string))
  default     = []
  description = "Security group policy of the VPN connection."
}

variable "vpn_connection_tags" {
  description = "A list of tags used to associate vpn connection."
  type        = map(string)
  default     = {}
}

# Gateway route
variable "destination_cidr_block" {
  description = "Destination IDC IP range."
  type        = string
  default     = "192.168.0.0/24"
}

variable "route_priority" {
  description = "Priority. Valid values: 0 and 100."
  type        = number
  default     = 100
}

variable "route_status" {
  description = "Whether routing information is enabled. ENABLE: Enable Route, DISABLE: Disable Route."
  type        = string
  default     = "ENABLE"
}

variable "instance_type" {
  description = "Next hop type (type of the associated instance). Valid values: VPNCONN (VPN tunnel) and CCN (CCN instance)."
  type        = string
  default     = "VPNCONN"
}