resource "tencentcloud_apm_association_config" "example" {
  # required
  instance_id  = var.instance_id
  product_name = var.product_name
  status       = var.status

  # optional
  peer_id = var.peer_id
  topic   = var.topic
}