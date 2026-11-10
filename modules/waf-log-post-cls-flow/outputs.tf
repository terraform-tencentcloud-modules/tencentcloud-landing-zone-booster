output "id" {
  description = "ID of the resource."
  value       = tencentcloud_waf_log_post_cls_flow.tc_waf_log_post_cls_flow.id
}

output "flow_id" {
  description = "Unique ID for post cls flow."
  value       = tencentcloud_waf_log_post_cls_flow.tc_waf_log_post_cls_flow.flow_id
}

output "log_topic_id" {
  description = "CLS log topic ID."
  value       = tencentcloud_waf_log_post_cls_flow.tc_waf_log_post_cls_flow.log_topic_id
}

output "logset_id" {
  description = "CLS logset ID."
  value       = tencentcloud_waf_log_post_cls_flow.tc_waf_log_post_cls_flow.logset_id
}

output "status" {
  description = "Status 0-Off 1-On."
  value       = tencentcloud_waf_log_post_cls_flow.tc_waf_log_post_cls_flow.status
}