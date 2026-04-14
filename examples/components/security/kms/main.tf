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
  source = "../../../../components/security/kms"

  region      = "ap-shanghai"
  zone        = "ap-shanghai-5"
  pay_mode    = "PrePay"
  period      = 1
  period_unit = "m"
  renew_flag  = "NOTIFY_AND_MANUAL_RENEW"
  parameter   = {
    goodsNum            = 1
    sv_kms_pg_pro       = true
    sv_kms_exp_data_key = 1000
  }
}