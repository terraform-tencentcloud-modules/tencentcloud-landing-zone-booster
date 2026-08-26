# Get user information
data "tencentcloud_user_info" "info" {}

locals {
  # user info
  app_id     = var.app_id != null ? var.app_id : data.tencentcloud_user_info.info.app_id
  # account_uin = var.account_uin != null ? var.account_uin : data.tencentcloud_user_info.info.uin
  # cos bucket name
  bucket = "${var.cloudaudit_storage_name}-${local.app_id}"

  # audit track storage policy
  region = var.cloudaudit_storage_region
}

resource "tencentcloud_audit_track" "track" {
  name                  = var.cloudaudit_track_name
  action_type           = var.cloudaudit_action_type
  event_names           = var.cloudaudit_event_names
  resource_type         = var.cloudaudit_resource_type
  status                = var.cloudaudit_track_status
  track_for_all_members = var.cloudaudit_track_for_all_members

  storage {
    storage_type       = var.cloudaudit_storage_type
    storage_name       = var.cloudaudit_storage_type == "cos" ? local.bucket : tencentcloud_cls_topic.topic[0].id
    storage_prefix     = var.cloudaudit_storage_prefix
    storage_region     = var.cloudaudit_storage_region
    storage_account_id = var.account_uin
    storage_app_id     = local.app_id
  }

  depends_on = [
    tencentcloud_cam_role.role,
    tencentcloud_cos_bucket.bucket,
    tencentcloud_cls_logset.logset,
    tencentcloud_cls_topic.topic
  ]
}