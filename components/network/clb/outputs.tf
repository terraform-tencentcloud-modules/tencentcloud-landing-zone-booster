################################################################################
### CLB Instance Outputs
################################################################################
# Output the ID of the clb instance
output "clb_id" {
  description = "The ID of the clb instance."
  value       = tencentcloud_clb_instance.instance.id
}

# Output the virtual service address table of the CLB
output "clb_vips" {
  description = "The virtual service address table of the CLB."
  value       = tencentcloud_clb_instance.instance.clb_vips
}

# Output the domain name of the CLB instance
output "clb_domain" {
  description = "Domain name of the CLB instance."
  value       = tencentcloud_clb_instance.instance.domain
}

output "clb_log_set_id" {
  value       = local.log_set_id
  description = "The id of log set."
}

output "clb_log_topic_id" {
  value       = local.log_topic_id
  description = "The id of log topic."
}

################################################################################
### CLB Listener Outputs
################################################################################

################################################################################
### CLB Listener Rule Outputs
################################################################################


################################################################################
### CLB Redirection Outputs
################################################################################


################################################################################
### CLB Attachment Outputs
################################################################################
