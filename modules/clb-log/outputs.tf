output "logset_id" {
  description = "The ID of the clb logset"
  value       = tencentcloud_clb_log_set.this.id
}

output "logset_name" {
  description = "The ID of the clb logset"
  value       = tencentcloud_clb_log_set.this.name
}

output "log_topic_id" {
  description = "The ID of the clb log topic"
  value       = tencentcloud_clb_log_topic.this.id
}