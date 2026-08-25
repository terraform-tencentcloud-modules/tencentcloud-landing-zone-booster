################################################################################
# VPN Gateway Variables
################################################################################
variable "name" {
  description = "(Required) Name of the VPN gateway. The length of character is limited to 1-60."
  type        = string
}

variable "bandwidth" {
  description = "(Optional) The maximum public network output bandwidth of VPN gateway (unit: Mbps), the available values include: 5,10,20,50,100,200,500,1000. Default is 5. When charge type is PREPAID, bandwidth degradation operation is unsupported."
  type        = number
  default     = 5
}

variable "zone" {
  description = "(Optional, ForceNew) Zone of the VPN gateway."
  type        = string
  default     = null
}

variable "type" {
  description = "(Optional) Type of gateway instance, Default is IPSEC. Valid value: IPSEC, SSL, CCN and SSL_CCN."
  type        = string
  default     = "IPSEC"
}

variable "charge_type" {
  description = "(Optional) Charge Type of the VPN gateway. Valid value: PREPAID, POSTPAID_BY_HOUR. The default is POSTPAID_BY_HOUR."
  type        = string
  default     = "POSTPAID_BY_HOUR"
}

variable "prepaid_period" {
  description = "(Optional) Period of instance to be prepaid. Valid value: 1, 2, 3, 4, 6, 7, 8, 9, 12, 24, 36. The unit is month. Caution: when this para and renew_flag para are valid, the request means to renew several months more pre-paid period. This para can only be changed on IPSEC vpn gateway."
  type        = number
  default     = 1
}

variable "prepaid_renew_flag" {
  description = "(Optional) Flag indicates whether to renew or not. Valid value: NOTIFY_AND_AUTO_RENEW, NOTIFY_AND_MANUAL_RENEW."
  type        = string
  default     = "NOTIFY_AND_AUTO_RENEW"
}

variable "max_connection" {
  description = "(Optional) Maximum number of connected clients allowed for the SSL VPN gateway. Valid values: [5, 10, 20, 50, 100]. This parameter is only required for SSL VPN gateways."
  type        = number
  default     = 5
}

