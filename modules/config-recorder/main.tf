resource "tencentcloud_config_recorder_config" "this" {
  status         = var.status
  resource_types = var.resource_types
}
