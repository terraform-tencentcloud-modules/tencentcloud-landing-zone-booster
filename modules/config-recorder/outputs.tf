output "recorder_config_id" {
  description = "The id of the recorder configuration (a generated token, not the cloud resource id)."
  value       = tencentcloud_config_recorder_config.this.id
}

output "status" {
  description = "Whether resource monitoring is enabled."
  value       = tencentcloud_config_recorder_config.this.status
}

output "resource_types" {
  description = "Resource type list being monitored."
  value       = tencentcloud_config_recorder_config.this.resource_types
}

output "create_time" {
  description = "Recorder creation time."
  value       = tencentcloud_config_recorder_config.this.create_time
}

output "trigger_count" {
  description = "Number of snapshots taken today."
  value       = tencentcloud_config_recorder_config.this.trigger_count
}

output "open_count" {
  description = "Number of times monitoring was opened today."
  value       = tencentcloud_config_recorder_config.this.open_count
}

output "update_count" {
  description = "Number of monitoring range updates today."
  value       = tencentcloud_config_recorder_config.this.update_count
}
