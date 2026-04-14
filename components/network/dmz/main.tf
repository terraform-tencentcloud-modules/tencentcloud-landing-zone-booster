data "tencentcloud_ccn_instances" "ccn" {
  name = var.ccn_name
}

locals {
  ccn_id = var.ccn_id != null ? var.ccn_id : var.ccn_name != null ? data.tencentcloud_ccn_instances.ccn.instance_list[0].ccn_id : null

  vpc_infos = [
    {
      instance_name = var.vpc_inbound_name
      instance_id   = tencentcloud_vpc.vpc_inbound.id
      instance_type = "VPC"
    },
    {
      instance_name = var.vpc_outbound_name
      instance_id   = tencentcloud_vpc.vpc_outbound.id
      instance_type = "VPC"
    }
  ]
}

# Create inbound VPC
resource "tencentcloud_vpc" "vpc_inbound" {
  name         = var.vpc_inbound_name
  cidr_block   = var.vpc_inbound_cidr
  is_multicast = var.vpc_inbound_is_multicast
  dns_servers  = var.vpc_inbound_dns_servers
  tags         = merge(var.vpc_inbound_tags, var.vpc_common_tags)
}

resource "tencentcloud_subnet" "vpc_inbound_subnet" {
  count = length(var.vpc_inbound_subnet_cidrs)
  
  vpc_id            = tencentcloud_vpc.vpc_inbound.id
  name              = var.vpc_inbound_subnet_cidrs[count.index].subnet_name
  cidr_block        = var.vpc_inbound_subnet_cidrs[count.index].subnet_cidr
  is_multicast      = var.vpc_inbound_subnet_cidrs[count.index].subnet_is_multicast
  availability_zone = var.vpc_inbound_subnet_cidrs[count.index].availability_zone
  route_table_id    = tencentcloud_vpc.vpc_inbound.default_route_table_id
  tags              = merge(var.vpc_inbound_subnet_tags, var.vpc_common_tags)

  depends_on = [ tencentcloud_vpc.vpc_inbound ]
}

# Create outbound VPC
resource "tencentcloud_vpc" "vpc_outbound" {
  name         = var.vpc_outbound_name
  cidr_block   = var.vpc_outbound_cidr
  is_multicast = var.vpc_outbound_is_multicast
  dns_servers  = var.vpc_outbound_dns_servers
  tags         = merge(var.vpc_outbound_tags, var.vpc_common_tags)
}

resource "tencentcloud_subnet" "vpc_outbound_subnet" {
  count = length(var.vpc_outbound_subnet_cidrs)
  
  vpc_id            = tencentcloud_vpc.vpc_outbound.id
  name              = var.vpc_outbound_subnet_cidrs[count.index].subnet_name
  cidr_block        = var.vpc_outbound_subnet_cidrs[count.index].subnet_cidr
  is_multicast      = var.vpc_outbound_subnet_cidrs[count.index].subnet_is_multicast
  availability_zone = var.vpc_outbound_subnet_cidrs[count.index].availability_zone
  route_table_id    = tencentcloud_vpc.vpc_outbound.default_route_table_id
  tags              = merge(var.vpc_outbound_subnet_tags, var.vpc_common_tags)

  depends_on = [ tencentcloud_vpc.vpc_outbound ]
}

# Create NAT gateway
resource "tencentcloud_nat_gateway" "nat" {
  vpc_id              = tencentcloud_vpc.vpc_outbound.id
  name                = var.nat_gateway_name
  bandwidth           = var.nat_product_version == 2 ? null : var.nat_gateway_bandwidth
  max_concurrent      = var.nat_product_version == 2 ? null : var.nat_gateway_concurrent
  assigned_eip_set    = length(var.nat_public_ips) > 0 ? var.nat_public_ips : tencentcloud_eip.eips.*.public_ip
  nat_product_version = var.nat_product_version
  tags                = var.nat_tags

  depends_on = [ tencentcloud_vpc.vpc_outbound ]
}

resource "tencentcloud_eip" "eips" {
  count = length(var.nat_eips)
  
  name                       = var.nat_eips[count.index]
  internet_max_bandwidth_out = var.nat_internet_max_bandwidth_out
}

resource "tencentcloud_nat_gateway_flow_monitor" "nat_flow_monitor" {
  enable     = var.nat_enable_flow_monitor
  gateway_id = tencentcloud_nat_gateway.nat.id
}

resource "tencentcloud_ccn_attachment_v2" "attachment" {
  for_each = { for vpc in local.vpc_infos : vpc.instance_name => vpc}

  ccn_uin         = var.ccn_uin
  ccn_id          = local.ccn_id
  instance_region = var.vpc_region
  instance_id     = each.value.instance_id
  instance_type   = each.value.instance_type
  description     = var.attachment_description

  depends_on = [
    tencentcloud_vpc.vpc_inbound,
    tencentcloud_vpc.vpc_outbound
  ]
}