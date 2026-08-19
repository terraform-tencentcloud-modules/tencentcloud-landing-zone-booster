###############################################################################
# CCN Outputs
###############################################################################
output "ccn_id" {
  description = "The Id of CCN."
  value       = tencentcloud_ccn.instance.id
}

output "ccn_name" {
  description = "The name of CCN name"
  value       = tencentcloud_ccn.instance.name
}

output "ccn_state" {
  description = "The state of CCN state"
  value       = tencentcloud_ccn.instance.state
}

output "ccn_instance_metering_type" {
  description = "Billing mode of the CCN instance (BANDWIDTH or TRAFFIC)"
  value       = tencentcloud_ccn.instance.instance_metering_type
}

output "ccn_route_table_ids" {
  description = "The IDs of CCN route tables"
  value       = { for k, v in tencentcloud_ccn_route_table.route_tables : v.name => v.id }
}

output "ccn_attached_instance_ids" {
  description = "The IDs of attached instances"
  value       = [for v in tencentcloud_ccn_attachment_v2.attachments : v.instance_id]
}

################################################################################
### CCN Cross-account Attachment Management Outputs (for_each based)
################################################################################
output "ccn_accepted_attachments" {
  description = "All accepted cross-account attachments (map of key => details)"
  value       = [for k, v in tencentcloud_ccn_instances_accept_attach.accept_attaches : k]
}

output "ccn_rejected_attachments" {
  description = "All rejected cross-account attachments (map of key => details)"
  value       = [for k, v in tencentcloud_ccn_instances_reject_attach.reject_attaches : k]
}

output "ccn_reset_attachments" {
  description = "All reset cross-account attachments (map of key => details)"
  value       = [for k, v in tencentcloud_ccn_instances_reset_attach.reset_attaches : k]
}