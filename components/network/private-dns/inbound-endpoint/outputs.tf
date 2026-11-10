################################################################################
### Private DNS Inbound Endpoint Outputs
################################################################################
output "inbound_endpoint_ids" {
  description = "Map of inbound endpoint keys to their IDs"
  value       = { for k, v in tencentcloud_private_dns_inbound_endpoint.inbound_endpoints : k => v.id }
}

output "inbound_endpoints" {
  description = "Complete Private DNS inbound endpoint resource objects"
  value       = tencentcloud_private_dns_inbound_endpoint.inbound_endpoints
}