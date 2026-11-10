################################################################################
# VPN Gateway Variables
################################################################################
variable "vpn_gateway_name" {
  description = "(Required) Name of the VPN gateway. The length of character is limited to 1-60."
  type        = string
}

variable "bandwidth" {
  description = "(Optional) The maximum public network output bandwidth of VPN gateway (unit: Mbps), the available values include: 5,10,20,50,100,200,500,1000. Default is 5. When charge type is PREPAID, bandwidth degradation operation is unsupported."
  type        = number
  default     = 5
}

variable "type" {
  description = "(Optional) Type of gateway instance, Default is IPSEC. Valid value: IPSEC, SSL, CCN and SSL_CCN."
  type        = string
  default     = "IPSEC"
}

variable "vpc_id" {
  description = "(Optional, ForceNew) ID of the VPC. Required if vpn gateway is not in CCN or SSL_CCN type, and doesn't make sense for CCN or SSL_CCN vpn gateway."
  type        = string
  default     = null
}

variable "zone" {
  description = "(Optional, ForceNew) Zone of the VPN gateway."
  type        = string
  default     = "ap-guangzhou-3"
}

variable "charge_type" {
  description = "(Optional) Charge Type of the VPN gateway. Valid value: PREPAID, POSTPAID_BY_HOUR. The default is POSTPAID_BY_HOUR."
  type        = string
  default     = "POSTPAID_BY_HOUR"
}

variable "prepaid_period" {
  description = "(Optional) Period of instance to be prepaid. Valid value: 1, 2, 3, 4, 6, 7, 8, 9, 12, 24, 36. The unit is month. Caution: when this para and renew_flag para are valid, the request means to renew several months more pre-paid period. This para can only be changed on IPSEC vpn gateway."
  type        = number
  default     = null
}

variable "prepaid_renew_flag" {
  description = "(Optional) Flag indicates whether to renew or not. Valid value: NOTIFY_AND_AUTO_RENEW, NOTIFY_AND_MANUAL_RENEW."
  type        = string
  default     = null
}

variable "max_connection" {
  description = "(Optional) Maximum number of connected clients allowed for the SSL VPN gateway. Valid values: [5, 10, 20, 50, 100]. This parameter is only required for SSL VPN gateways."
  type        = number
  default     = null
}

variable "vpn_tags" {
  description = "(Optional) A list of tags used to associate different resources."
  type        = map(string)
  default     = {}
}

# v2新增参数
variable "bgp_asn" {
  description = "(Optional) BGP ASN. Value range: 1 - 4294967295. Using BGP requires configuring ASN."
  type        = number
  default     = null
}

variable "cdc_id" {
  description = "(Optional) CDC instance ID."
  type        = string
  default     = null
}

################################################################################
# CCN Variables
################################################################################
variable "create_ccn" {
  description = "(Optional) Controls if CCN should be created"
  type        = bool
  default     = false
}

variable "ccn_name" {
  description = "(Optional) Name of the CCN."
  type        = string
  default     = null
}

variable "bandwidth_limit_type" {
  description = "(Optional) Bandwidth limit type. Valid values: INTER_REGION_LIMIT, OUTER_REGION_LIMIT."
  type        = string
  default     = "INTER_REGION_LIMIT"
}

variable "ccn_charge_type" {
  description = "(Optional) Charge type of CCN. Valid values: PREPAID, POSTPAID_BY_HOUR."
  type        = string
  default     = "POSTPAID_BY_HOUR"
}

variable "ccn_description" {
  description = "(Optional) Description of the CCN."
  type        = string
  default     = null
}

variable "qos" {
  description = "(Optional) Service quality of CCN. Valid values: PT, AU, AG. Default is AU."
  type        = string
  default     = "AU"
}

variable "route_ecmp_flag" {
  description = "(Optional) Whether to enable the equivalent routing function. true: enabled, false: disabled. Default is false."
  type        = bool
  default     = false
}

variable "route_overlap_flag" {
  description = "(Optional) Whether to enable the routing overlap function. true: enabled, false: disabled. Default is true, cannot set to false."
  type        = bool
  default     = true
}

variable "ccn_tags" {
  description = "(Optional) Tags of the CCN."
  type        = map(string)
  default     = {}
}

################################################################################
# CCN Attachment Variables
################################################################################

variable "attach_ccn" {
  description = "(Optional) Controls if CCN should be attached to VPN gateway"
  type        = bool
  default     = false
}

variable "ccn_id" {
  description = "(Required, String, ForceNew) ID of the CCN."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "(Required, String, ForceNew) ID of instance is attached."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "(Required, String, ForceNew) Type of attached instance network, and available values include VPC, DIRECTCONNECT, BMVPC and VPNGW. Note: VPNGW type is only for whitelist customer now."
  type        = string
  default     = null
}

