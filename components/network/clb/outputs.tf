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
# Output the listener id of each listener, keyed by its index in var.clb_listeners
output "listener_ids" {
  description = "Map of listener index to listener id."
  value = {
    for idx, listener in tencentcloud_clb_listener.this : idx => listener.listener_id
  }
}

# Output the full attributes of each listener, keyed by its index in var.clb_listeners
output "listeners" {
  description = "Map of listener index to full listener attributes."
  value       = tencentcloud_clb_listener.this
}

################################################################################
### CLB Redirection Outputs
################################################################################
output "redirection_ids" {
  description = "List of clb redirection ids."
  value       = values(tencentcloud_clb_redirection.redirection)[*].id
}

################################################################################
### CLB Customized Config Outputs
################################################################################
output "custom_config_ids" {
  description = "Map of custom config index to config id."
  value = {
    for idx, c in tencentcloud_clb_customized_config.config : idx => c.id
  }
}
