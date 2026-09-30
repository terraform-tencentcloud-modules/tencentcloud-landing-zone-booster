################################################################################
# CKafka Instance outputs
################################################################################
output "instance_ids" {
  description = "The map of CKafka instance IDs keyed by the instance identifier."
  value       = { for k, v in tencentcloud_ckafka_instance.this : k => v.id }
}

output "instance_vips" {
  description = "The map of CKafka instance VIPs keyed by the instance identifier."
  value       = { for k, v in tencentcloud_ckafka_instance.this : k => v.vip }
}

output "instance_vports" {
  description = "The map of CKafka instance vports keyed by the instance identifier."
  value       = { for k, v in tencentcloud_ckafka_instance.this : k => v.vport }
}

################################################################################
# CKafka Topic outputs
################################################################################
output "topic_ids" {
  description = "The map of CKafka topic IDs keyed by the topic identifier."
  value       = { for k, v in tencentcloud_ckafka_topic.this : k => v.id }
}

################################################################################
# CKafka Route outputs
################################################################################
output "route_ids" {
  description = "The map of CKafka route IDs keyed by the route identifier."
  value       = { for k, v in tencentcloud_ckafka_route.this : k => v.id }
}

################################################################################
# CKafka User outputs
################################################################################
output "user_ids" {
  description = "The map of CKafka user IDs keyed by the user identifier."
  value       = { for k, v in tencentcloud_ckafka_user.this : k => v.id }
}

################################################################################
# CKafka ACL outputs
################################################################################
output "acl_ids" {
  description = "The map of CKafka ACL IDs keyed by the ACL identifier."
  value       = { for k, v in tencentcloud_ckafka_acl.this : k => v.id }
}
