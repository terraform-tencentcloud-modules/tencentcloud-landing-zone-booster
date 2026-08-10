data "tencentcloud_ccn_instances" "ccn" {
  name = var.ccn_name
}

locals {
  ccn_id = var.ccn_id != null ? var.ccn_id : var.ccn_name != null ? data.tencentcloud_ccn_instances.ccn.instance_list.0.ccn_id : null
}

resource "tencentcloud_vpc" "vpc" {
  name         = var.name
  cidr_block   = var.cidr
  is_multicast = var.is_multicast
  dns_servers  = var.dns_servers
  tags         = merge(var.tags, var.common_tags)
}

resource "tencentcloud_subnet" "subnets" {
  count = length(var.subnet_cidrs)
  
  vpc_id            = tencentcloud_vpc.vpc.id
  name              = var.subnet_cidrs[count.index].subnet_name
  cidr_block        = var.subnet_cidrs[count.index].subnet_cidr
  is_multicast      = var.subnet_cidrs[count.index].subnet_is_multicast
  availability_zone = var.subnet_cidrs[count.index].availability_zone
  route_table_id    = tencentcloud_vpc.vpc.default_route_table_id
  tags              = merge(var.subnet_tags, var.common_tags)

  depends_on = [ tencentcloud_vpc.vpc ]
}

resource "tencentcloud_ccn_attachment_v2" "attachment" {
  ccn_uin         = var.ccn_uin
  ccn_id          = local.ccn_id
  instance_id     = tencentcloud_vpc.vpc.id
  instance_type   = "VPC"
  instance_region = var.region
  description     = var.attachment_desc
  route_table_id  = var.route_table_id

  depends_on = [ tencentcloud_vpc.vpc ]
}