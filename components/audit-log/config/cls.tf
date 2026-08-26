resource "tencentcloud_cls_logset" "logset" {
  count = var.deliver_target_type == "CLS" ? 1 : 0

  logset_name = var.cls_logset_name
  tags        = var.cls_logset_tags
}

resource "tencentcloud_cls_topic" "topic" {
  count = var.deliver_target_type == "CLS" ? 1 : 0

  logset_id            = tencentcloud_cls_logset.logset[0].id
  topic_name           = var.cls_topic_name
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

  depends_on = [tencentcloud_cls_logset.logset]
}

resource "tencentcloud_cls_index" "index" {
  count = var.deliver_target_type == "CLS" && var.cls_create_index ? 1 : 0

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
          tokenizer      = lookup(full_text.value, "tokenizer", null)
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
                      key = lookup(child_node.value, "key", null)
                      dynamic "value" {
                        for_each = lookup(child_node.value, "value", [])
                        content {
                          type                      = value.value.type
                          tokenizer                 = lookup(value.value, "tokenizer", null)
                          sql_flag                  = lookup(value.value, "sql_flag", null)
                          contain_z_h               = lookup(value.value, "contain_z_h", null)
                          alias                     = lookup(value.value, "alias", null)
                          open_index_for_child_only = lookup(value.value, "open_index_for_child_only", null)
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
                      key = lookup(child_node.value, "key", null)
                      dynamic "value" {
                        for_each = lookup(child_node.value, "value", [])
                        content {
                          type                      = value.value.type
                          tokenizer                 = lookup(value.value, "tokenizer", null)
                          sql_flag                  = lookup(value.value, "sql_flag", null)
                          contain_z_h               = lookup(value.value, "contain_z_h", null)
                          alias                     = lookup(value.value, "alias", null)
                          open_index_for_child_only = lookup(value.value, "open_index_for_child_only", null)
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

  depends_on = [tencentcloud_cls_topic.topic]
}