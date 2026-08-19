################################################################################
# NAT Gateway
################################################################################
resource "tencentcloud_nat_gateway" "nat_gateway" {
  vpc_id           = var.vpc_id
  name             = var.nat_gateway_name
  assigned_eip_set = var.nat_gateway_eips
  zone             = var.nat_gateway_zone

  # Standard NAT (product_version=2) specific settings
  nat_product_version = var.nat_product_version

  # Traditional NAT (product_version=1) specific settings
  bandwidth      = var.nat_product_version == 1 ? var.nat_gateway_bandwidth : null
  max_concurrent = var.nat_product_version == 1 ? var.nat_gateway_concurrent : null

  stock_public_ip_addresses_bandwidth_out = var.nat_product_version == 2 ? var.stock_public_ip_addresses_bandwidth_out : null

  tags = var.tags
}

resource "tencentcloud_nat_gateway_flow_monitor" "nat_flow_monitor" {
  count = var.enable_flow_monitor ? 1 : 0

  gateway_id = tencentcloud_nat_gateway.nat_gateway.id
  enable     = var.enable_flow_monitor
}