output "compliance_pack_ids" {
  description = "Map of compliance pack logical name to its compliance pack ID."
  value = {
    for k, v in tencentcloud_config_compliance_pack.this : k => v.compliance_pack_id
  }
}

output "status" {
  description = "Map of compliance pack logical name to its status (ACTIVE, UN_ACTIVE)."
  value = {
    for k, v in tencentcloud_config_compliance_pack.this : k => v.status
  }
}