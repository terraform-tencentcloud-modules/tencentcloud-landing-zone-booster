resource "tencentcloud_ssl_certificate" "ssl_certificate" {
  project_id = var.project_id
  name       = var.name
  type       = var.type
  cert       = var.cert
  key        = var.key
  tags       = var.tags
}