variable "tags" {
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
# Customer Gateway Variables
################################################################################
variable "customer_gateways" {
  description = "(Optional, Map) Customer gateway configuration."
  type = map(object({
    name              = string                # (Required, String) Name of the customer gateway. The length of character is limited to 1-60.
    public_ip_address = string                # (Required, String, ForceNew) Public IP of the customer gateway.
    bgp_asn           = optional(number)      # (Optional, Int) BGP ASN. Value range: 1 - 4294967295. Using BGP requires configuring ASN. 139341, 45090, and 58835 are not available.
    tags              = optional(map(string)) # (Optional, Map) A list of tags used to associate different resources.
  }))
  default = {}
}

################################################################################
# VPN Connection Variables
################################################################################
variable "vpn_connections" {
  description = "(Optional, Map) VPN connection configuration."
  type = map(object({
    # ── Required ──
    name                  = string # (Required, String) Name of the VPN connection. The length of character is limited to 1-60.
    pre_share_key         = string # (Required, String) Pre-shared key of the VPN connection.
    customer_gateway_name = string # (Required, String) Name of the customer gateway.

    # ── Optional (Flat) ──
    route_type                 = optional(string) # (Optional, String, ForceNew) Route type of the VPN connection. Valid value: STATIC, StaticRoute, Policy, Bgp.
    negotiation_type           = optional(string) # (Optional, String) The default negotiation type is active. Optional values: active (active negotiation), passive (passive negotiation), flowTrigger (traffic negotiation).
    dpd_enable                 = optional(number) # (Optional, Int) Specifies whether to enable DPD. Valid values: 0 (disable) and 1 (enable).
    dpd_action                 = optional(string) # (Optional, String) The action after DPD timeout. Valid values: clear (disconnect) and restart (try again). It is valid when DpdEnable is 1.
    dpd_timeout                = optional(number) # (Optional, Int) DPD timeout period.Valid value ranges: [30~60], Default: 30; unit: second. If the request is not responded within this period, the peer end is considered not exists. This parameter is valid when the value of DpdEnable is 1.
    ike_proto_encry_algorithm  = optional(string) # (Optional, String) Proto encrypt algorithm of the IKE operation specification. Valid values: 3DES-CBC, AES-CBC-128, AES-CBC-192, AES-CBC-256, DES-CBC, SM4, AES128GCM128, AES192GCM128, AES256GCM128,AES128GCM128, AES192GCM128, AES256GCM128. Default value is 3DES-CBC.
    ike_proto_authen_algorithm = optional(string) # (Optional, String) Proto authenticate algorithm of the IKE operation specification. Valid values: MD5, SHA, SHA-256. Default Value is MD5.
    ike_local_identity         = optional(string) # (Optional, String) Local identity way of IKE operation specification. Valid values: ADDRESS, FQDN. Default value is ADDRESS.
    ike_exchange_mode          = optional(string) # (Optional, String) Exchange mode of the IKE operation specification. Valid values: AGGRESSIVE, MAIN. Default value is MAIN.
    ike_local_address          = optional(string) # (Optional, String) Local address of IKE operation specification, valid when ike_local_identity is ADDRESS, generally the value is public_ip_address of the related VPN gateway.
    ike_remote_identity        = optional(string) # (Optional, String) Remote identity way of IKE operation specification. Valid values: ADDRESS, FQDN. Default value is ADDRESS.
    ike_remote_address         = optional(string) # (Optional, String) Remote address of IKE operation specification, valid when ike_remote_identity is ADDRESS, generally the value is public_ip_address of the related customer gateway.
    ike_dh_group_name          = optional(string) # (Optional, String) DH group name of the IKE operation specification. Valid values: GROUP1, GROUP2, GROUP5, GROUP14, GROUP24. Default value is GROUP1.
    ike_sa_lifetime_seconds    = optional(number) # (Optional, Int) SA lifetime of the IKE operation specification, unit is second. The value ranges from 60 to 604800. Default value is 86400 seconds.
    ike_local_fqdn_name        = optional(string) # (Optional, String) Local FQDN name of the IKE operation specification.
    ike_remote_fqdn_name       = optional(string) # (Optional, String) Remote FQDN name of the IKE operation specification.
    ike_version                = optional(string) # (Optional, String) Version of the IKE operation specification, values: IKEV1, IKEV2. Default value is IKEV1.
    ipsec_encrypt_algorithm    = optional(string) # (Optional, String) Encrypt algorithm of the IPSEC operation specification. Valid values: 3DES-CBC, AES-CBC-128, AES-CBC-192, AES-CBC-256, DES-CBC, SM4, NULL, AES128GCM128, AES192GCM128, AES256GCM128. Default value is 3DES-CBC.
    ipsec_integrity_algorithm  = optional(string) # (Optional, String) Integrity algorithm of the IPSEC operation specification. Valid values: SHA1, MD5, SHA-256. Default value is MD5.
    ipsec_sa_lifetime_seconds  = optional(number) # (Optional, Int) SA lifetime of the IPSEC operation specification, unit is second. Valid value ranges: [180~604800]. Default value is 3600 seconds.
    ipsec_pfs_dh_group         = optional(string) # (Optional, String) PFS DH group. Valid value: DH-GROUP1, DH-GROUP2, DH-GROUP5, DH-GROUP14, DH-GROUP24, NULL. Default value is NULL.
    ipsec_sa_lifetime_traffic  = optional(number) # (Optional, Int) SA lifetime of the IPSEC operation specification, unit is KB. The value should not be less then 2560. Default value is 1843200.
    enable_health_check        = optional(bool, false) # (Optional, Bool) Whether intra-tunnel health checks are supported.
    health_check_local_ip      = optional(string) # (Optional, String) Health check the address of this terminal.
    health_check_remote_ip     = optional(string) # (Optional, String) Health check peer address.
    tags                       = optional(map(string), {}) # (Optional, Map) A list of tags used to associate different resources.

    # (Optional, List, ForceNew) BGP config.
    bgp_config = optional(list(object({
      local_bgp_ip  = string
      remote_bgp_ip = string
      tunnel_cidr   = string
    })), [])

    # (Optional, List) VPN channel health check configuration."
    health_check_config = optional(object({
      probe_interval  = optional(number)
      probe_threshold = optional(number)
      probe_timeout   = optional(number)
      probe_type      = optional(string)
    }))

    # (Optional, Set) SPD policy group, 
    # for example: {'10.0.0.5/24':['172.123.10.5/16']}, 10.0.0.5/24 is the vpc intranet segment, and 172.123.10.5/16 is the IDC network segment. 
    # Users specify which network segments in the VPC can communicate with which network segments in your IDC.
    security_group_policy = optional(set(object({
      local_cidr_block  = string
      remote_cidr_block = set(string)
    })), [])
  }))
  default = {}
}

################################################################################
# Attached CCN Variables
################################################################################
variable "ccn_uin" {
  description = "(Optional, String, ForceNew) Uin of the ccn attached. If not set, which means the uin of this account. This parameter is used with case when attaching ccn of other account to the instance of this account. For now only support instance type VPC."
  type        = string
  default     = null
}

variable "attached_ccn_id" {
  description = "Controls if VPN Gateway should be created"
  type        = string
}

variable "attached_ccn_region" {
  description = "Controls if VPN Gateway should be created"
  type        = string
}

variable "attached_ccn_description" {
  description = "Controls if VPN Gateway should be created"
  type        = string
  default     = null
}

################################################################################
# CCN route table associate Variables
################################################################################
variable "route_table_id" {
  description = "The ID of ccn route table which to associate."
  type        = string
  default     = null
}