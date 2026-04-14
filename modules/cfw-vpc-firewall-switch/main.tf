resource "tencentcloud_cfw_vpc_firewall_switch" "tc_cfw_vpc_firewall_switch" {
  enable     = var.enable
  switch_id  = var.switch_id
  vpc_ins_id = var.vpc_ins_id
}