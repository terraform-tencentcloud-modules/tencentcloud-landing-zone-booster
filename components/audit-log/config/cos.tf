resource "tencentcloud_cos_bucket" "bucket" {
  count = var.deliver_target_type == "COS" ? 1 : 0

  bucket            = "${var.cos_bucket}-${local.app_id}"
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
  count = var.deliver_target_type == "COS" ? 1 : 0

  bucket = "${var.cos_bucket}-${local.app_id}"
  policy = jsonencode({
    "version" : "2.0",
    "Statement" : [
      {
        "Principal" : {
          "service" : [
            "cloudaudit.cloud.tencent.com"
          ]
        },
        "Action" : [
          "cos:*"
        ],
        "Effect" : "allow",
        "Resource" : [
          "qcs::cos:${var.region}:uid/${local.app_id}:${var.cos_bucket}-${local.app_id}/*"
        ]
      }
    ]
  })

  depends_on = [tencentcloud_cos_bucket.bucket]
}