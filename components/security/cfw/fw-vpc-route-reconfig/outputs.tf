output "route_item_ids" {
  value = tencentcloud_route_table_entry.havip_route_entries.*.route_item_id
}