# Get user information
data "tencentcloud_user_info" "info" {}

locals {
  # app info
  app_id = var.app_id != null ? var.app_id : data.tencentcloud_user_info.info.app_id

  # Resource ARN.
  # COS format: qcs::cos:$region:$account:prefix/$appid/$BucketName
  # CLS format: qcs::cls:$region:$account:cls/topicId
  deliver_target_arn = var.deliver_type == "COS" ? {
    arn = "qcs::cos:${var.region}:${var.account_uin}:prefix/${local.app_id}/${var.cos_bucket}"
  } : {
    arn = "qcs::cls:${var.region}:${var.account_uin}:cls/${tencentcloud_cls_topic.topic[0].id}"
  }
}

resource "tencentcloud_config_aggregator" "this" {
  name        = var.aggregator_name
  description = var.aggregator_description
  type        = var.aggregator_type
  owner_uin   = var.aggregator_owner_uin

  # Member accounts are only relevant for a CUSTOM aggregator. For RD (global)
  # aggregators the members are maintained by the cloud and must not be set here.
  dynamic "aggregator_accounts" {
    for_each = var.aggregator_type == "CUSTOM" ? var.aggregator_accounts : []
    content {
      member_uin  = aggregator_accounts.value.member_uin
      member_name = aggregator_accounts.value.member_name
    }
  }
}

resource "tencentcloud_config_update_aggregate_config_deliver" "this" {
  status               = var.deliver_enabled ? 1 : 0
  account_group_id     = tencentcloud_config_aggregator.this.account_group_id
  target_arn           = local.deliver_target_arn.arn
  deliver_name         = var.deliver_name
  deliver_prefix       = var.deliver_prefix
  deliver_type         = var.deliver_type
  deliver_uin          = var.deliver_uin
  deliver_content_type = var.deliver_content_type

  depends_on = [
    tencentcloud_cam_service_linked_role.role,
    tencentcloud_cos_bucket.bucket,
    tencentcloud_cls_logset.logset,
    tencentcloud_cls_topic.topic
  ]
}