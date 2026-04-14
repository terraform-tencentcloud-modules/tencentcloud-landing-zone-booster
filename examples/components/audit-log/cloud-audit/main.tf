terraform {
  required_version = ">= 1.5.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.81.125"
    }
  }
}

provider "tencentcloud" {
  region = "ap-shanghai"
}

module "cloud_audit" {
  source = "../../../../components/audit-log/cloud-audit"

  cloudaudit_track_name     = "cloud-audit-track"
  cloudaudit_storage_type   = "cls"
  cloudaudit_storage_name   = "cloud-audit-track-1000000001"
  cloudaudit_storage_region = "ap-shanghai"
  cloudaudit_storage_prefix = "cloud-audit-track"

  # cos_bucket_acl      = "private"
  # cos_lifecycle_rules = [
  #   {
  #     filter_prefix = "tf"
  #     transition = [{
  #       days          = 180
  #       storage_class = "STANDARD_IA"
  #     }]
  #   }
  # ]

  cls_logset_name = "cloud-audit-logset"
  cls_logset_tags = {}

  cls_topic_name   = "cloud-audit-topic"
  cls_period       = 180
  cls_describes    = "cloud-audit-topic"
  cls_hot_period   = 180
  cls_topic_tags   = {}
  cls_create_index = false
}