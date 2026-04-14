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

module "anti_ddos" {
  source = "../../../../components/security/anti-ddos"

  # Payment Type: Payment Mode: PREPAID (Prepaid) / POSTPAID_BY_MONTH (Postpaid).
  instance_charge_type = "POSTPAID_BY_MONTH"
  # High-defense package types: Enterprise, Standard, StandardPlus (Standard Edition 2.0).
  package_type            = "Standard"
  # Purchase period in months.
  instance_charge_prepaid_period = 1
  # OTIFY_AND_MANUAL_RENEW: Notify the user of the expiration date and do not automatically renew. 
  # NOTIFY_AND_AUTO_RENEW: Notify the user of the expiration date and automatically renew. 
  # DISABLE_NOTIFY_AND_MANUAL_RENEW: Do not notify the user of the expiration date and do not automatically renew. 
  # The default is: Notify the user of the expiration date and do not automatically renew.
  instance_charge_prepaid_renew_flag = "OTIFY_AND_MANUAL_RENEW"

  # Standard
  # The region where the high-defense package was purchased.
  standard_region                 = "ap-shanghai"
  # Number of protected IPs. 1, 10, 50, 100
  standard_protect_ip_count       = 1
  # Protected service bandwidth 50Mbps.
  standard_bandwidth              = 50
  # Whether to enable elastic service bandwidth. The default value is false.
  standard_elastic_bandwidth_flag = false
}