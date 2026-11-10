output "remediation_ids" {
  description = "Map of remediation logical name to its remediation setting ID."
  value = {
    for k, v in tencentcloud_config_remediation.this : k => v.remediation_id
  }
}

output "owner_uins" {
  description = "Map of remediation logical name to its owner account UIN."
  value = {
    for k, v in tencentcloud_config_remediation.this : k => v.owner_uin
  }
}

output "remediation_source_types" {
  description = "Map of remediation logical name to its remediation source type returned from API."
  value = {
    for k, v in tencentcloud_config_remediation.this : k => v.remediation_source_type
  }
}

output "rule_ids" {
  description = "Map of remediation logical name to its bound config rule ID."
  value = {
    for k, v in tencentcloud_config_remediation.this : k => v.rule_id
  }
}

output "remediation_types" {
  description = "Map of remediation logical name to its remediation type."
  value = {
    for k, v in tencentcloud_config_remediation.this : k => v.remediation_type
  }
}

output "invoke_types" {
  description = "Map of remediation logical name to its invocation mode."
  value = {
    for k, v in tencentcloud_config_remediation.this : k => v.invoke_type
  }
}

output "source_types" {
  description = "Map of remediation logical name to its template source type."
  value = {
    for k, v in tencentcloud_config_remediation.this : k => v.source_type
  }
}
