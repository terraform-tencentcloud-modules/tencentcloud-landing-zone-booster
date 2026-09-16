################################################################################
### Private DNS End Point Outputs
################################################################################
output "end_point_ids" {
  description = "Map of end point keys to their IDs"
  value       = { for k, v in tencentcloud_private_dns_end_point.end_points : k => v.id }
}

output "end_points" {
  description = "Complete Private DNS end point resource objects"
  value       = tencentcloud_private_dns_end_point.end_points
}