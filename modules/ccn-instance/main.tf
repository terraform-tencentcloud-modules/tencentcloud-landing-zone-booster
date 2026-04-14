################################################################################
# CCN
################################################################################
resource "tencentcloud_ccn" "ccn" {
  name                 = var.ccn_name
  bandwidth_limit_type = var.bandwidth_limit_type
  charge_type          = var.charge_type
  description          = var.ccn_description
  qos                  = var.ccn_qos
  tags                 = var.ccn_tags
}

################################################################################
# CCN Bandwidth Limit
################################################################################
resource "tencentcloud_ccn_bandwidth_limit" "limit" {
  count = var.set_bandwith_limit ? 1 : 0

  ccn_id          = tencentcloud_ccn.ccn.id
  region          = var.src_region
  dst_region      = var.dst_region
  bandwidth_limit = var.bandwidth_limit
}
