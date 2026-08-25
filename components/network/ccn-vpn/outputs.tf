output "vpn_gateway_id" {
  description = "The ID of VPN Gateway"
  value       = tencentcloud_vpn_gateway.vpn_gateway.id
}

output "vpn_gateway_public_ip" {
  description = "The ID of VPN Gateway"
  value       = tencentcloud_vpn_gateway.vpn_gateway.public_ip_address
}

output "customer_gateway_id" {
  description = "The ID of Customer Gateway"
  value       = { for k, v in tencentcloud_vpn_customer_gateway.vpn_customer_gateway : k => v.id }
}

output "vpn_connection_id" {
  description = "ID of the resource."
  value       = { for k, v in tencentcloud_vpn_connection.vpn_connection : k => v.id }
}