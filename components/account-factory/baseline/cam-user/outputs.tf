output "user_uin" {
  description = "cam user uin"
  value       = tencentcloud_cam_user.user.uin
}

output "user_passwords" {
  description = "cam user password"
  value       = nonsensitive(tencentcloud_cam_user.user.password)
  // sensitive = true
}

output "policy_ids" {
  description = "cam user policy ids"
  value       = { for policy in local.user_policies : policy.policy_name => policy.policy_id }
}

output "access_key" {
  description = "cam user access key"
  value = {
    secret_id  : try(tencentcloud_cam_access_key.aksk[0].access_key, ""),
    secret_key : nonsensitive(try(tencentcloud_cam_access_key.aksk[0].secret_access_key, ""))
  }
}