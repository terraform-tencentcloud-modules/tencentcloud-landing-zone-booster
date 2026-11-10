resource "tencentcloud_waf_cc" "tc_waf_cc" {
  domain          = var.domain
  name            = var.name
  status          = var.status
  advance         = var.advance
  limit           = var.limit
  interval        = var.interval
  url             = var.url
  match_func      = var.match_func
  action_type     = var.action_type
  priority        = var.priority
  valid_time      = var.valid_time
  edition         = var.edition
  type            = var.type
  event_id        = var.event_id
  session_applied = var.session_applied
}