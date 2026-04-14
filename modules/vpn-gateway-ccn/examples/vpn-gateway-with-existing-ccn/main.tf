################################################################################
# VPN Gateway Module - With Existing CCN Example
################################################################################

module "vpn_gateway_existing_ccn" {
  source = "../.."

  # VPN Gateway Configuration
  create_vpn_gateway = true
  vpn_gateway_name   = "test-vpn-gateway-existing-ccn"
  bandwidth          = 20
  type               = "CCN"
  zone               = "ap-guangzhou-3"
  charge_type        = "POSTPAID_BY_HOUR"

  # CCN Configuration - Use existing CCN (do not create new one)
  create_ccn = false

  # CCN Attachment Configuration - Attach to existing CCN
  attach_ccn       = true
  ccn_id           = "ccn-xxxxxxxx" # 替换为现有的CCN ID
  instance_id      = null # 使用自动获取的VPN网关ID
  instance_type    = "VPNGW"
  instance_region  = "ap-guangzhou"
  ccn_uin          = null # 使用当前账户的CCN

  # Optional attachment parameters
  attachment_description = "VPN gateway attachment to existing CCN"
  route_table_id         = null

  # Tags
  vpn_tags = {
    Environment = "production"
    Project     = "vpn-integration"
  }
}