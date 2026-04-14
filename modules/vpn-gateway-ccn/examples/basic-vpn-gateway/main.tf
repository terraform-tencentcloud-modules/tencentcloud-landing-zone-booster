################################################################################
# VPN Gateway Module - Basic Example
################################################################################

module "vpn_gateway_basic" {
  source = "../.."

  # VPN Gateway Configuration
  create_vpn_gateway = true
  vpn_gateway_name   = "test-vpn-gateway-basic"
  bandwidth          = 5
  type               = "IPSEC"
  vpc_id             = "vpc-xxxxxxxx" # 替换为实际的VPC ID
  zone               = "ap-guangzhou-3"
  charge_type        = "POSTPAID_BY_HOUR"

  # CCN Configuration - Disabled for basic example
  create_ccn = false
  attach_ccn = false

  # Tags
  vpn_tags = {
    Environment = "test"
    Project     = "vpn-demo"
  }
}