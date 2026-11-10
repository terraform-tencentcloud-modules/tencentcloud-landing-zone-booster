resource "tencentcloud_cfw_nat_instance" "tc_cfw_nat_instance" {
  mode         = var.mode
  name         = var.name
  width        = var.width
  zone_set     = var.zone_set
  cross_a_zone = var.cross_a_zone

  # Create mode (mode = 0): Use new_mode_items to configure new NAT firewall instance
  dynamic "new_mode_items" {
    for_each = var.mode == 0 ? var.new_mode_items : []
    content {
      eips    = new_mode_items.value.eips
      vpc_list = new_mode_items.value.vpc_list
    }
  }

  # Access mode (mode = 1): Use nat_gw_list to access existing NAT gateways
  nat_gw_list = var.mode == 1 ? var.nat_gw_list : null
}