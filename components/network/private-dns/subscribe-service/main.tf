################################################################################
### Subscribe Private Zone Service (Enable the private dns service)
################################################################################
resource "tencentcloud_subscribe_private_zone_service" "this" {
  count = var.enable_private_zone_service ? 1 : 0
}