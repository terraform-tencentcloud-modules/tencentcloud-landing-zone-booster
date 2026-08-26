output "config_id" {
  value       = tencentcloud_config_deliver_config.this.id
  description = "The ID of Cloud Audit Track."
}

output "cos_bucket" {
  value = var.deliver_target_type == "COS" ? tencentcloud_cos_bucket.bucket[0].bucket : null
}

output "cos_bucket_url" {
  value = var.deliver_target_type == "COS" ? tencentcloud_cos_bucket.bucket[0].cos_bucket_url : null
}

output "logset_id" {
  value = var.deliver_target_type == "CLS" ? tencentcloud_cls_logset.logset[0].id : null
}

output "topic_id" {
  value = var.deliver_target_type == "CLS" ? tencentcloud_cls_topic.topic[0].id : null
}

output "index_id" {
  value = var.deliver_target_type == "CLS" && var.cls_create_index ? tencentcloud_cls_index.index[0].id : null
}