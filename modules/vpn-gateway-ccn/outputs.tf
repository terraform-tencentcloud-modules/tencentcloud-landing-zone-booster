################################################################################
# VPN Gateway Outputs
################################################################################
output "vpn_gateway_id" {
  description = "The ID of VPN Gateway"
  value       = tencentcloud_vpn_gateway.tc_vpn_gateway.id
}

output "create_time" {
  description = "Create time of the VPN gateway"
  value       = tencentcloud_vpn_gateway.tc_vpn_gateway.create_time
}

output "expired_time" {
  description = "Expired time of the VPN gateway (PREPAID only)"
  value       = tencentcloud_vpn_gateway.tc_vpn_gateway.expired_time
}

output "is_address_blocked" {
  description = "Indicates whether IP address is blocked"
  value       = tencentcloud_vpn_gateway.tc_vpn_gateway.is_address_blocked
}

output "new_purchase_plan" {
  description = "The plan of new purchase"
  value       = tencentcloud_vpn_gateway.tc_vpn_gateway.new_purchase_plan
}

output "public_ip_address" {
  description = "Public IP of the VPN gateway"
  value       = tencentcloud_vpn_gateway.tc_vpn_gateway.public_ip_address
}

output "restrict_state" {
  description = "Restrict state of gateway"
  value       = tencentcloud_vpn_gateway.tc_vpn_gateway.restrict_state
}

output "state" {
  description = "State of the VPN gateway"
  value       = tencentcloud_vpn_gateway.tc_vpn_gateway.state
}

################################################################################
# CCN Outputs
################################################################################
output "ccn_id" {
  description = "The ID of CCN"
  value       = local.create_ccn ? concat(tencentcloud_ccn.tc_ccn[*].id, [""])[0] : null
}

output "ccn_state" {
  description = "State of the CCN"
  value       = local.create_ccn ? concat(tencentcloud_ccn.tc_ccn[*].state, [""])[0] : null
}

output "ccn_create_time" {
  description = "Create time of the CCN"
  value       = local.create_ccn ? concat(tencentcloud_ccn.tc_ccn[*].create_time, [""])[0] : null
}

# output "ccn_route_ids" {
#   description = "Route id list"
#   value       = local.attach_ccn ? concat(tencentcloud_ccn.tc_ccn[*].route_ids, [""])[0] : null
# }

output "ccn_instance_count" {
  description = "Number of attached instances"
  value       = local.create_ccn ? concat(tencentcloud_ccn.tc_ccn[*].instance_count, [""])[0] : null
}

################################################################################
# CCN Attachment Outputs
################################################################################

output "ccn_attachment_id" {
  description = "ID of the CCN attachment"
  value       = local.attach_ccn ? concat(tencentcloud_ccn_attachment_v2.tc_ccn_vpn_attachment[*].id, [""])[0] : null
}

output "attached_time" {
  description = "Time of attaching"
  value       = local.attach_ccn ? concat(tencentcloud_ccn_attachment_v2.tc_ccn_vpn_attachment[*].attached_time, [""])[0] : null
}

output "cidr_block" {
  description = "A network address block of the instance that is attached"
  value       = local.attach_ccn ? concat(tencentcloud_ccn_attachment_v2.tc_ccn_vpn_attachment[*].cidr_block, [""])[0] : null
}

output "ccn_attachment_route_ids" {
  description = "Route id list"
  value       = local.attach_ccn ? concat(tencentcloud_ccn_attachment_v2.tc_ccn_vpn_attachment[*].route_ids, [""])[0] : null
}

output "attachment_state" {
  description = "States of instance is attached. Valid values: PENDING, ACTIVE, EXPIRED, REJECTED, DELETED, FAILED, ATTACHING, DETACHING and DETACHFAILED. FAILED means asynchronous forced disassociation after 2 hours. DETACHFAILED means asynchronous forced disassociation after 2 hours."
  value       = local.attach_ccn ? concat(tencentcloud_ccn_attachment_v2.tc_ccn_vpn_attachment[*].state, [""])[0] : null
}

################################################################################
# Custom Gateway Outputs
################################################################################
output "customer_gateway_id" {
  description = "The ID of Customer Gateway"
  value       = tencentcloud_vpn_customer_gateway.tc_vpn_customer_gateway.id
}

output "customer_gateway_create_time" {
  description = "Create time of the customer gateway."
  value       = tencentcloud_vpn_customer_gateway.tc_vpn_customer_gateway.create_time
}

################################################################################
# VPN Connection Outputs
################################################################################
output "vpn_connection_id" {
  description = "ID of the resource."
  value       = tencentcloud_vpn_connection.tc_vpn_connection.id
}

output "vpn_connection_create_time" {
  description = "Create time of the VPN connection."
  value       = tencentcloud_vpn_connection.tc_vpn_connection.create_time
}

output "vpn_connection_encrypt_proto" {
  description = "Encrypt proto of the VPN connection."
  value       = tencentcloud_vpn_connection.tc_vpn_connection.encrypt_proto
}

output "vpn_connection_is_ccn_type" {
  description = "Indicate whether is ccn type. Modification of this field only impacts force new logic of vpc_id. If is_ccn_type is true, modification of vpc_id will be ignored."
  value       = tencentcloud_vpn_connection.tc_vpn_connection.is_ccn_type
}

output "vpn_connection_net_status" {
  description = "Net status of the VPN connection. Valid value: AVAILABLE."
  value       = tencentcloud_vpn_connection.tc_vpn_connection.net_status
}

output "vpn_connection_state" {
  description = "State of the connection. Valid value: PENDING, AVAILABLE, DELETING."
  value       = tencentcloud_vpn_connection.tc_vpn_connection.state
}

output "vpn_connection_vpn_proto" {
  description = "Vpn proto of the VPN connection."
  value       = tencentcloud_vpn_connection.tc_vpn_connection.vpn_proto
}