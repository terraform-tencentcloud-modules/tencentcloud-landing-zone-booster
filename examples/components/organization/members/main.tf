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

module "members" {
  source = "../../../../components/organization/members"

  members = {
    "DEPT-1" = [
      {
        node_id        = 200001
        name           = "member-1"
        permission_ids = [1, 2, 7]
        policy_type    = "Financial"
        pay_uin        = "100000000000"
      }
    ],
    "DEPT-2" = [
      {
        node_id        = 200001
        name           = "member-2"
        permission_ids = [1, 2, 7]
        policy_type    = "Financial"
        pay_uin        = "100000000000"
      }
    ],
    "DEPT-3" = [
      {
        node_id        = 200001
        name           = "member-3"
        permission_ids = [1, 2, 7]
        policy_type    = "Financial"
        pay_uin        = "100000000000"
      }
    ]
  }
}