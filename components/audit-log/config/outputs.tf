output "deliver_id" {
  description = "Resource id (the account group id)."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.id
}

output "account_group_id" {
  description = "Account group id."
  value       = tencentcloud_config_update_aggregate_config_deliver.this.account_group_id
}

output "cos_bucket" {
  value = var.deliver_type == "COS" ? tencentcloud_cos_bucket.bucket[0].bucket : null
}

output "cos_bucket_url" {
  value = var.deliver_type == "COS" ? tencentcloud_cos_bucket.bucket[0].cos_bucket_url : null
}

output "logset_id" {
  value = var.deliver_type == "CLS" ? tencentcloud_cls_logset.logset[0].id : null
}

output "topic_id" {
  value = var.deliver_type == "CLS" ? tencentcloud_cls_topic.topic[0].id : null
}

output "index_id" {
  value = var.deliver_type == "CLS" && var.cls_create_index ? tencentcloud_cls_index.index[0].id : null
}