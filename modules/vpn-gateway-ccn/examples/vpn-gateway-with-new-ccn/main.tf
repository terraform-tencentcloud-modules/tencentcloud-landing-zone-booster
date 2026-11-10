################################################################################
# VPN Gateway Module - With New CCN Example
################################################################################

module "vpn_gateway_with_ccn" {
  source = "../.."

  # VPN Gateway Configuration
  create_vpn_gateway = true
  vpn_gateway_name   = "test-vpn-gateway-with-ccn"
  bandwidth          = 10
  type               = "CCN"
  zone               = "ap-guangzhou-3"
  charge_type        = "POSTPAID_BY_HOUR"

  # CCN Configuration - Create new CCN
  create_ccn         = true
  ccn_name           = "test-ccn-for-vpn"
  bandwidth_limit_type = "INTER_REGION_LIMIT"
  ccn_charge_type    = "POSTPAID"
  ccn_description    = "CCN created for VPN gateway testing"
  qos                = "AU"
  route_ecmp_flag    = false
  route_overlap_flag = true

  # CCN Attachment Configuration
  attach_ccn         = true
  instance_type      = "VPNGW"
  instance_region    = "ap-guangzhou"

  # Tags
  vpn_tags = {
    Environment = "test"
    Project     = "vpn-ccn-demo"
  }

  ccn_tags = {
    Environment = "test"
    NetworkType = "ccn"
  }
}