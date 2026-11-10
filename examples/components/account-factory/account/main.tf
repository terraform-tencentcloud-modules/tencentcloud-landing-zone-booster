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

module "org_members" {
  source = "../../../../components/account-factory/account"

  member_name    = "member_test"
  permission_ids = [1, 2, 7]
  policy_type    = "Financial"
  # optional
  remark = "member for test"
  tags   = {
    "CreatedBy" = "terraform"
  }
}