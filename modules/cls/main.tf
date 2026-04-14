resource "tencentcloud_cls_logset" "logset" {
  logset_name   = var.logset_name
  tags          = var.logset_tags
}

resource "tencentcloud_cls_topic" "topic" {
  logset_id            = tencentcloud_cls_logset.logset.id
  topic_name           = var.topic_name
  partition_count      = var.partition_count
  auto_split           = var.auto_split
  max_split_partitions = var.max_split_partitions
  period               = var.period
  storage_type         = var.storage_type
  hot_period           = var.hot_period
  is_web_tracking      = var.is_web_tracking
  encryption           = var.encryption
  describes            = var.describes
  tags                 = var.topic_tags
}

resource "tencentcloud_cls_index" "index" {
  count = var.create_index ? 1 : 0

  topic_id                = tencentcloud_cls_topic.topic.id
  status                  = var.index_status
  include_internal_fields = var.include_internal_fields
  metadata_flag           = var.metadata_flag

  dynamic "rule" {
    for_each = var.rules
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
}

