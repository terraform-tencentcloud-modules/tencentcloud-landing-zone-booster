resource "tencentcloud_cfw_address_template" "address_template" {
  name      = var.name
  detail    = var.detail
  ip_string = var.ip_string
  type      = var.type
}