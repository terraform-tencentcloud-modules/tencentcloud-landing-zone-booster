output "role_arn" {
  description = "cam role arn"
  value       = tencentcloud_cam_role.role.role_arn
}

output "policy_ids" {
  description = "cam user policy ids"
  value       = { for policy in local.user_policies : policy.policy_name => policy.policy_id }
}