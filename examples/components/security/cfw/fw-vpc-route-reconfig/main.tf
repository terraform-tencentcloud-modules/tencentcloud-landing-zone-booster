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

module "cfw_vpc_fw_route_reconfig" {
  source = "../../../../../components/security/cfw/fw-vpc-route-reconfig"

  vpc_id     = "vpc-xxxx"
  gateway_id = "gw-xxxx"
}