variable "instance_region" {
  description = "(Required, String, ForceNew) The region that the instance locates at."
  type        = string
  default     = null
}

variable "ccn_uin" {
  description = "(Optional, String, ForceNew) Uin of the ccn attached. If not set, which means the uin of this account. This parameter is used with case when attaching ccn of other account to the instance of this account. For now only support instance type VPC."
  type        = string
  default     = null
}

variable "route_table_id" {
  description = "(Optional, String, ForceNew) ID of route table."
  type        = string
  default     = null
}

variable "attachment_description" {
  description = "(Optional, String) Remark of attachment."
  type        = string
  default     = null
}

################################################################################
# Customer Gateway Variables
################################################################################
variable "customer_gateway_name" {
  description = "(Required, String) Name of the customer gateway. The length of character is limited to 1-60."
  type        = string
}

variable "customer_gateway_public_ip_address" {
  description = "(Required, String, ForceNew) Public IP of the customer gateway."
  type        = string
}

variable "customer_gateway_bgp_asn" {
  description = "(Optional, Int) BGP ASN. Value range: 1 - 4294967295. Using BGP requires configuring ASN. 139341, 45090, and 58835 are not available."
  type        = number
  default     = null
}

variable "customer_gateway_tags" {
  description = "(Optional, Map) A list of tags used to associate different resources."
  type        = map(string)
  default     = {}
}

################################################################################
# VPN Connection Variables
################################################################################
variable "vpn_connection_customer_gateway_id" {
  description = "(Required, String, ForceNew) ID of the customer gateway."
  type        = string
  default     = ""
}

variable "vpn_connection_name" {
  description = "(Required, String) Name of the VPN connection. The length of character is limited to 1-60."
  type        = string
}

variable "vpn_connection_pre_share_key" {
  description = "(Required, String) Pre-shared key of the VPN connection."
  type        = string
  default = ""
}

variable "vpn_connection_bgp_config" {
  description = "(Optional, List, ForceNew) BGP config."
  type = list(object({
    local_bgp_ip  = string
    remote_bgp_ip = string
    tunnel_cidr   = string
  }))
  default = null
}

variable "vpn_connection_dpd_action" {
  description = "(Optional, String) The action after DPD timeout. Valid values: clear (disconnect) and restart (try again). It is valid when DpdEnable is 1."
  type        = string
  default     = null
}

variable "vpn_connection_dpd_enable" {
  description = "(Optional, Int) Specifies whether to enable DPD. Valid values: 0 (disable) and 1 (enable)."
  type        = number
  default     = null
}

variable "vpn_connection_dpd_timeout" {
  description = "(Optional, Int) DPD timeout period.Valid value ranges: [30~60], Default: 30; unit: second. If the request is not responded within this period, the peer end is considered not exists. This parameter is valid when the value of DpdEnable is 1."
  type        = number
  default     = null
}

variable "vpn_connection_enable_health_check" {
  description = "(Optional, Bool) Whether intra-tunnel health checks are supported."
  type        = bool
  default     = false
}

variable "vpn_connection_health_check_config" {
  description = "(Optional, List) VPN channel health check configuration."
  type = object({
    probe_interval  = optional(number)
    probe_threshold = optional(number)
    probe_timeout   = optional(number)
    probe_type      = optional(string)
  })
  default = null
}

variable "vpn_connection_health_check_local_ip" {
  description = "(Optional, String) Health check the address of this terminal."
  type        = string
  default     = null
}

variable "vpn_connection_health_check_remote_ip" {
  description = "(Optional, String) Health check peer address."
  type        = string
  default     = null
}

variable "vpn_connection_ike_dh_group_name" {
  description = "(Optional, String) DH group name of the IKE operation specification. Valid values: GROUP1, GROUP2, GROUP5, GROUP14, GROUP24. Default value is GROUP1."
  type        = string
  default     = null
}

variable "vpn_connection_ike_exchange_mode" {
  description = "(Optional, String) Exchange mode of the IKE operation specification. Valid values: AGGRESSIVE, MAIN. Default value is MAIN."
  type        = string
  default     = null
}

variable "vpn_connection_ike_local_fqdn_name" {
  description = "(Optional, String) Local FQDN name of the IKE operation specification."
  type        = string
  default     = null
}

variable "vpn_connection_ike_local_identity" {
  description = "(Optional, String) Local identity way of IKE operation specification. Valid values: ADDRESS, FQDN. Default value is ADDRESS."
  type        = string
  default     = null
}

