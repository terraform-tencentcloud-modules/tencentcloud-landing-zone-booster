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

module "cam_role" {
  source = "../../../../../components/account-factory/baseline/cam-role"

  role_name        = "test_user"
  description      = "test_user"
  principal = {
    type         = 1
    account_uin  = "10000000234"
    #service_name = "scf.qcloud.com"
  }
  cam_policy = {
    preset_policies = ["ReadOnlyAccess"]
    custom_policies = [
      {
        name     = "test_user_assume_policy"
        document = file("./policies/test.json")
      }
    ]
  }
}