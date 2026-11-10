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
  dns_servers  = length(var.vpc_dns_servers) > 0 ? var.vpc_dns_servers : null
  tags         = merge(var.tags, var.vpc_tags)
}

################################################################################
# Subnet
################################################################################
resource "tencentcloud_subnet" "subnet" {
  count = length(var.subnet_cidrs)
  
  vpc_id            = tencentcloud_vpc.vpc.id
  name              = var.subnet_cidrs[count.index].subnet_name
  cidr_block        = var.subnet_cidrs[count.index].subnet_cidr
  is_multicast      = var.subnet_cidrs[count.index].subnet_is_multicast
  availability_zone = var.subnet_cidrs[count.index].availability_zone
  tags              = merge(var.tags, var.subnet_tags)
}