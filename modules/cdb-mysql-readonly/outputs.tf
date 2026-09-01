################################################################################
### MySQL Readonly Outputs
################################################################################
locals {
  # Merge all instances for output
  all_instances = merge(
    { for k, v in tencentcloud_mysql_readonly_instance.ro_first : local.first_key => v },
    { for k, v in tencentcloud_mysql_readonly_instance.ro_remaining : k => v }
  )
}

output "ro_group_id" {
  description = "The RO group ID (shared by all readonly instances)."
  value       = length(tencentcloud_mysql_readonly_instance.ro_first) > 0 ? tencentcloud_mysql_readonly_instance.ro_first[0].ro_group_id : null
}

output "ro_instance_ids" {
  description = "The IDs of the MySQL readonly instances."
  value       = { for k, v in local.all_instances : k => v.id }
}

output "ro_intranet_ips" {
  description = "The intranet IPs of the MySQL readonly instances."
  value       = { for k, v in local.all_instances : k => v.intranet_ip }
}

output "ro_intranet_ports" {
  description = "The intranet ports of the MySQL readonly instances."
  value       = { for k, v in local.all_instances : k => v.intranet_port }
}

output "ro_status" {
  description = "The status of the MySQL readonly instances."
  value       = { for k, v in local.all_instances : k => v.status }
}
