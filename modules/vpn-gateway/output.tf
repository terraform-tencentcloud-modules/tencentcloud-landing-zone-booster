output "vpn_instance_id" {
  description = "The Id of VPN Gateway."
  value       = var.create_vpn_gateway ? concat(tencentcloud_vpn_gateway.gateway[*].id, [""])[0] : null
}