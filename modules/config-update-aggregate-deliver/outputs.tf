output "id" {
  description = "Resource id (the account group id)."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.id
}

output "account_group_id" {
  description = "Account group id."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.account_group_id
}

output "status" {
  description = "Delivery switch (0 disabled / 1 enabled)."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.status
}

output "deliver_name" {
  description = "Delivery service name."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.deliver_name
}

output "target_arn" {
  description = "Target resource ARN (COS or CLS)."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.target_arn
}

output "deliver_type" {
  description = "Delivery type (COS / CLS)."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.deliver_type
}

output "deliver_prefix" {
  description = "Log prefix for stored delivery content."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.deliver_prefix
}

output "deliver_uin" {
  description = "Cross-account delivery member uin (0 = administrator account)."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.deliver_uin
}

output "deliver_content_type" {
  description = "Delivery content type (1 / 2 / 3)."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.deliver_content_type
}

output "create_time" {
  description = "Creation time."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.create_time
}
