################################################################################
# Outputs
################################################################################

output "vpn_instance_id" {
  description = "ID of the created VPN gateway"
  value       = module.vpn_gateway_with_ccn.vpn_instance_id
}

output "ccn_id" {
  description = "ID of the created CCN"
  value       = module.vpn_gateway_with_ccn.ccn_id
}

output "ccn_attachment_id" {
  description = "ID of the CCN attachment"
  value       = module.vpn_gateway_with_ccn.ccn_attachment_id
}

output "ccn_instance_count" {
  description = "Number of instances attached to CCN"
  value       = module.vpn_gateway_with_ccn.ccn_instance_count
}

output "public_ip_address" {
  description = "Public IP of the VPN gateway"
  value       = module.vpn_gateway_with_ccn.public_ip_address
}

output "vpn_gateway_state" {
  description = "State of the VPN gateway"
  value       = module.vpn_gateway_with_ccn.state
}