output "logset_id" {
  value = tencentcloud_cls_logset.logset.id
}

output "topic_id" {
  value = tencentcloud_cls_topic.topic.id
}

output "index_id" {
  value = var.create_index ? tencentcloud_cls_index.index[0].id : null
}