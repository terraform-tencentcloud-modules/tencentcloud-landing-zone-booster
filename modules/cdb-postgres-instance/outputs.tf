output "postgres_endpoint" {
  description = "PostgreSQL instance endpoint"
  value       = "${tencentcloud_postgresql_instance.this.private_access_ip}:${tencentcloud_postgresql_instance.this.private_access_port}"
}

output "postgres_ip" {
  description = "PostgreSQL instance endpoint"
  value       = tencentcloud_postgresql_instance.this.private_access_ip
}

output "postgres_port" {
  description = "PostgreSQL instance port"
  value       = tencentcloud_postgresql_instance.this.private_access_port
}

output "postgres_password" {
  description = "PostgreSQL instance root password"
  value       = try(length(var.password), 0) > 0 ? var.password : random_password.this.0.result
  sensitive   = true
}

output "postgres_id" {
  description = "PostgreSQL instance ID"
  value       = tencentcloud_postgresql_instance.this.id
}

output "ro_group_endpoint" {
  description = "Endpoint of read-only instances group"
  value       = try(length(tencentcloud_postgresql_readonly_group.this), 0) > 0 ? "${tencentcloud_postgresql_readonly_group.this.0.net_info_list.0.ip}:${tencentcloud_postgresql_readonly_group.this.0.net_info_list.0.port}" : null
}

output "ro_instances_endpoint" {
  description = "Endpoint of each read-only instances"
  value = {
    for k, ro_instance in tencentcloud_postgresql_readonly_instance.this :
    k => {
      endpoint = "${ro_instance.private_access_ip}:${ro_instance.private_access_port}"
    }
  }
}

output "database_access" {
  description = "Database access list by account"
  value = {
    for k, user in tencentcloud_postgresql_account.users :
    user.user_name => {
      username = user.user_name
      password = try(length(var.users[k].password), 0) > 0 ? var.users[k].password : random_password.users[k].result
    }
  }
  sensitive = true
}
