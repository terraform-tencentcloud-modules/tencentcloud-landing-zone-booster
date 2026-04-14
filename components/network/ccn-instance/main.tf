resource "tencentcloud_ccn" "ccn" {
  name                 = var.ccn_name
  bandwidth_limit_type = var.ccn_bandwidth_limit_type
  charge_type          = var.ccn_charge_type
  description          = var.ccn_description
  qos                  = var.ccn_qos
  tags                 = var.ccn_tags
}

resource "tencentcloud_ccn_bandwidth_limit" "limit" {
  count = var.ccn_set_bandwith_limit ? 1 : 0

  ccn_id          = tencentcloud_ccn.ccn.id
  region          = var.ccn_region
  dst_region      = var.ccn_dst_region
  bandwidth_limit = var.ccn_bandwidth_limit
}