variable "vpn_connection_ike_proto_authen_algorithm" {
  description = "(Optional, String) Proto authenticate algorithm of the IKE operation specification. Valid values: MD5, SHA, SHA-256. Default Value is MD5."
  type        = string
  default     = null
}

variable "vpn_connection_ike_proto_encry_algorithm" {
  description = "(Optional, String) Proto encrypt algorithm of the IKE operation specification. Valid values: 3DES-CBC, AES-CBC-128, AES-CBC-192, AES-CBC-256, DES-CBC, SM4, AES128GCM128, AES192GCM128, AES256GCM128,AES128GCM128, AES192GCM128, AES256GCM128. Default value is 3DES-CBC."
  type        = string
  default     = null
}

variable "vpn_connection_ike_remote_address" {
  description = "(Optional, String) Remote address of IKE operation specification, valid when ike_remote_identity is ADDRESS, generally the value is public_ip_address of the related customer gateway."
  type        = string
  default     = null
}

variable "vpn_connection_ike_remote_fqdn_name" {
  description = "(Optional, String) Remote FQDN name of the IKE operation specification."
  type        = string
  default     = null
}

variable "vpn_connection_ike_remote_identity" {
  description = "(Optional, String) Remote identity way of IKE operation specification. Valid values: ADDRESS, FQDN. Default value is ADDRESS."
  type        = string
  default     = null
}

variable "vpn_connection_ike_sa_lifetime_seconds" {
  description = "(Optional, Int) SA lifetime of the IKE operation specification, unit is second. The value ranges from 60 to 604800. Default value is 86400 seconds."
  type        = number
  default     = null
}

variable "vpn_connection_ike_version" {
  description = "(Optional, String) Version of the IKE operation specification, values: IKEV1, IKEV2. Default value is IKEV1."
  type        = string
  default     = null
}

variable "vpn_connection_ipsec_encrypt_algorithm" {
  description = "(Optional, String) Encrypt algorithm of the IPSEC operation specification. Valid values: 3DES-CBC, AES-CBC-128, AES-CBC-192, AES-CBC-256, DES-CBC, SM4, NULL, AES128GCM128, AES192GCM128, AES256GCM128. Default value is 3DES-CBC."
  type        = string
  default     = null
}

variable "vpn_connection_ipsec_integrity_algorithm" {
  description = "(Optional, String) Integrity algorithm of the IPSEC operation specification. Valid values: SHA1, MD5, SHA-256. Default value is MD5."
  type        = string
  default     = null
}

variable "vpn_connection_ipsec_pfs_dh_group" {
  description = "(Optional, String) PFS DH group. Valid value: DH-GROUP1, DH-GROUP2, DH-GROUP5, DH-GROUP14, DH-GROUP24, NULL. Default value is NULL."
  type        = string
  default     = null
}

variable "vpn_connection_ipsec_sa_lifetime_seconds" {
  description = "(Optional, Int) SA lifetime of the IPSEC operation specification, unit is second. Valid value ranges: [180~604800]. Default value is 3600 seconds."
  type        = number
  default     = null
}

variable "vpn_connection_ipsec_sa_lifetime_traffic" {
  description = "(Optional, Int) SA lifetime of the IPSEC operation specification, unit is KB. The value should not be less then 2560. Default value is 1843200."
  type        = number
  default     = null
}

variable "vpn_connection_negotiation_type" {
  description = "(Optional, String) The default negotiation type is active. Optional values: active (active negotiation), passive (passive negotiation), flowTrigger (traffic negotiation)."
  type        = string
  default     = null
}

variable "vpn_connection_route_type" {
  description = "(Optional, String, ForceNew) Route type of the VPN connection. Valid value: STATIC, StaticRoute, Policy, Bgp."
  type        = string
  default     = null
}

variable "vpn_connection_security_group_policy" {
  description = "(Optional, Set) SPD policy group, for example: {'10.0.0.5/24':['172.123.10.5/16']}, 10.0.0.5/24 is the vpc intranet segment, and 172.123.10.5/16 is the IDC network segment. Users specify which network segments in the VPC can communicate with which network segments in your IDC."
  type = set(object({
    local_cidr_block  = string
    remote_cidr_block = set(string)
  }))
  default = null
}

variable "vpn_connection_tags" {
  description = "(Optional, Map) A list of tags used to associate different resources."
  type        = map(string)
  default     = {}
}

variable "vpn_connection_vpc_id" {
  description = "(Optional, String, ForceNew) ID of the VPC. Required if vpn gateway is not in CCN type, and doesn't make sense for CCN vpn gateway."
  type        = string
  default     = null
}
