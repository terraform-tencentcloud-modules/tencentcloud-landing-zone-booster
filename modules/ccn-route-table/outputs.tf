output "route_table_id" {
  description = "The ID of the CCN route table"
  value       = tencentcloud_ccn_route_table.route_table.id
}