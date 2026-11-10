# Output postgresql master instance information
output "instance_id" {
  value       = tencentcloud_postgresql_instance.master.id
  description = "The ID of the PostgreSQL master instance."
}

output "private_ip_address" {
  value       = tencentcloud_postgresql_instance.master.private_access_ip
  description = "the private ip of the PostgreSQL master instance."
}

output "private_port" {
  value       = tencentcloud_postgresql_instance.master.private_access_port
  description = "the priavte port of the PostgreSQL master instance."
}