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

module "assume_role" {
  source = "../../../../components/organization/assume-role"

  assume_role_policies = [
    {
      assume_role_name  = "CrossOrgAccount"
      description       = "assume role for member"
      policies = [
        { policy_id = 1, policy_name = "AdministratorAccess", policy_type = 2 }
        #{ policy_type = 1, policy_document = file("./policies/full_access_policy.json") },
      ]
      members = [
        #{ member_name = "member_test" }
        { member_uin = 100000000000 }
      ]
    }
  ]
}