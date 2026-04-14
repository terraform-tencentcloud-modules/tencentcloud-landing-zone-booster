################################################################################
# CCN Bandwidth Limit
################################################################################
resource "tencentcloud_ccn_bandwidth_limit" "limit" {
  ccn_id          = var.ccn_id
  region          = var.src_region
  dst_region      = var.dst_region
  bandwidth_limit = var.bandwidth_limit
}
