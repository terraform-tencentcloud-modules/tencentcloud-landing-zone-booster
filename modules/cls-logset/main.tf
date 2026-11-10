resource "tencentcloud_cls_logset" "logset" {
  logset_name = var.logset_name

  dynamic "tag_list" {
    for_each = var.logset_tags == null ? {} : var.logset_tags
    content {
      key   = tag_list.key
      value = tag_list.value
    }
  }
}