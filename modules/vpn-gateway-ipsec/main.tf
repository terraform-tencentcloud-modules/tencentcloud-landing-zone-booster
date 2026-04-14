################################################################################
# VPN Customer Gateway
################################################################################
resource "tencentcloud_vpn_customer_gateway" "customer_gateway" {
  name              = var.customer_gateway_name
  public_ip_address = var.customer_gateway_address
  tags              = var.customer_gateway_tags
}

################################################################################
# VPN Connection
################################################################################
resource "tencentcloud_vpn_connection" "connection" {
  name                       = var.connection_name
  vpc_id                     = var.vpc_id
  vpn_gateway_id             = var.vpn_gateway_id
  customer_gateway_id        = tencentcloud_vpn_customer_gateway.customer_gateway.id
  pre_share_key              = var.pre_share_key
  ike_version                = var.ike_version
  ike_proto_encry_algorithm  = var.ike_proto_encry_algorithm
  ike_proto_authen_algorithm = var.ike_proto_authen_algorithm
  ike_local_identity         = var.ike_local_identity
  ike_exchange_mode          = var.ike_exchange_mode
  ike_local_address          = try(var.ike_local_address, null)
  ike_remote_identity        = var.ike_remote_identity
  ike_remote_address         = try(var.ike_remote_address, null)
  ike_dh_group_name          = var.ike_dh_group_name
  ike_sa_lifetime_seconds    = var.ike_sa_lifetime_seconds
  ipsec_encrypt_algorithm    = var.ipsec_encrypt_algorithm
  ipsec_integrity_algorithm  = var.ipsec_integrity_algorithm
  ipsec_sa_lifetime_seconds  = var.ipsec_sa_lifetime_seconds
  ipsec_pfs_dh_group         = try(var.ipsec_pfs_dh_group, null)
  ipsec_sa_lifetime_traffic  = var.ipsec_sa_lifetime_traffic
  dpd_enable                 = var.dpd_enable
  dpd_timeout                = var.dpd_timeout
  dpd_action                 = var.dpd_action
  enable_health_check        = var.enable_health_check
  health_check_local_ip      = try(var.health_check_local_ip, null)
  health_check_remote_ip     = try(var.health_check_remote_ip, null)

  dynamic "security_group_policy" {
    for_each = try(var.spd_policy, [])
    content {
      local_cidr_block  = security_group_policy.value.local_cidr_block
      remote_cidr_block = split(",", security_group_policy.value.remote_cidr_blocks)
    }
  }
  tags = try(var.vpn_connection_tags, {})
}

################################################################################
# VPN Gateway Route
################################################################################
resource "tencentcloud_vpn_gateway_route" "vpn_gateway_route" {
  vpn_gateway_id         = var.vpn_gateway_id
  destination_cidr_block = var.destination_cidr_block
  instance_id            = tencentcloud_vpn_connection.connection.id
  instance_type          = var.instance_type
  priority               = var.route_priority
  status                 = var.route_status
}