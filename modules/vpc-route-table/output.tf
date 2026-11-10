output "route_table_id" {
  description = "The id of route table."
  value       = tencentcloud_route_table.route_table.id 
}

output "route_entry_ids" {
  description = "The id of route table entry."
  value       = tencentcloud_route_table_entry.route_entries.*.route_item_id
}