output "resource_id" {
  value       = tencentcloud_apm_instance.this.instance_id
  description = "APM instance ID."
}

output "token" {
  value       = tencentcloud_apm_instance.this.token
  description = "Business system authentication token."
}

output "public_collector_url" {
  value       = tencentcloud_apm_instance.this.public_collector_url
  description = "External Network Reporting Address."
}