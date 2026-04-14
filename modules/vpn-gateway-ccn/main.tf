

################################################################################
# Locals
################################################################################
locals {
  create_ccn = var.create_ccn
  attach_ccn = var.attach_ccn
}

################################################################################
# VPN GATEWAY
################################################################################
resource "tencentcloud_vpn_gateway" "tc_vpn_gateway" {
  name               = var.vpn_gateway_name
  bandwidth          = var.bandwidth
  zone               = try(var.zone, null)
  type               = try(var.type, "IPSEC")
  charge_type        = try(var.charge_type, "POSTPAID_BY_HOUR")
  prepaid_period     = try(var.charge_type, "POSTPAID_BY_HOUR") == "PREPAID" ? try(var.prepaid_period, 1) : null
  prepaid_renew_flag = try(var.charge_type, "POSTPAID_BY_HOUR") == "PREPAID" ? try(var.prepaid_renew_flag, "NOTIFY_AND_AUTO_RENEW") : null
  max_connection     = try(var.max_connection, null)
  tags               = var.vpn_tags

  # v2新增参数
  bgp_asn = try(var.bgp_asn, null)
  cdc_id  = try(var.cdc_id, null)
}

################################################################################
# CCN
################################################################################
resource "tencentcloud_ccn" "tc_ccn" {
  count                = local.create_ccn ? 1 : 0
  name                 = var.ccn_name
  bandwidth_limit_type = var.bandwidth_limit_type
  charge_type          = var.ccn_charge_type
  description          = var.ccn_description != "" ? var.ccn_description : null
  qos                  = var.qos
  route_ecmp_flag      = var.route_ecmp_flag
  route_overlap_flag   = var.route_overlap_flag
  tags                 = var.ccn_tags
}

################################################################################
# CCN Attachment
################################################################################
resource "tencentcloud_ccn_attachment_v2" "tc_ccn_vpn_attachment" {
  count           = local.attach_ccn ? 1 : 0
  ccn_id          = var.ccn_id != null && var.ccn_id != "" ? var.ccn_id : (local.create_ccn ? tencentcloud_ccn.tc_ccn[0].id : null)
  instance_id     = var.instance_id != null ? var.instance_id : tencentcloud_vpn_gateway.tc_vpn_gateway.id
  instance_type   = var.instance_type
  instance_region = var.instance_region != "" ? var.instance_region : null
  ccn_uin         = var.ccn_uin != "" ? var.ccn_uin : null
  description     = var.attachment_description
  route_table_id  = var.route_table_id
}

################################################################################
# Customer Gateway
################################################################################
resource "tencentcloud_vpn_customer_gateway" "tc_vpn_customer_gateway" {
  name              = var.customer_gateway_name
  public_ip_address = var.customer_gateway_public_ip_address
  bgp_asn           = var.customer_gateway_bgp_asn
  tags              = var.customer_gateway_tags

  lifecycle {
    ignore_changes = [
      bgp_asn # Cannot modify BGP ASN after BGP tunnel is created
    ]
  }
}

################################################################################
# VPN Connection
################################################################################
resource "tencentcloud_vpn_connection" "tc_vpn_connection" {
  name                = var.vpn_connection_name
  vpn_gateway_id      = tencentcloud_vpn_gateway.tc_vpn_gateway.id
  customer_gateway_id = var.vpn_connection_customer_gateway_id != "" ? var.vpn_connection_customer_gateway_id : tencentcloud_vpn_customer_gateway.tc_vpn_customer_gateway.id
  pre_share_key       = var.vpn_connection_pre_share_key
  route_type          = var.vpn_connection_route_type
  negotiation_type    = var.vpn_connection_negotiation_type

  # BGP Configuration - Enabled when the route type is BGP
  dynamic "bgp_config" {
    for_each = var.vpn_connection_route_type == "Bgp" && var.vpn_connection_bgp_config != null ? var.vpn_connection_bgp_config : []
    content {
      local_bgp_ip  = bgp_config.value.local_bgp_ip
      remote_bgp_ip = bgp_config.value.remote_bgp_ip
      tunnel_cidr   = bgp_config.value.tunnel_cidr
    }
  }

  dpd_action  = var.vpn_connection_dpd_action
  dpd_enable  = var.vpn_connection_dpd_enable
  dpd_timeout = var.vpn_connection_dpd_timeout

  # IKE setting
  ike_proto_encry_algorithm  = var.vpn_connection_ike_proto_encry_algorithm
  ike_proto_authen_algorithm = var.vpn_connection_ike_proto_authen_algorithm
  ike_local_identity         = var.vpn_connection_ike_local_identity
  ike_exchange_mode          = var.vpn_connection_ike_exchange_mode
  ike_local_address          = tencentcloud_vpn_gateway.tc_vpn_gateway.public_ip_address
  ike_remote_identity        = var.vpn_connection_ike_remote_identity
  ike_remote_address         = var.vpn_connection_ike_remote_address
  ike_dh_group_name          = var.vpn_connection_ike_dh_group_name
  ike_sa_lifetime_seconds    = var.vpn_connection_ike_sa_lifetime_seconds
  ike_local_fqdn_name        = var.vpn_connection_ike_local_fqdn_name
  ike_remote_fqdn_name       = var.vpn_connection_ike_remote_fqdn_name
  ike_version                = var.vpn_connection_ike_version

  # IPSEC setting
  ipsec_encrypt_algorithm   = var.vpn_connection_ipsec_encrypt_algorithm
  ipsec_integrity_algorithm = var.vpn_connection_ipsec_integrity_algorithm
  ipsec_sa_lifetime_seconds = var.vpn_connection_ipsec_sa_lifetime_seconds
  ipsec_pfs_dh_group        = var.vpn_connection_ipsec_pfs_dh_group
  ipsec_sa_lifetime_traffic = var.vpn_connection_ipsec_sa_lifetime_traffic

  # health check setting
  enable_health_check    = var.vpn_connection_enable_health_check
  health_check_local_ip  = var.vpn_connection_health_check_local_ip
  health_check_remote_ip = var.vpn_connection_health_check_remote_ip

  # health_check_config
  dynamic "health_check_config" {
    for_each = var.vpn_connection_health_check_config != null ? [var.vpn_connection_health_check_config] : []
    content {
      probe_interval  = health_check_config.value.probe_interval
      probe_threshold = health_check_config.value.probe_threshold
      probe_timeout   = health_check_config.value.probe_timeout
      probe_type      = health_check_config.value.probe_type
    }
  }

  # security_group_policy
  dynamic "security_group_policy" {
    for_each = var.vpn_connection_security_group_policy
    content {
      local_cidr_block  = security_group_policy.value.local_cidr_block
      remote_cidr_block = security_group_policy.value.remote_cidr_block
    }
  }
  tags = var.vpn_connection_tags
}
