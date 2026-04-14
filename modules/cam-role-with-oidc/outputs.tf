output "oidc_sso_id" {
  value       = join("", tencentcloud_cam_role_sso.oidc_sso.*.id)
  description = "The ID of CAM-ROLE-OIDC."
}

output "role_id" {
  value       = join("", tencentcloud_cam_role.role.*.id)
  description = "The ID of cam role."
}

output "policy_id" {
  value       = join("", tencentcloud_cam_policy.policy.*.id)
  description = "The ID of cam policy."
}