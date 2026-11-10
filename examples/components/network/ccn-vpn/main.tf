terraform {
  required_version = ">= 1.5.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.81.125"
    }
  }
}

provider "tencentcloud" {
  region = "ap-shanghai"
}

module "ccn_vpn" {
  source = "../../../../components/network/ccn-vpn"

  attached_ccn_id     = "ccn-00v00001"
  attached_ccn_region = "ap-shanghai"

  # ccn vpn gateway configuration
  name               = "test-vpn-gateway"
  bandwidth          = 200
  zone               = "ap-shanghai-5"
  type               = "CCN"
  charge_type        = "POSTPAID_BY_HOUR"
  prepaid_period     = 1
  prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"
  max_connection     = 100
  tags               = { createBy = "Terraform" }
  bgp_asn            = 65351

  # customer gateway configuration
  customer_gateway_name              = "test-customer-gateway"
  customer_gateway_public_ip_address = "10.0.0.1"
  customer_gateway_bgp_asn           = 651001

  # vpn connection configuration
  vpn_connection_name                = "test-vpn-connection"
  vpn_connection_pre_share_key       = "your_pre_share_key"
  vpn_connection_route_type          = "Bgp"
  vpn_connection_negotiation_type    = "flowTrigger"
  vpn_connection_bgp_config = [{
      # Tencent Cloud BGP IP BGP IP
      local_bgp_ip  = "10.110.0.1"
      # client BGP IP
      remote_bgp_ip = "10.110.0.10"
      # Tunnel segment(within the allowable range)
      tunnel_cidr   = "10.110.0.10/30"
  }]

  # IKE setting
  vpn_connection_ike_proto_encry_algorithm  = "3DES-CBC"
  vpn_connection_ike_proto_authen_algorithm = "SHA"
  vpn_connection_ike_local_identity         = "ADDRESS"
  vpn_connection_ike_exchange_mode          = "AGGRESSIVE"
  vpn_connection_ike_local_address          = null
  vpn_connection_ike_remote_identity        = "ADDRESS"
  vpn_connection_ike_remote_address         = "10.110.1.100"
  vpn_connection_ike_dh_group_name          = "GROUP2"
  vpn_connection_ike_sa_lifetime_seconds    = 86400

  # IPSEC setting
  vpn_connection_ipsec_encrypt_algorithm   = "3DES-CBC"
  vpn_connection_ipsec_integrity_algorithm = "SHA1"
  vpn_connection_ipsec_sa_lifetime_seconds = 14400
  vpn_connection_ipsec_pfs_dh_group        = "NULL"
  vpn_connection_ipsec_sa_lifetime_traffic = 4096000000

  # Health Check setting
  vpn_connection_enable_health_check    = false
  # vpn_connection_health_check_local_ip  = "10.0.0.10"
  # vpn_connection_health_check_remote_ip = "10.0.1.10"
  # vpn_connection_health_check_config = [{
  #     probe_type      = "NQA"
  #     probe_interval  = 5000
  #     probe_threshold = 3
  #     probe_timeout   = 150
  # }]

  vpn_connection_security_group_policy = [{
    local_cidr_block  = "0.0.0.0/0"
    remote_cidr_block = ["0.0.0.0/0"]
  }]
  vpn_connection_tags = { createBy = "Terraform" }
}