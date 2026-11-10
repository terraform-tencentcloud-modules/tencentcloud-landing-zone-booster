################################################################################
# Route table
################################################################################
resource "tencentcloud_route_table" "route_table" {
  vpc_id = var.vpc_id
  name   = var.route_table_name
  tags   = var.tags
}

resource "tencentcloud_route_table_entry" "route_entries" {
  count = length(var.destination_cidrs)

  route_table_id         = tencentcloud_route_table.route_table.id
  destination_cidr_block = var.destination_cidrs[count.index].destination_cidr
  next_type              = var.destination_cidrs[count.index].next_type
  next_hub               = var.destination_cidrs[count.index].next_hub
}