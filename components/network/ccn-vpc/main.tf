locals {
  vpc_subnets = [for s in tencentcloud_subnet.subnet : {
    subnet_id   = s.id
    subnet_name = s.name
    subnet_az   = s.availability_zone
    subnet_cidr = s.cidr_block
  }]
}

################################################################################
# VPC
################################################################################
resource "tencentcloud_vpc" "vpc" {
  name         = var.vpc_name
  cidr_block   = var.vpc_cidr
  is_multicast = var.vpc_is_multicast
  dns_servers  = try(length(var.vpc_dns_servers), 0) > 0 ? var.vpc_dns_servers : null
  tags         = merge(var.tags, var.vpc_tags)
}

################################################################################
# VPC Subnet
################################################################################
resource "tencentcloud_subnet" "subnet" {
  count = length(var.subnet_cidrs)
  
  vpc_id            = tencentcloud_vpc.vpc.id
  name              = var.subnet_cidrs[count.index].subnet_name
  cidr_block        = var.subnet_cidrs[count.index].subnet_cidr
  is_multicast      = var.subnet_cidrs[count.index].subnet_is_multicast
  availability_zone = var.subnet_cidrs[count.index].availability_zone
  tags              = merge(var.tags, var.subnet_cidrs[count.index].tags)

  depends_on = [ tencentcloud_vpc.vpc ]
}

################################################################################
# CCN attachment
################################################################################
resource "tencentcloud_ccn_attachment_v2" "attachment" {
  ccn_uin         = var.ccn_uin
  ccn_id          = var.ccn_id
  instance_id     = tencentcloud_vpc.vpc.id
  instance_type   = "VPC"
  instance_region = var.instance_region
  description     = var.attachment_desc
  route_table_id  = var.route_table_id

  depends_on = [ tencentcloud_vpc.vpc ]
}