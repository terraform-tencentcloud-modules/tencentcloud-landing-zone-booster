output "vpc_id" {
  description = "The id of vpc."
  value       = tencentcloud_vpc.vpc.id
}

output "subnet_ids" {
  description = "The id of subnet."
  value       = tencentcloud_subnet.subnets.*.id
}

output "subnet_names" {
  description = "The id of subnet."
  value       = { for subnet in tencentcloud_subnet.subnets : subnet.name => subnet.id }
}

output "route_table_id" {
  description = "The id of route table."
  value       = tencentcloud_vpc.vpc.default_route_table_id
}