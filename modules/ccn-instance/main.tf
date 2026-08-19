################################################################################
# CCN
################################################################################
resource "tencentcloud_ccn" "ccn" {
  name                   = var.name
  description            = var.description
  qos                    = var.qos
  charge_type            = var.charge_type
  bandwidth_limit_type   = var.bandwidth_limit_type
  route_ecmp_flag        = var.enable_route_ecmp
  route_overlap_flag     = var.enable_route_overlap
  instance_metering_type = var.instance_metering_type
  tags                   = var.tags
}