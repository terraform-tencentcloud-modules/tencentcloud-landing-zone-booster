locals {
  # Flatten eips across all nat gateways so each EIP can be created separately.
  # Key format: "<ng_key>:<index>" so we can map the created EIP back to its gateway.
  eip_flat = flatten([
    for ng_key, ng in var.nat_gateways : [
      for eip in coalesce(ng.eips, []) : {
        key    = eip.name
        ng_key = ng_key
        config = eip
      }
    ]
  ])
}

################################################################################
# EIP Resource (only created when a nat gateway's public_ips is empty)
################################################################################
resource "tencentcloud_eip" "eip" {
  for_each = { for e in local.eip_flat : e.key => e }

  name                       = each.value.config.name
  type                       = each.value.config.type
  internet_charge_type       = each.value.config.internet_charge_type
  internet_max_bandwidth_out = each.value.config.internet_max_bandwidth_out
  internet_service_provider  = each.value.config.internet_service_provider
  prepaid_period             = each.value.config.prepaid_period
  auto_renew_flag            = each.value.config.auto_renew_flag
  bandwidth_package_id       = each.value.config.bandwidth_package_id
  egress                     = each.value.config.egress
  anycast_zone               = each.value.config.anycast_zone
  anti_ddos_package_id       = each.value.config.anti_ddos_package_id

  tags = var.eip_tags
}

################################################################################
# NAT Gateway
################################################################################
resource "tencentcloud_nat_gateway" "nat_gateway" {
  for_each = var.nat_gateways

  vpc_id           = var.vpc_id
  name             = each.value.name
  zone             = each.value.zone

  # Use provided public_ips if not empty; otherwise use the EIPs created above.
  assigned_eip_set = length(coalesce(each.value.public_ips, [])) > 0 ? each.value.public_ips : [
    for e in local.eip_flat : tencentcloud_eip.eip[e.key].public_ip if e.ng_key == each.key
  ]

  # Standard NAT (product_version=2) specific settings
  nat_product_version                     = each.value.product_version
  stock_public_ip_addresses_bandwidth_out = each.value.product_version == 2 ? each.value.public_bandwidth_out : null

  # Traditional NAT (product_version=1) specific settings
  bandwidth      = each.value.product_version == 1 ? each.value.bandwidth : null
  max_concurrent = each.value.product_version == 1 ? each.value.max_concurrent : null

  tags = var.nat_tags
}

################################################################################
# NAT Gateway Flow Monitor (only when enable_flow_monitor is true)
################################################################################
resource "tencentcloud_nat_gateway_flow_monitor" "nat_flow_monitor" {
  for_each = { for k, v in var.nat_gateways : k => v if v.enable_flow_monitor }

  gateway_id = tencentcloud_nat_gateway.nat_gateway[each.key].id
  enable     = each.value.enable_flow_monitor
}