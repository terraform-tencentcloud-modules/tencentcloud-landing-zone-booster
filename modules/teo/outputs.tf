###############################################################################
### EdgeOne outputs
###############################################################################
output "zone_id" {
  description = "ID of the EO Zone"
  value       = tencentcloud_teo_zone.zone.id
}

output "zone_ownership_verification" {
  description = "Ownership verification information"
  value       = tencentcloud_teo_zone.zone.ownership_verification
}

output "zone_status" {
  description = "Site status"
  value       = tencentcloud_teo_zone.zone.status
}

output "l7_acc_setting_id" {
  description = "ID of the L7 acceleration setting"
  value       = length(var.l7_acc_setting) > 0 ? tencentcloud_teo_l7_acc_setting.l7_acc_setting[0].id : null
}
