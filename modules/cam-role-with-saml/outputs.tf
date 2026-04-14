output "saml_provider_id" {
  value       = join("", tencentcloud_cam_saml_provider.saml_provider_basic.*.id)
  description = "The ID of SAML provider."
}

output "role_id" {
  value       = join("", tencentcloud_cam_role.role.*.id)
  description = "The ID of cam role."
}

output "policy_id" {
  value       = join("", tencentcloud_cam_policy.policy.*.id)
  description = "The ID of cam policy."
}