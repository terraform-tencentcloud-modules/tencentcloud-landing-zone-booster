# Get members information
#data "tencentcloud_organization_members" "members" {}

# Get user information
data "tencentcloud_user_info" "info" {}

locals {
  policies  = [
    "102693096", "18150187", "12031968", "1242979", "596170", "244869", "243334", "219851", "186457"]

  # user info
  app_id     = var.app_id != null ? var.app_id : data.tencentcloud_user_info.info.app_id
  account_id = var.account_id != null ? var.account_id : data.tencentcloud_user_info.info.uin
  # cos bucket name
  bucket = "${var.cloudaudit_storage_name}-${local.app_id}"

  # audit track storage policy
  region = var.cloudaudit_storage_region
}

resource "tencentcloud_cam_role" "role" {
  name          = "CloudAudit_QCSRole"
  document      = <<EOF
  {
    "version": "2.0",
    "statement": [
      {
        "action": ["name/sts:AssumeRole"],
        "effect": "allow",
        "principal": {
          "service": "cloudaudit.cloud.tencent.com"
        }
      }
    ]
  }
  EOF
  description   = "Cloud Audit permissions (including but not limited to): CAM(QcloudCamReadOnlyAccess );CVM(QcloudCVMReadOnlyAccess);VPC(QcloudVPCReadOnlyAccess);MySQL(QcloudCDBInnerReadOnlyAccess);CLB(QcloudCLBReadOnlyAccess);AS(QcloudASReadOnlyAccess);COS(QcloudCOSReadOnlyAccess,put bucket);CMQ(add/query queue); KMS(add/query key)."
  console_login = true
  tags          = var.tags
}

resource "tencentcloud_cam_role_policy_attachment" "role_policies" {
  count = length(local.policies)

  role_id   = tencentcloud_cam_role.role.id
  policy_id = local.policies[count.index]

  depends_on = [
    tencentcloud_cam_role.role,
  ]
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
    storage_name       = var.cloudaudit_storage_type == "cos" ? local.bucket : tencentcloud_cls_topic.topic.id
    storage_prefix     = var.cloudaudit_storage_prefix
    storage_region     = var.cloudaudit_storage_region
    storage_account_id = local.account_id
    storage_app_id     = local.app_id
  }

  depends_on = [
    tencentcloud_cam_role.role,
    tencentcloud_cam_role_policy_attachment.role_policies,
    tencentcloud_cos_bucket.bucket,
    tencentcloud_cls_logset.logset,
    tencentcloud_cls_topic.topic
  ]
}

resource "tencentcloud_cos_bucket" "bucket" {
  count = var.cloudaudit_storage_type == "cos" ? 1 : 0

  bucket            = local.bucket
  acl               = var.cos_bucket_acl
  multi_az          = var.cos_multi_az
  versioning_enable = var.cos_versioning_enable
  force_clean       = var.cos_force_clean
  tags              = var.cos_tags

  dynamic "lifecycle_rules" {
    for_each = var.cos_lifecycle_rules
    content {
      id            = lifecycle_rules.value.id
      filter_prefix = lifecycle_rules.value.filter_prefix

      dynamic "expiration" {
        for_each = lifecycle_rules.value.expiration != null ? [lifecycle_rules.value.expiration] : []
        content {
          days          = try(expiration.value.days, null)
          date          = try(expiration.value.date, null)
          delete_marker = try(expiration.value.delete_marker, null)
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rules.value.transition
        content {
          days          = try(transition.value.days, null)
          date          = try(transition.value.date, null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "non_current_expiration" {
        for_each = lifecycle_rules.value.non_current_expiration != null ? [lifecycle_rules.value.non_current_expiration] : []
        content {
          non_current_days = non_current_expiration.value.non_current_days
        }
      }

      dynamic "non_current_transition" {
        for_each = lifecycle_rules.value.non_current_transition
        content {
          non_current_days = non_current_transition.value.non_current_days
          storage_class    = non_current_transition.value.storage_class
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = lifecycle_rules.value.abort_incomplete_multipart_upload != null ? [lifecycle_rules.value.abort_incomplete_multipart_upload] : []
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
        }
      }
    }
  }
}

resource "tencentcloud_cos_bucket_policy" "cos_bucket_policy" {
  count = var.cloudaudit_storage_type == "cos" ? 1 : 0

  bucket = local.bucket
  policy = jsonencode({
    "version": "2.0",
    "Statement": [
      {
        "Principal": {
          "service": [
            "cloudaudit.cloud.tencent.com"
          ]
        },
        "Action": [
          "cos:*"
        ],
        "Effect": "allow",
        "Resource": [
          "qcs::cos:${local.region}:uid/${local.app_id}:${local.bucket}-${local.app_id}/*"
        ]
      }
    ]
  })

  depends_on = [ tencentcloud_cos_bucket.bucket ]
}

resource "tencentcloud_cls_logset" "logset" {
  count = var.cloudaudit_storage_type == "cls" ? 1 : 0

  logset_name   = var.cls_logset_name
  tags          = var.cls_logset_tags
}

resource "tencentcloud_cls_topic" "topic" {
  logset_id            = tencentcloud_cls_logset.logset[0].id
  topic_name           = var.cloudaudit_storage_name
  partition_count      = var.cls_partition_count
  auto_split           = var.cls_auto_split
  max_split_partitions = var.cls_max_split_partitions
  period               = var.cls_period
  storage_type         = var.cls_storage_type
  hot_period           = var.cls_hot_period
  is_web_tracking      = var.cls_is_web_tracking
  encryption           = var.cls_encryption
  describes            = var.cls_describes
  tags                 = var.cls_topic_tags

  depends_on = [ tencentcloud_cls_logset.logset ]
}

resource "tencentcloud_cls_index" "index" {
  count = var.cls_create_index ? 1 : 0

  topic_id                = tencentcloud_cls_topic.topic.id
  status                  = var.cls_index_status
  include_internal_fields = var.cls_include_internal_fields
  metadata_flag           = var.cls_metadata_flag

  dynamic "rule" {
    for_each = var.cls_rules
    content {
      dynamic "full_text" {
        for_each = lookup(rule.value, "full_text", [])
        content {
          case_sensitive = full_text.value.case_sensitive
          tokenizer      = full_text.value.tokenizer
          contain_z_h    = lookup(full_text.value,"contain_z_h",true)
        }
      }

      dynamic "key_value"{
        for_each = lookup(rule.value, "key_value", [])
        content {
          case_sensitive = key_value.value.case_sensitive
          dynamic "key_values"{
            for_each = lookup(key_value.value, "key_values", [])
            content {
              key = key_values.value.key
              dynamic "value"{
                for_each = lookup(key_values.value, "value", [])
                content {
                  type        = value.value.type
                  tokenizer   = value.value.tokenizer
                  sql_flag    = value.value.sql_flag
                  contain_z_h = value.value.contain_z_h
                }
              }
            }
          }
        }
      }
      dynamic "tag" {
        for_each = lookup(rule.value, "tag", [])
        content {
          case_sensitive = tag.value.case_sensitive
          dynamic "key_values"{
            for_each = lookup(tag.value, "key_values", [])
            content {
              key = key_values.value.key
              dynamic "value"{
                for_each = lookup(key_values.value, "value", [])
                content {
                  type        = value.value.type
                  tokenizer   = value.value.tokenizer
                  sql_flag    = value.value.sql_flag
                  contain_z_h = value.value.contain_z_h
                }
              }
            }
          }
        }
      }
    }
  }

  depends_on = [ tencentcloud_cls_topic.topic ]
}