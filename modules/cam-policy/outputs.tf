output "id" {
  description = "The policy's ID"
  value       = try(tencentcloud_cam_policy.this[0].id, "")
}
