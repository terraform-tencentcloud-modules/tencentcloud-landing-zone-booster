output "target_group_id" {
  description = "The ID of the target group"
  value       = tencentcloud_clb_target_group.this.id
}

output "target_group_name" {
  description = "The name of the target group"
  value       = tencentcloud_clb_target_group.this.target_group_name
}