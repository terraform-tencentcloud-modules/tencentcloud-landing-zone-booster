resource "tencentcloud_audit_track" "cloudaudit" {
  name          = var.track_name
  action_type   = var.action_type
  resource_type = var.resource_type
  event_names   = var.event_names
  status        = var.status
  storage {
    storage_type       = var.storage_type
    storage_region     = var.storage_region
    storage_name       = var.storage_name
    storage_prefix     = var.storage_prefix
    storage_account_id = var.storage_account_id
    storage_app_id     = var.storage_app_id
  }
  track_for_all_members = var.track_for_all_members

  depends_on = [
    tencentcloud_cam_role.role,
    tencentcloud_cam_role_policy_attachment.role_policies,
  ]
}