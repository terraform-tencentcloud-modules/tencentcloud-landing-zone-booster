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

module "csc" {
  source = "../../../../components/security/csc"

  region      = "ap-shanghai"
  zone        = "ap-shanghai-5"
  pay_mode    = "PrePay"
  period      = 1
  period_unit = "m"
  renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
  parameter = {
    sv_soccloud_pc_ae = true
    autoRenewFlag     = 0
    goodsNum          = 1
  }
}