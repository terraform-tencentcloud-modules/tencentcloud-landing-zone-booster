###############################################################################
### Edgeone Zone domain outputs
###############################################################################
output "id" {
  description = "ID of the acceleration domain"
  value       = try(tencentcloud_teo_acceleration_domain.domain[0].id, null)
}

output "cname" {
  description = "CNAME address of the acceleration domain"
  value       = try(tencentcloud_teo_acceleration_domain.domain[0].cname, null)
}
