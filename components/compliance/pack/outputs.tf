output "compliance_pack_id" {
  description = "The ID of the created custom compliance pack."
  value       = tencentcloud_config_compliance_pack.pack.id
}

output "compliance_pack_name" {
  description = "The name of the created custom compliance pack."
  value       = tencentcloud_config_compliance_pack.pack.compliance_pack_name
}

output "risk_level" {
  description = "The risk level of the created custom compliance pack."
  value       = tencentcloud_config_compliance_pack.pack.risk_level
}

output "description" {
  description = "The description of the created custom compliance pack."
  value       = tencentcloud_config_compliance_pack.pack.description
}

output "status" {
  description = "The status of the created custom compliance pack."
  value       = tencentcloud_config_compliance_pack.pack.status
}

output "rule_count" {
  description = "The number of rules applied to the created custom compliance pack."
  value       = length(tencentcloud_config_compliance_pack.pack.config_rules)
}