output "vpn_gateway_id" {
  description = "The ID of VPN Gateway"
  value       = tencentcloud_vpn_gateway.vpn_gateway.id
}

output "customer_gateway_id" {
  description = "The ID of Customer Gateway"
  value       = tencentcloud_vpn_customer_gateway.vpn_customer_gateway.id
}

output "vpn_connection_id" {
  description = "ID of the resource."
  value       = tencentcloud_vpn_connection.vpn_connection.id
}