# Get user information
data "tencentcloud_user_info" "info" {}

locals {
  # user info
  app_id     = var.app_id != null ? var.app_id : data.tencentcloud_user_info.info.app_id
  #account_uin = var.account_uin != null ? var.account_uin : data.tencentcloud_user_info.info.uin

  deliver_target_arn = var.deliver_target_type == "COS" ? {
    arn = "qcs::cos:${var.region}:${var.account_uin}:prefix/${local.app_id}/${var.cos_bucket}"
  } : {
    arn = "qcs::cls:${var.region}:${var.account_uin}:cls/${tencentcloud_cls_topic.topic[0].id}"
  }
}

resource "tencentcloud_config_recorder_config" "config" {
  status = var.config_enabled
}

resource "tencentcloud_config_deliver_config" "this" {
  status               = var.deliver_enabled ? 1 : 0
  deliver_name         = var.deliver_name
  deliver_content_type = var.deliver_content_type
  deliver_type         = var.deliver_target_type
  target_arn           = local.deliver_target_arn.arn
  deliver_prefix       = var.deliver_log_prefix

  depends_on = [
    tencentcloud_cam_service_linked_role.role,
    tencentcloud_cos_bucket.bucket,
    tencentcloud_cls_logset.logset,
    tencentcloud_cls_topic.topic
  ]
}