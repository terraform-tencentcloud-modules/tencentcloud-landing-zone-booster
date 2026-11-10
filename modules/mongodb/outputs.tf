################################################################################
### MongoDB Outputs
################################################################################
output "mongodb_instance_id" {
  description = "ID of the mongodb instance."
  value       = tencentcloud_mongodb_instance.instance.id
}

output "mongodb_vip" {
  description = "IP of the Mongodb instance."
  value       = tencentcloud_mongodb_instance.instance.vip
}

output "mongodb_port" {
  description = "Port of the Mongodb instance."
  value       = tencentcloud_mongodb_instance.instance.vport
}

output "admin_secret_name" {
  description = "Name of the SSM secret for admin credentials."
  value       = var.store_credentials_in_ssm ? tencentcloud_ssm_secret.mongodb_creds[0].secret_name : null
}

output "user_secret_name" {
  description = "Name of the SSM secret for user credentials."
  value       = var.store_credentials_in_ssm && local.create_user ? tencentcloud_ssm_secret.mongodb_user_creds[0].secret_name : null
}
