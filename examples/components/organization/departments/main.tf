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

module "departments" {
  source = "../../../../components/organization/departments"

  org_nodes = [
    {
      name = "l1-1"
      remark = "l1-1"
      # sub_nodes = [
      #   {
      #     name = "l2-1"
      #     remark = "l2-1"
      #   },
      #   {
      #     name = "l2-2"
      #     remark = "l2-2"
      #   }
      # ]
    },
    {
      name = "l1-2"
      remark = "l1-2"
      # sub_nodes = [
      #   {
      #     name = "l2-3"
      #     remark = "l2-3"
      #   },
      #   {
      #     name = "l2-4"
      #     remark = "l2-4"
      #   }
      # ]
    }
  ]
}