output "config_rule_ids" {
  description = "Map of config rule logical name to its config rule ID."
  value = {
    for k, v in tencentcloud_config_rule.this : k => v.config_rule_id
  }
}

output "status" {
  description = "Map of config rule logical name to its status (ACTIVE / UN_ACTIVE)."
  value = {
    for k, v in tencentcloud_config_rule.this : k => v.status
  }
}

output "rule_names" {
  description = "Map of config rule logical name to its rule name."
  value = {
    for k, v in tencentcloud_config_rule.this : k => v.rule_name
  }
}

output "risk_levels" {
  description = "Map of config rule logical name to its risk level."
  value = {
    for k, v in tencentcloud_config_rule.this : k => v.risk_level
  }
}

output "create_time" {
  description = "Map of config rule logical name to its creation time."
  value = {
    for k, v in tencentcloud_config_rule.this : k => v.create_time
  }
}

output "compliance_result" {
  description = "Map of config rule logical name to its compliance result."
  value = {
    for k, v in tencentcloud_config_rule.this : k => v.compliance_result
  }
}

output "config_rule_invoked_time" {
  description = "Map of config rule logical name to its last evaluation time."
  value = {
    for k, v in tencentcloud_config_rule.this : k => v.config_rule_invoked_time
  }
}
