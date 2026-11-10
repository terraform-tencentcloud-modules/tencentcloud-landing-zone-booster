locals {
  has_vpc = var.vpc_id != null && var.vpc_id != ""
  route_next_type = "HAVIP"
  # get vpc default route table
  default_routetable = local.has_vpc ? [ for rt in data.tencentcloud_vpc_route_tables.route_tables.instance_list : rt ][0] : null
  # get ccn route entry infos
  ccn_route_entries = local.default_routetable != null ? [ for rei in local.default_routetable.route_entry_infos : rei if rei.next_type == "CCN" ] : []
  # route item count
  route_count = length(local.ccn_route_entries)
}

# get vpc route tables
data "tencentcloud_vpc_route_tables" "route_tables" {
  vpc_id           = var.vpc_id
  association_main = true
}

# enbaled or disable ccn route entries
resource "tencentcloud_route_table_entry_config" "entry_config" {
  count = local.route_count

  route_table_id = local.default_routetable.route_table_id
  route_item_id  = local.ccn_route_entries[count.index].route_item_id
  disabled       = true
}

# create new HAVIP route entry for ccn
resource "tencentcloud_route_table_entry" "havip_route_entries" {
  count = local.route_count

  route_table_id         = local.default_routetable.route_table_id
  next_type              = local.route_next_type
  next_hub               = var.gateway_id
  destination_cidr_block = local.ccn_route_entries[count.index].destination_cidr_block
  description            = local.ccn_route_entries[count.index].description

  depends_on = [ tencentcloud_route_table_entry_config.entry_config ]
}

# publish route entry to ccn
resource "tencentcloud_vpc_notify_routes" "publish_to_ccn" {
  count = local.route_count

  route_table_id = local.default_routetable.route_table_id
  route_item_ids = [tencentcloud_route_table_entry.havip_route_entries[count.index].route_item_id]

  depends_on = [tencentcloud_route_table_entry.havip_route_entries]
}