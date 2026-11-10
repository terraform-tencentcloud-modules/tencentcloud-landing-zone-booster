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

module "bastion" {
  source = "../../../../components/security/bastion"

  vpc_id         = "vpc-00000000"
  #subnet_id      = "subnet-00000000"
  #vpc_cidr_block = "10.148.0.0/16"
  # bastion config
  deploy_region    = "ap-shanghai"
  deploy_zone      = "ap-shanghai-5"
  cidr_block       = "10.0.0.0/24"
  resource_edition = "standard"
  resource_node    = 20
  time_unit        = "m"
  time_span        = "1"
  pay_mode         = 1
  auto_renew_flag  = 1
  intranet_access  = 1
  external_access  = 0
}