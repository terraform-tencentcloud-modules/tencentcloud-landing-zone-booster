# Output the ID of the clb instance
output "clb_id" {
  description = "The ID of the clb instance."
  value       = tencentcloud_clb_instance.instance.id
}

output "clb_name" {
  description = "The ID of the clb instance."
  value       = var.clb_name
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
  value       = var.create_clb_log && var.log_set_id == "" ? "${tencentcloud_clb_log_set.set[0].id}" : var.log_set_id
  description = "The id of log set."
}

output "clb_log_topic_id" {
  value       = var.create_clb_log && var.log_topic_id == "" ? "${tencentcloud_clb_log_topic.topic[0].id}" : var.log_topic_id
  description = "The id of log topic."
}