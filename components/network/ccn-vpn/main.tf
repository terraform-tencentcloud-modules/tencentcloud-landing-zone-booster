################################################################################
# VPN GATEWAY
################################################################################
resource "tencentcloud_vpn_gateway" "vpn_gateway" {
  name               = var.name
  bandwidth          = var.bandwidth
  zone               = var.zone
  type               = var.type
  charge_type        = var.charge_type
  prepaid_period     = var.charge_type == "PREPAID" ? var.prepaid_period : null
  prepaid_renew_flag = var.charge_type == "PREPAID" ? var.prepaid_renew_flag : null
  max_connection     = var.type == "SSL" ? var.max_connection : null
  tags               = var.tags

  # New params with V2
  bgp_asn = var.bgp_asn
  cdc_id  = var.cdc_id
}

################################################################################
# Customer Gateway
################################################################################
resource "tencentcloud_vpn_customer_gateway" "vpn_customer_gateway" {
  for_each = var.customer_gateways

  name              = each.value.name
  public_ip_address = each.value.public_ip_address
  bgp_asn           = each.value.bgp_asn
  tags              = each.value.tags

  lifecycle {
    ignore_changes = [
      bgp_asn # Cannot modify BGP ASN after BGP tunnel is created
    ]
  }
}

################################################################################
# VPN Connection
################################################################################
resource "tencentcloud_vpn_connection" "vpn_connection" {
  for_each = var.vpn_connections

  vpn_gateway_id      = tencentcloud_vpn_gateway.vpn_gateway.id
  customer_gateway_id = tencentcloud_vpn_customer_gateway.vpn_customer_gateway[each.value.customer_gateway_name].id
  name                = each.value.name
  pre_share_key       = each.value.pre_share_key
  route_type          = each.value.route_type
  negotiation_type    = each.value.negotiation_type

  # BGP Configuration - Enabled when the route type is BGP
  dynamic "bgp_config" {
    for_each = each.value.route_type != null && each.value.route_type == "Bgp" ? each.value.bgp_config : []
    content {
      local_bgp_ip  = bgp_config.value.local_bgp_ip
      remote_bgp_ip = bgp_config.value.remote_bgp_ip
      tunnel_cidr   = bgp_config.value.tunnel_cidr
    }
  }

  # DPD Setting
  dpd_enable  = each.value.dpd_enable
  dpd_action  = each.value.dpd_action
  dpd_timeout = each.value.dpd_timeout

  # IKE setting
  ike_proto_encry_algorithm  = each.value.ike_proto_encry_algorithm
  ike_proto_authen_algorithm = each.value.ike_proto_authen_algorithm
  ike_local_identity         = each.value.ike_local_identity
  ike_exchange_mode          = each.value.ike_exchange_mode
  ike_remote_identity        = each.value.ike_remote_identity
  ike_remote_address         = each.value.ike_remote_address
  ike_dh_group_name          = each.value.ike_dh_group_name
  ike_sa_lifetime_seconds    = each.value.ike_sa_lifetime_seconds
  ike_local_address          = each.value.ike_local_identity != null && each.value.ike_local_identity == "ADDRESS" ? tencentcloud_vpn_gateway.vpn_gateway.public_ip_address : null
  ike_local_fqdn_name        = each.value.ike_local_fqdn_name
  ike_remote_fqdn_name       = each.value.ike_remote_fqdn_name
  ike_version                = each.value.ike_version

  # IPSEC setting
  ipsec_encrypt_algorithm   = each.value.ipsec_encrypt_algorithm
  ipsec_integrity_algorithm = each.value.ipsec_integrity_algorithm
  ipsec_sa_lifetime_seconds = each.value.ipsec_sa_lifetime_seconds
  ipsec_pfs_dh_group        = each.value.ipsec_pfs_dh_group
  ipsec_sa_lifetime_traffic = each.value.ipsec_sa_lifetime_traffic

  # health check setting
  enable_health_check    = each.value.enable_health_check
  health_check_local_ip  = each.value.health_check_local_ip
  health_check_remote_ip = each.value.health_check_remote_ip
  dynamic "health_check_config" {
    for_each = each.value.health_check_config != null ? [each.value.health_check_config] : []
    content {
      probe_interval  = health_check_config.value.probe_interval
      probe_threshold = health_check_config.value.probe_threshold
      probe_timeout   = health_check_config.value.probe_timeout
      probe_type      = health_check_config.value.probe_type
    }
  }

  # security_group_policy
  dynamic "security_group_policy" {
    for_each = each.value.security_group_policy
    content {
      local_cidr_block  = security_group_policy.value.local_cidr_block
      remote_cidr_block = security_group_policy.value.remote_cidr_block
    }
  }
  tags = each.value.tags
}

################################################################################
# CCN Attachment
################################################################################
resource "tencentcloud_ccn_attachment_v2" "ccn_vpn_attachment" {
  ccn_uin         = var.ccn_uin
  ccn_id          = var.attached_ccn_id
  instance_id     = tencentcloud_vpn_gateway.vpn_gateway.id
  instance_type   = "VPNGW"
  instance_region = var.attached_ccn_region
  description     = var.attached_ccn_description
  route_table_id  = var.route_table_id
}