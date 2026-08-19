################################################################################
#### Outputs
################################################################################
output "preset_policy_attachments" {
  description = "Exist Policy Attachments"
  value       = { for k, v in tencentcloud_identity_center_role_configuration_permission_policy_attachment.attachment : k => v.id }
}

output "custom_policy_attachments" {
  description = "Custom Policy Attachments"
  value       = { for k, v in tencentcloud_identity_center_role_configuration_permission_custom_policy_attachment.custom_policies : k => v.id }
}
