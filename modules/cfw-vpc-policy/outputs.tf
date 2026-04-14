output "policy_ids" {
  description = "Map of policy IDs"
  value       = { for k, v in tencentcloud_cfw_vpc_policy.policies : k => v.id }
}
