################################################################################
# Outputs
################################################################################

output "vpn_instance_id" {
  description = "ID of the created VPN gateway"
  value       = module.vpn_gateway_existing_ccn.vpn_instance_id
}

output "ccn_attachment_id" {
  description = "ID of the CCN attachment"
  value       = module.vpn_gateway_existing_ccn.ccn_attachment_id
}

output "attachment_state" {
  description = "State of the CCN attachment"
  value       = module.vpn_gateway_existing_ccn.attachment_state
}

output "attached_time" {
  description = "Time when the attachment was created"
  value       = module.vpn_gateway_existing_ccn.attached_time
}

output "public_ip_address" {
  description = "Public IP of the VPN gateway"
  value       = module.vpn_gateway_existing_ccn.public_ip_address
}

output "vpn_gateway_state" {
  description = "State of the VPN gateway"
  value       = module.vpn_gateway_existing_ccn.state
}