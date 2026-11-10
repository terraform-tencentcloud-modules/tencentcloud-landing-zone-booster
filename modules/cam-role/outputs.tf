output "role_id" {
  description = "The unique ID of the CAM role"
  value       = try(tencentcloud_cam_role.role.0.id, null)
}

output "role_name" {
  description = "The name of the CAM role (use this for SCF, CVM, etc. that reference role by name)"
  value       = try(tencentcloud_cam_role.role.0.name, null)
}

output "role_arn" {
  description = "The ARN of the CAM role"
  value       = try(tencentcloud_cam_role.role.0.role_arn, null)
}

output "policy_ids" {
  description = "Map of policy name => policy ID for policies created by this module"
  value       = { for name, policy in tencentcloud_cam_policy.policy : name => policy.id }
}

output "policy_names" {
  description = "List of policy names created by this module"
  value       = [for name, policy in tencentcloud_cam_policy.policy : policy.name]
}
