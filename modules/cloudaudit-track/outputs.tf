output "cloudaudit_id" {
  value       = join("", tencentcloud_audit_track.cloudaudit.*.id)
  description = "The ID of Cloud Audit Track."
}