output "cluster_id" {
  description = "The ID of the TDMQ for Pulsar professional cluster."
  value       = tencentcloud_tdmq_professional_cluster.this.id
}

output "cluster_name" {
  description = "The name of the TDMQ for Pulsar professional cluster."
  value       = tencentcloud_tdmq_professional_cluster.this.cluster_name
}

output "namespace_ids" {
  description = "Map of namespace name to its composite ID (environ_id#cluster_id)."
  value       = { for k, v in tencentcloud_tdmq_namespace.this : k => v.id }
}

output "role_names" {
  description = "Map of role key to role name."
  value       = { for k, v in tencentcloud_tdmq_role.this : k => v.role_name }
}

output "role_tokens" {
  description = "Map of role key to its authentication token (sensitive)."
  value       = { for k, v in tencentcloud_tdmq_role.this : k => v.token }
  sensitive   = true
}

output "topic_ids" {
  description = "Map of topic key (environ_id/topic_name) to topic ID."
  value       = { for k, v in tencentcloud_tdmq_topic.this : k => v.id }
}

output "subscription_ids" {
  description = "Map of subscription key (environ_id/topic_name/subscription_name) to subscription ID."
  value       = { for k, v in tencentcloud_tdmq_subscription.this : k => v.id }
}

output "namespace_role_attachment_ids" {
  description = "Map of attachment key (environ_id/role_name) to attachment ID."
  value       = { for k, v in tencentcloud_tdmq_namespace_role_attachment.this : k => v.id }
}
