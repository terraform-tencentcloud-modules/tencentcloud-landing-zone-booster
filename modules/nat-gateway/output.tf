output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = tencentcloud_nat_gateway.nat_gateway.id
}