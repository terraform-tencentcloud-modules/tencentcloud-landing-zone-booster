output "nat_gateway_id" {
  value = local.nat_gateway_id
}

output "nat_route_ids" {
  description = "Route item IDs (rti-xxxxxxxx format) for publishing to CCN"
  value = {
    for k, route in tencentcloud_route_table_entry.route_entry : k => route.route_item_id
  }
}

output "route_table_id" {
  description = "The main route table ID"
  value       = try(data.tencentcloud_vpc_route_tables.route_tables.instance_list.0.route_table_id, "")
}