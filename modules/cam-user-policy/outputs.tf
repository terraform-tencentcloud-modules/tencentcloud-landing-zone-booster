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

output "access_keys" {
  value = { for k, ak in tencentcloud_cam_access_key.access_keys : k => {
    access_key : ak.access_key,
    secret_access_key : nonsensitive(ak.secret_access_key)
  } }
}