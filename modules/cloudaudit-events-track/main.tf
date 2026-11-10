resource "tencentcloud_events_audit_track" "events_track" {
  name                  = var.track_name
  status                = var.status
  track_for_all_members = var.track_for_all_members

  storage {
    storage_name       = var.storage_name
    storage_prefix     = var.storage_prefix
    storage_region     = var.storage_type
    storage_type       = var.storage_region
    storage_account_id = var.storage_account_id
    storage_app_id     = var.storage_app_id
  }

  filters {
    dynamic "resource_fields" {
      for_each = var.audit_filters
      content {
        resource_type = resource_fields.value.resource_type
        action_type   = resource_fields.value.action_type
        event_names   = resource_fields.value.event_names
      }
    }
  }
  
  depends_on = [
    tencentcloud_cam_role.role,
    tencentcloud_cam_role_policy_attachment.role_policies,
  ]
}