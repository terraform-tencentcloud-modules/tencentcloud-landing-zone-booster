data "tencentcloud_availability_zones_by_product" "cvm" {
  product = "cvm"
  name    = var.vpc_region
}

data "tencentcloud_vpc_route_tables" "default" {
  vpc_id           = var.vpc_id
  association_main = true
}

locals {
  create_vpc         = try(var.create_vpc, true)
  custom_route_table = var.create_route_table == false || local.create_vpc ? false : length(var.destination_cidrs) > 0
  # Get all availability zones if not config the availability_zones value
  availability_zones = length(var.availability_zones) > 0 ? var.availability_zones : data.tencentcloud_availability_zones_by_product.cvm.zones.*.name
  # Get route_table_id
  default_route_table_id = local.create_vpc ? tencentcloud_vpc.vpc[0].default_route_table_id : try(data.tencentcloud_vpc_route_tables.default.instance_list[0].route_table_id, null)
  custom_route_table_id  = local.custom_route_table ? tencentcloud_route_table.route_table[0].id : local.default_route_table_id
  route_table_id = var.route_table_id != "" ? var.route_table_id : local.custom_route_table_id
}

################################################################################
# VPC
################################################################################
resource "tencentcloud_vpc" "vpc" {
  count = local.create_vpc ? 1 : 0

  name         = var.vpc_name
  cidr_block   = var.vpc_cidr
  is_multicast = var.vpc_is_multicast
  dns_servers  = length(var.vpc_dns_servers) > 0 ? var.vpc_dns_servers : null
  tags         = merge(var.tags, var.vpc_tags)
}

################################################################################
# Subnet
################################################################################
resource "tencentcloud_subnet" "subnet" {
  count = length(var.subnet_cidrs)
  
  vpc_id            = var.vpc_id != "" ? var.vpc_id : tencentcloud_vpc.vpc[0].id
  name              = var.subnet_cidrs[count.index].subnet_name
  cidr_block        = var.subnet_cidrs[count.index].subnet_cidr
  is_multicast      = var.subnet_cidrs[count.index].subnet_is_multicast
  availability_zone = try(var.subnet_cidrs[count.index].availability_zone, null) != null ? var.subnet_cidrs[count.index].availability_zone : local.availability_zones[count.index % length(local.availability_zones)]
  route_table_id    = local.route_table_id
  tags              = merge(var.tags, var.subnet_tags)
}

################################################################################
# Route table
################################################################################
resource "tencentcloud_route_table" "route_table" {
  count = local.custom_route_table ? 1 : 0

  name   = var.route_table_name != "" ? var.route_table_name : "rt-${var.default_subnet_name}"
  vpc_id = var.vpc_id != "" ? var.vpc_id : tencentcloud_vpc.vpc[0].id
  tags = merge(
    var.tags,
    var.route_table_tags
  )
}

resource "tencentcloud_route_table_entry" "route_entry" {
  count = length(var.destination_cidrs)

  route_table_id         = local.route_table_id
  destination_cidr_block = var.destination_cidrs[count.index]
  next_type              = var.next_type[count.index]
  next_hub               = var.next_type[count.index] == "NAT" && var.enable_nat_gateway && var.next_hub[count.index] == "0" ? tencentcloud_nat_gateway.nat[0].id : var.next_type[count.index] == "VPN" && var.enable_vpn_gateway && var.next_hub[count.index] == "0" ? tencentcloud_vpn_gateway.vpn[0].id : var.next_hub[count.index]
}

################################################################################
# VPN Gateway
################################################################################
resource "tencentcloud_vpn_gateway" "vpn" {
  count = var.enable_vpn_gateway ? 1 : 0

  name           = var.vpn_gateway_name != "" ? var.vpn_gateway_name : "vpngw-${var.default_subnet_name}"
  type           = var.vpn_gateway_type
  vpc_id         = var.vpc_id != "" ? var.vpc_id : tencentcloud_vpc.vpc[0].id
  bandwidth      = var.vpn_gateway_bandwidth
  max_connection = var.vpn_gateway_max_connection
  zone           = var.vpn_gateway_availability_zone != "" ? var.vpn_gateway_availability_zone : local.availability_zones[0]

  tags = merge(
    var.tags,
    var.vpn_gateway_tags,
  )
}


################################################################################
# Network ACL
################################################################################
resource "tencentcloud_vpc_acl" "acl" {
  count = var.manage_network_acl ? 1 : 0

  vpc_id  = var.vpc_id != "" ? var.vpc_id : tencentcloud_vpc.vpc[0].id
  name    = var.network_acl_name != "" ? var.network_acl_name : "acl-${var.default_subnet_name}"
  ingress = var.network_acl_ingress
  egress  = var.network_acl_egress

  tags = merge(
    var.tags,
    var.network_acl_tags,
  )
}

resource "tencentcloud_vpc_acl_attachment" "attachment" {
  count = var.manage_network_acl ? length(tencentcloud_subnet.subnet) : 0

  acl_id    = tencentcloud_vpc_acl.acl[0].id
  subnet_id = tencentcloud_subnet.subnet[count.index].id
}

################################################################################
# NAT Gateway
################################################################################
resource "tencentcloud_eip" "nat_eip" {
  count = var.enable_nat_gateway && length(var.nat_public_ips) == 0 ? 1 : 0

  name  = var.nat_eip_name != "" ? var.nat_eip_name : "nateip-${var.default_subnet_name}"
  tags = merge(
    var.tags,
    var.nat_gateway_tags
  )
}

resource "tencentcloud_nat_gateway" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  name             = var.nat_gateway_name != "" ? var.nat_gateway_name : "natgw-${var.default_subnet_name}"
  vpc_id           = var.vpc_id != "" ? var.vpc_id : tencentcloud_vpc.vpc[0].id
  bandwidth        = var.nat_gateway_bandwidth
  max_concurrent   = var.nat_gateway_concurrent
  assigned_eip_set = length(var.nat_public_ips) > 0 ? var.nat_public_ips : tencentcloud_eip.nat_eip.*.public_ip

  tags = merge(
    var.tags,
    var.nat_gateway_tags
  )
}

################################################################################
# Attachment VPC to CCN
################################################################################
resource "tencentcloud_ccn_attachment_v2" "ccn_attachment" {
  count = var.create_ccn_attachment ? 1 : 0
  
  ccn_id  = var.ccn_id
  ccn_uin = var.ccn_uin

  instance_id     = var.vpc_id != "" ? var.vpc_id : tencentcloud_vpc.vpc[0].id
  instance_type   = "VPC"
  instance_region = var.vpc_region
  route_table_id  = var.ccn_route_table_id

  lifecycle {
    ignore_changes = [
      description
    ]
  }
}