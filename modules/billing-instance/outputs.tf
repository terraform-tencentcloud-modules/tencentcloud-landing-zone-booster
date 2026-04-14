output "instance_id" {
  description = "计费实例 ID"
  value       = tencentcloud_billing_instance.this.instance_id
}

output "billing_instance" {
  description = "计费实例完整信息"
  value       = tencentcloud_billing_instance.this
}
