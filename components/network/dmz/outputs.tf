output "inbound_vpc_id" {
  description = "The id of vpc."
  value       = tencentcloud_vpc.vpc_inbound.id
}

output "outbound_vpc_id" {
  description = "The id of vpc."
  value       = tencentcloud_vpc.vpc_outbound.id
}

output "nat_gateway_id" {
  description = "The id of vpc."
  value       = tencentcloud_nat_gateway.nat.id
}