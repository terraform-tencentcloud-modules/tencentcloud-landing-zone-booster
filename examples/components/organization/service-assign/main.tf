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

module "service_assign" {
  source = "../../../../components/organization/service-assign"

  service_assign_list = [
    { member_uin = 100000000062, service_name = "CloudAudit" },
    { member_uin = 100000000062, service_name = "Config" },
    #{ member_name = "MemberName", service_name = "Cloud Security Center" },
    #{ member_name = "MemberName", service_name = "Billing Center" },
    #{ member_name = "MemberName", service_name = "ICP" },
    #{ member_name = "MemberName", service_name = "Web Application Firewall" },
    #{ member_name = "MemberName", service_name = "Cloud Virtual Machine" },
    #{ member_name = "MemberName", service_name = "Key Management Service" },
    #{ member_name = "MemberName", service_name = "Control Center" },
    #{ member_name = "MemberName", service_name = "tandon" }
  ]
}