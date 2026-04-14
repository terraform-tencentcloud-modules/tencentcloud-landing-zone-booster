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

module "network_acls" {
  source = "../../../../components/network/acl"

  network_acls = [
    {
      acl_name = "test-acl-unique"
      vpc_id   = "vpc-xxxx"
      # vpc_name = "vpc-name"
      ingress_rules = [
        {
          action   = "ALLOW"
          cidr     = "0.0.0.0/0"
          port     = "ALL"
          protocol = "ALL"
          desc     = "Allow ALL"
        }
      ]
      egress_rules = [
        {
          action   = "DROP"
          cidr     = "0.0.0.0/0"
          port     = "ALL"
          protocol = "ALL"
          desc     = "DROP ALL"
        }
      ]
      tags = {
        "Environment" = "DEV"
      }
    }
  ]
}