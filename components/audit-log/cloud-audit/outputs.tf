output "cloudaudit_id" {
  value       = tencentcloud_audit_track.track.id
  description = "The ID of Cloud Audit Track."
}

output "cos_bucket" {
  value = var.cloudaudit_storage_type == "cos" ? tencentcloud_cos_bucket.bucket[0].bucket : null
}

output "cos_bucket_url" {
  value = var.cloudaudit_storage_type == "cos" ? tencentcloud_cos_bucket.bucket[0].cos_bucket_url : null
}

output "logset_id" {
  value = var.cloudaudit_storage_type == "cls" ? tencentcloud_cls_logset.logset[0].id : null
}

output "topic_id" {
  value = var.cloudaudit_storage_type == "cls" ? tencentcloud_cls_topic.topic.id : null
}

output "index_id" {
  value = var.cloudaudit_storage_type == "cls" && var.cls_create_index ? tencentcloud_cls_index.index[0].id : null
}