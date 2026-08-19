output "nat_gateway_id" {
  description = "The IDs of the NAT Gateways, keyed by the nat_gateways input key"
  value       = { for k, ng in tencentcloud_nat_gateway.nat_gateway : k => ng.id }
}

output "nat_gateway_eips" {
  description = "The IDs and PublicIP of the created EIPs, keyed by <nat_gateway_key>:<index>"
  value       = { for k, eip in tencentcloud_eip.eip : k => {
    id        = eip.id
    public_ip = eip.public_ip
  }}
}