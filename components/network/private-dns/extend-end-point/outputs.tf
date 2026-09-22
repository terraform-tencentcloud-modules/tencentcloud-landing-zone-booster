################################################################################
### Private DNS Extend End Point Outputs
################################################################################
output "extend_end_point_ids" {
  description = "Map of extend end point keys to their IDs"
  value       = { for k, v in tencentcloud_private_dns_extend_end_point.extend_end_points : k => v.id }
}

output "extend_end_points" {
  description = "Complete Private DNS extend end point resource objects"
  value       = tencentcloud_private_dns_extend_end_point.extend_end_points
}