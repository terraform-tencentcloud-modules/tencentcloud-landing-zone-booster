# Waf instance output
output "waf_clb_id" {
  value = tencentcloud_waf_clb_instance.this.id
}

output "waf_clb_instance_id" {
  value = tencentcloud_waf_clb_instance.this.instance_id
}

output "waf_clb_edition" {
  value = tencentcloud_waf_clb_instance.this.edition
}

output "waf_clb_status" {
  value = tencentcloud_waf_clb_instance.this.status
}

output "waf_clb_begin_time" {
  value = tencentcloud_waf_clb_instance.this.begin_time
}

output "waf_clb_valid_time" {
  value = tencentcloud_waf_clb_instance.this.valid_time
}

# Waf domain output
output "domain_instance_ids" {
  value = tencentcloud_waf_clb_domain.waf_clb_domain.*.id
}

output "domain_ids" {
  value = tencentcloud_waf_clb_domain.waf_clb_domain.*.domain_id
}

# Waf log post cls flow output
output "log_post_cls_id" {
  description = "ID of the resource."
  value       = tencentcloud_waf_log_post_cls_flow.log_post_cls_flow.id
}

output "log_post_cls_flow_id" {
  description = "Unique ID for post cls flow."
  value       = tencentcloud_waf_log_post_cls_flow.log_post_cls_flow.flow_id
}

output "log_post_cls_log_topic_id" {
  description = "CLS log topic ID."
  value       = tencentcloud_waf_log_post_cls_flow.log_post_cls_flow.log_topic_id
}

output "log_post_cls_logset_id" {
  description = "CLS logset ID."
  value       = tencentcloud_waf_log_post_cls_flow.log_post_cls_flow.logset_id
}

output "log_post_cls_status" {
  description = "Status 0-Off 1-On."
  value       = tencentcloud_waf_log_post_cls_flow.log_post_cls_flow.status
}

output "attack_log_post_config_id" {
  description = "ID of the resource."
  value       = tencentcloud_waf_instance_attack_log_post_config.attack_log_post_config.id
}