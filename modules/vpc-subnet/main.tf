################################################################################
# Subnet
################################################################################
resource "tencentcloud_subnet" "subnet" {
  vpc_id            = var.vpc_id
  name              = var.subnet_name
  cidr_block        = var.subnet_cidr
  is_multicast      = var.subnet_is_multicast
  availability_zone = var.availability_zone
  route_table_id    = var.route_table_id
  tags              = merge(var.tags, var.subnet_tags)
}