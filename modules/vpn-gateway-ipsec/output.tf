output "vpn_customer_gateway_id" {
  description = "The Id of VPN customer gateway."
  value       = concat(tencentcloud_vpn_customer_gateway.customer_gateway[*].id, [""])[0]
}

output "vpn_connection_id" {
  description = "The Id of VPN Connnection."
  value       = concat(tencentcloud_vpn_connection.connection[*].id, [""])[0]
}

output "vpn_gateway_route" {
  description = "The Id of VPN Route."
  value       = concat(tencentcloud_vpn_gateway_route.vpn_gateway_route[*].id, [""])[0]
}