output "vpn_connection_id" {
  description = "The ID of the VPN connection"
  value       = tencentcloud_vpn_connection.main.id
}

output "customer_gateway_id" {
  description = "The ID of the customer gateway"
  value       = tencentcloud_vpn_customer_gateway.main.id
}

output "vpn_connection_state" {
  description = "The state of the VPN connection"
  value       = tencentcloud_vpn_connection.main.state
}