data "tencentcloud_user_info" "info" {}

locals {
  app_id = var.app_id != null && var.app_id != "" ? var.app_id : data.tencentcloud_user_info.info.app_id
}

resource "tencentcloud_cos_bucket" "bucket" {
  bucket               = "${var.bucket_name}-${local.app_id}"
  acl                  = var.bucket_acl
  multi_az             = var.multi_az
  versioning_enable    = var.versioning_enable
  encryption_algorithm = var.encryption_algorithm
  kms_id               = var.kms_id
  force_clean          = var.force_clean
  tags                 = var.tags
  dynamic "lifecycle_rules" {
    for_each = var.lifecycle_rules
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

  dynamic "cors_rules" {
    for_each = var.cors_rules
    content {
      allowed_headers = cors_rules.value.allowed_headers
      allowed_methods = cors_rules.value.allowed_methods
      allowed_origins = cors_rules.value.allowed_origins
      expose_headers  = try(cors_rules.value.expose_headers, [])
      max_age_seconds = try(cors_rules.value.max_age_seconds, 0)
    }
  }

  dynamic "origin_pull_rules" {
    for_each = var.origin_pull_rules
    content {
      host                = origin_pull_rules.value.host
      priority            = origin_pull_rules.value.priority
      back_to_source_mode = origin_pull_rules.value.back_to_source_mode
      custom_http_headers = origin_pull_rules.value.custom_http_headers
      follow_http_headers = origin_pull_rules.value.follow_http_headers
      follow_query_string = origin_pull_rules.value.follow_query_string
      follow_redirection  = origin_pull_rules.value.follow_redirection
      http_redirect_code  = origin_pull_rules.value.http_redirect_code
      prefix              = origin_pull_rules.value.prefix
      protocol            = origin_pull_rules.value.protocol
    }
  }
}
