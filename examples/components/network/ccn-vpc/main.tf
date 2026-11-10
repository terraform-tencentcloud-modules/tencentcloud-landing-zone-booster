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

module "ccn_vpc" {
  source = "../../../../components/network/ccn-vpc"

  region              = "ap-shanghai"
  availability_zones  = ["ap-shanghai-5", "ap-shanghai-8"]
  name                = "vpc-outbound"
  cidr                = "10.0.0.0/24"
  is_multicast        = false
  tags                = {}
  default_subnet_name = "vpc-outbound-default-subnet"
  subnet_cidrs = [{
    subnet_name         = "subnet-outbound"
    subnet_cidr         = "10.0.1.0/26"
    subnet_is_multicast = false
    availability_zone   = "ap-shanghai-5"
  }]

  ccn_id          = "ccn-00v00001"
  attachment_desc = "CCN attach outbound vpc"
}