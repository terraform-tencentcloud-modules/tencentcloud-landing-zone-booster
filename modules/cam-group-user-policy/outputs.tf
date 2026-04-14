output "group_ids" {
  value       = { for group_name, group in tencentcloud_cam_group.groups : group_name => group.id }
  description = "group ids"
}

output "user_ids" {
  value       = { for user_name, user in tencentcloud_cam_user.users : user_name => user.id }
  description = "user ids"
}
output "user_passwords" {
  value       = { for user_name, user in tencentcloud_cam_user.users : user_name => nonsensitive(user.password) }
  description = "user passwords"
  //  sensitive = true
}

output "policy_ids" {
  value       = { for name, policy in tencentcloud_cam_policy.policies : name => policy.id }
  description = "policy ids"
}
