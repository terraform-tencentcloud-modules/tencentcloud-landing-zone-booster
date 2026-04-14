resource "tencentcloud_cfw_nat_firewall_switch" "tc_cfw_nat_firewall_switch" {
  enable     = var.enable
  nat_ins_id = var.nat_ins_id
  subnet_id  = var.subnet_id
}