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

module "cam_user" {
  source = "../../../../../components/account-factory/baseline/cam-user"

  user_name = "test_user"
  cam_policy = {
    pre_policies    = ["ReadOnlyAccess"]
    custom_policies = [
      {
        name     = "test_user_assume_policy"
        document = file("./policies/test.json")
      }
    ]
  }
}