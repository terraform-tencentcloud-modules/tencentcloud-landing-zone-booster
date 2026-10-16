resource "tencentcloud_cls_topic" "topic" {
  logset_id            = var.logset_id
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
          contain_z_h    = lookup(full_text.value, "contain_z_h", true)
        }
      }

      dynamic "key_value" {
        for_each = lookup(rule.value, "key_value", [])
        content {
          case_sensitive = key_value.value.case_sensitive
          dynamic "key_values" {
            for_each = lookup(key_value.value, "key_values", [])
            content {
              key = key_values.value.key
              dynamic "value" {
                for_each = lookup(key_values.value, "value", [])
                content {
                  type                      = value.value.type
                  tokenizer                 = lookup(value.value, "tokenizer", null)
                  sql_flag                  = lookup(value.value, "sql_flag", null)
                  contain_z_h               = lookup(value.value, "contain_z_h", null)
                  alias                     = lookup(value.value, "alias", null)
                  open_index_for_child_only = lookup(value.value, "open_index_for_child_only", null)
                  dynamic "child_node" {
                    for_each = lookup(value.value, "child_node", [])
                    content {
                      key = child_node.value.key
                      dynamic "value" {
                        for_each = lookup(child_node.value, "value", [])
                        content {
                          type                      = value.value.type
                          tokenizer                 = lookup(value.value, "tokenizer", null)
                          sql_flag                  = lookup(value.value, "sql_flag", null)
                          contain_z_h               = lookup(value.value, "contain_z_h", null)
                          alias                     = lookup(value.value, "alias", null)
                        }
                      }
                    }
                  }
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
          dynamic "key_values" {
            for_each = lookup(tag.value, "key_values", [])
            content {
              key = key_values.value.key
              dynamic "value" {
                for_each = lookup(key_values.value, "value", [])
                content {
                  type                      = value.value.type
                  tokenizer                 = lookup(value.value, "tokenizer", null)
                  sql_flag                  = lookup(value.value, "sql_flag", null)
                  contain_z_h               = lookup(value.value, "contain_z_h", null)
                  alias                     = lookup(value.value, "alias", null)
                  open_index_for_child_only = lookup(value.value, "open_index_for_child_only", null)
                  dynamic "child_node" {
                    for_each = lookup(value.value, "child_node", [])
                    content {
                      key = child_node.value.key
                      dynamic "value" {
                        for_each = lookup(child_node.value, "value", [])
                        content {
                          type                      = value.value.type
                          tokenizer                 = lookup(value.value, "tokenizer", null)
                          sql_flag                  = lookup(value.value, "sql_flag", null)
                          contain_z_h               = lookup(value.value, "contain_z_h", null)
                          alias                     = lookup(value.value, "alias", null)
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "dynamic_index" {
        for_each = lookup(rule.value, "dynamic_index", [])
        content {
          status = dynamic_index.value.status
        }
      }
    }
  }
}