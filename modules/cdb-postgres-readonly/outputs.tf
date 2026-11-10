################################################################################
### PostgreSQL Readonly Outputs
################################################################################
output "ro_group_id" {
  description = "The ID of the PostgreSQL readonly group."
  value       = tencentcloud_postgresql_readonly_group.ro_group.id
}

output "ro_group_net_info_list" {
  description = "The network info list of the PostgreSQL readonly group."
  value       = tencentcloud_postgresql_readonly_group.ro_group.net_info_list
}

output "ro_instance_ids" {
  description = "The IDs of the PostgreSQL readonly instances."
  value       = { for k, v in tencentcloud_postgresql_readonly_instance.ro : k => v.instance_id }
}

output "ro_private_access_ips" {
  description = "The private access IPs of the PostgreSQL readonly instances."
  value       = { for k, v in tencentcloud_postgresql_readonly_instance.ro : k => v.private_access_ip }
}

output "ro_private_access_ports" {
  description = "The private access ports of the PostgreSQL readonly instances."
  value       = { for k, v in tencentcloud_postgresql_readonly_instance.ro : k => v.private_access_port }
}
