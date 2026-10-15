output "deliver_config_id" {
  description = "The id of the delivery configuration (a generated token, not the cloud resource id)."
  value       = tencentcloud_config_deliver_config.this.id
}

output "status" {
  description = "Delivery switch. 0 (disabled), 1 (enabled)."
  value       = tencentcloud_config_deliver_config.this.status
}

output "deliver_name" {
  description = "Delivery service name."
  value       = tencentcloud_config_deliver_config.this.deliver_name
}

output "target_arn" {
  description = "Resource ARN of the delivery target (COS or CLS)."
  value       = tencentcloud_config_deliver_config.this.target_arn
}

output "deliver_type" {
  description = "Delivery type. COS or CLS."
  value       = tencentcloud_config_deliver_config.this.deliver_type
}

output "deliver_content_type" {
  description = "Delivery content type. 1 (configuration change), 2 (resource list), 3 (all)."
  value       = tencentcloud_config_deliver_config.this.deliver_content_type
}

output "create_time" {
  description = "Creation time of the delivery configuration."
  value       = tencentcloud_config_deliver_config.this.create_time
}
