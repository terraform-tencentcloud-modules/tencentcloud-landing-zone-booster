################################################################################
# Outputs
################################################################################

output "vpn_instance_id" {
  description = "ID of the created VPN gateway"
  value       = module.vpn_gateway_basic.vpn_instance_id
}

output "public_ip_address" {
  description = "Public IP address of the VPN gateway"
  value       = module.vpn_gateway_basic.public_ip_address
}

output "vpn_gateway_state" {
  description = "State of the VPN gateway"
  value       = module.vpn_gateway_basic.state
}