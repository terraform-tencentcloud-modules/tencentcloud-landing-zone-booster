resource "tencentcloud_cls_logset" "logset" {
  count = var.cloudaudit_storage_type == "cls" ? 1 : 0

  logset_name   = var.cls_logset_name
  tags          = var.cls_logset_tags
}

resource "tencentcloud_cls_topic" "topic" {
  count = var.cloudaudit_storage_type == "cls" ? 1 : 0

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

  topic_id                = tencentcloud_cls_topic.topic[0].id
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