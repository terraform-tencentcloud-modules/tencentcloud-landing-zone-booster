output "alarm_policy_ids" {
  description = "Map of alarm policy logical name to its resource id."
  value = {
    for k, v in tencentcloud_config_alarm_policy.this : k => v.id
  }
}

output "alarm_policy_unique_ids" {
  description = "Map of alarm policy logical name to its unique alarm policy id."
  value = {
    for k, v in tencentcloud_config_alarm_policy.this : k => v.alarm_policy_id
  }
}

output "names" {
  description = "Map of alarm policy logical name to its name."
  value = {
    for k, v in tencentcloud_config_alarm_policy.this : k => v.name
  }
}

output "status" {
  description = "Map of alarm policy logical name to its status (1 enabled, 2 disabled)."
  value = {
    for k, v in tencentcloud_config_alarm_policy.this : k => v.status
  }
}
