output "id" {
  description = "ID of the resource."
  value       = tencentcloud_waf_log_post_ckafka_flow.tc_waf_log_post_ckafka_flow.id
}

output "flow_id" {
  description = "Unique ID for post cls flow."
  value       = tencentcloud_waf_log_post_ckafka_flow.tc_waf_log_post_ckafka_flow.flow_id
}

output "status" {
  description = "Status 0- Off 1- On."
  value       = tencentcloud_waf_log_post_ckafka_flow.tc_waf_log_post_ckafka_flow.status
}
