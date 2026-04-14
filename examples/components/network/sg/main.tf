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

module "security_group" {
  source = "../../../../components/network/sg"

  security_groups = [
    {
      name        = "app-security-group"
      description = "The security group for app server"
      tags        = {"Environment" = "DEV"}
      ingress_rules = [
        {
          action     = "ACCEPT"
          cidr_block = "10.0.0.0/8"
          port       = "80"
          protocol   = "TCP"
        }
      ]
      egress_rules = [
        {
          action     = "DROP"
          cidr_block = "0.0.0.0/0"
          port       = "all"
          protocol   = "ALL"
        }
      ]
    }
  ]
}