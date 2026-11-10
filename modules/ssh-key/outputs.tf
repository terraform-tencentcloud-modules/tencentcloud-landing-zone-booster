output "key_id" {
  description = "ID of SSH key pairs"
  value       = tencentcloud_key_pair.ssh_key_pair.id
}

output "public_key" {
  description = "public key"
  value       = tencentcloud_key_pair.ssh_key_pair.public_key
  sensitive   = true
}

output "private_key" {
  description = "private key"
  value       = tencentcloud_key_pair.ssh_key_pair.private_key
  sensitive   = true
}

output "create_time" {
  description = "create_time"
  value       = tencentcloud_key_pair.ssh_key_pair.created_time
}


output "secret_id" {
  description = "ID of the SSM secret storing the SSH key pair"
  value       = length(tencentcloud_ssm_secret.secret) > 0 ? tencentcloud_ssm_secret.secret[0].id : null
}

