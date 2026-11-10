output "id" {
  description = "The ID of the resource."
  value       = tencentcloud_organization_instance.organization.id
}

output "create_time" {
  description = "Organize the creation time."
  value       = tencentcloud_organization_instance.organization.create_time
}

output "host_uin" {
  description = "The UIN of the host/creator"
  value       = tencentcloud_organization_instance.organization.host_uin
}

output "is_allow_quit" {
  description = "Whether a member is allowed to quit."
  value       = tencentcloud_organization_instance.organization.is_allow_quit
}

output "is_assign_manager" {
  description = "Whether there is a trusted service administrator."
  value       = tencentcloud_organization_instance.organization.is_assign_manager
}

output "is_auth_manager" {
  description = "Whether there is a real-named administrator."
  value       = tencentcloud_organization_instance.organization.is_auth_manager
}

output "is_manager" {
  description = "Whether there is an organizational administrator."
  value       = tencentcloud_organization_instance.organization.is_manager
}

output "join_time" {
  description = "Members join time."
  value       = tencentcloud_organization_instance.organization.join_time
}

output "nick_name" {
  description = "Creator nickname."
  value       = tencentcloud_organization_instance.organization.nick_name
}

output "org_id" {
  description = "The ID of the organization created."
  value       = tencentcloud_organization_instance.organization.org_id
}

output "org_permission" {
  description = "List of membership authority of members."
  value       = tencentcloud_organization_instance.organization.org_permission
}

output "org_policy_name" {
  description = "Strategic name."
  value       = tencentcloud_organization_instance.organization.org_policy_name
}

output "org_policy_type" {
  description = "Strategic type."
  value       = tencentcloud_organization_instance.organization.org_policy_type
}

output "org_type" {
  description = "Enterprise organization type."
  value       = tencentcloud_organization_instance.organization.org_type
}

output "pay_name" {
  description = "The name of the payment."
  value       = tencentcloud_organization_instance.organization.pay_name
}

output "pay_uin" {
  description = "UIN on behalf of the payer."
  value       = tencentcloud_organization_instance.organization.pay_uin
}

output "root_node_id" {
  description = "Organize the root node ID."
  value       = tencentcloud_organization_instance.organization.root_node_id
}