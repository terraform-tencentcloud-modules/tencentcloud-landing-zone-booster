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

module "cic_role" {
  source = "../../../modules/tco-identity-center-role-configuration"

  zone_id   = "z-18nwn95vm01l"
  roles = [
    {
      role_name        = "CICRoleTest"
      session_duration = 7200
      description      = "CIC role for test"
      custom_policies = [
        {
          role_policy_name     = "CICOrganizationManagerPolicy"
          role_policy_document = file("policies/cic.json")
        }
      ]
    }
  ]
}