terraform {
  required_version = ">= 1.5.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.81.125"
    }
  }
}

provider "tencentcloud" {
  region = "ap-shanghai"
}

module "ccn_instance" {
  source = "../../../../components/network/ccn-instance"

  # ccn config
  ccn_name                 = "ccn-network"
  ccn_bandwidth_limit_type = "INTER_REGION_LIMIT"
  ccn_charge_type          = "POSTPAID"
  ccn_description          = "Network CCN"
  ccn_qos                  = "AU"
  ccn_tags                 = {}

  # ccn bandwidth limit
  ccn_set_bandwith_limit = false
  #ccn_bandwidth_limit    = null
  #ccn_region             = "ap-shanghai"
  #ccn_dst_region         = null
}