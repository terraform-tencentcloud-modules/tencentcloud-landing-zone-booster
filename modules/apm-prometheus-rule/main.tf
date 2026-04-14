resource "tencentcloud_apm_prometheus_rule" "this" {
  instance_id       = var.instance_id
  name              = var.name
  service_name      = var.service_name
  metric_match_type = var.metric_match_type
  metric_name_rule  = var.metric_name_rule
  status            = var.status
}