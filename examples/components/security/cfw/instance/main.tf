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

module "cfw_instance" {
  source = "../../../../../components/security/cfw/instance"

  region      = "ap-shanghai"
  zone        = "ap-shanghai-5"
  pay_mode    = "PrePay"
  period      = 1
  period_unit = "m"
  renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
  parameter = {
    goodsNum = 1
    sv_cloudfirewall_basic_ueps      = true
    sv_cloudfirewall_extended_clasps = true
    sv_cloudfirewall_extended_sub    = 4
  }
}