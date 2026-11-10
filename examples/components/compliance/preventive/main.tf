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
  source = "../../../../components/compliance/preventive"

  organization_id = 100000
  org_service_policies = [
    {
      name        = "tag-policy-1"
      content     = file("./policies/full_access_policy.json")
      description = "tag-policy-1"
      targets     = [
        {
          target_type = "MEMBER"
          #target_name = "member_test"
          target_id   = 10000000234
        }
      ]
    }
  ]
}