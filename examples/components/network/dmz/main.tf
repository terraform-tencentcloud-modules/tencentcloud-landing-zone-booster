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

module "dmz" {
  source = "../../../../components/network/dmz"

  # common
  vpc_region = "ap-shanghai"

  # inbound vpc
  vpc_inbound_name         = "vpc-network-inbound"
  vpc_inbound_cidr         = "10.0.0.0/24"
  vpc_inbound_is_multicast = true
  vpc_inbound_tags         = {}
  vpc_inbound_subnet_cidrs = [{
    subnet_name         = "subnet-network-inbound-1"
    subnet_cidr         = "10.0.0.0/26"
    subnet_is_multicast = true
    availability_zone   = "ap-shanghai-5"
  }]
  vpc_inbound_subnet_tags = {}

  # outbound vpc
  vpc_outbound_name         = "vpc-network-outbound"
  vpc_outbound_cidr         = "10.0.1.0/24"
  vpc_outbound_is_multicast = true
  vpc_outbound_tags         = {}
  vpc_outbound_subnet_cidrs = [{
    subnet_name         = "subnet-network-outbound-1"
    subnet_cidr         = "10.0.1.0/26"
    subnet_is_multicast = true
    availability_zone   = "ap-shanghai-5"
  }]
  vpc_outbound_subnet_tags = {}

  # nat gateway
  nat_gateway_name               = "nat-gateway-network-outbound"
  nat_eips                       = ["eip-network-outbound-1", "eip-network-outbound-2"]
  nat_internet_max_bandwidth_out = 100
  nat_product_version            = 2
  nat_enable_flow_monitor        = true
  nat_tags                       = {}

  # ccn attachment
  ccn_id                 = "ccn-12345678"
  #ccn_name               = "ccn-network-prd-sh"
  attachment_description = "DMZ vpc attachment to ccn"
}