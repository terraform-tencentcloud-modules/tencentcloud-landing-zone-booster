resource "tencentcloud_vpn_customer_gateway" "main" {
  name              = var.customer_gateway_name
  public_ip_address = var.customer_gateway_public_ip
  tags              = var.tags
}

resource "tencentcloud_vpn_connection" "main" {
  name                       = var.vpn_connection_name
  vpc_id                     = var.vpc_id
  vpn_gateway_id             = var.vpn_gateway_id
  customer_gateway_id        = tencentcloud_vpn_customer_gateway.main.id
  pre_share_key              = var.pre_share_key
  ike_proto_encry_algorithm  = var.ike_proto_encry_algorithm
  ike_proto_authen_algorithm = var.ike_proto_authen_algorithm
  ike_local_identity         = var.ike_local_identity
  ike_exchange_mode          = var.ike_exchange_mode
  ike_local_address          = var.ike_local_address
  ike_remote_identity        = var.ike_remote_identity
  ike_remote_address         = var.ike_remote_address
  ike_dh_group_name          = var.ike_dh_group_name
  ike_sa_lifetime_seconds    = var.ike_sa_lifetime_seconds
  ipsec_encrypt_algorithm    = var.ipsec_encrypt_algorithm
  ipsec_integrity_algorithm  = var.ipsec_integrity_algorithm
  ipsec_sa_lifetime_seconds  = var.ipsec_sa_lifetime_seconds
  ipsec_pfs_dh_group         = var.ipsec_pfs_dh_group
  ipsec_sa_lifetime_traffic  = var.ipsec_sa_lifetime_traffic
  
  dynamic "security_group_policy" {
    for_each = var.local_cidr_blocks
    content {
      local_cidr_block  = security_group_policy.value
      remote_cidr_block = var.remote_cidr_blocks
    }
  }
  
  tags = var.tags
}