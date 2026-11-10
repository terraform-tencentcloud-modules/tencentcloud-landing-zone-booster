resource "tencentcloud_cfw_edge_firewall_switch" "switch" {
  public_ip   = var.public_ip
  subnet_id   = var.subnet_id
  switch_mode = var.switch_mode
  enable      = var.enable
}