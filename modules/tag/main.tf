resource "tencentcloud_tag" "tags" {
  for_each = { for tag in var.tags : tag.key => tag }
  tag_key   = each.value.key
  tag_value = each.value.value
}