resource "tencentcloud_waf_custom_rule" "tc_waf_custom_rule" {
  name        = var.name
  sort_id     = var.sort_id
  redirect    = var.redirect
  expire_time = var.expire_time
  status      = var.status
  domain      = var.domain
  action_type = var.action_type
  dynamic "strategies" {
    for_each = var.strategies
    content {
      field        = strategies.value.field
      compare_func = strategies.value.compare_func
      content      = strategies.value.content
      arg          = strategies.value.arg
    }
  }
}