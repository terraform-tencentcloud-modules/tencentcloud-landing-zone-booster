################################################################################
### EIP Outputs
################################################################################
output "id" {
  description = "The ID of the EIP"
  value       = try(tencentcloud_eip.eip.id, null)
}

output "public_ip" {
  description = "The public IP address of the EIP"
  value       = try(tencentcloud_eip.eip.public_ip, null)
}
