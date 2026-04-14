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
  region = "ap-guangzhou"
}

module "cam_security" {
  source = "../../../../../components/account-factory/baseline/account-baselines"

  baseline_name = "cam_user_baseline"
  member_list   = [
    # {
    #   #member_uin  = 1234567890
    #   member_name = "ITOPS"
    # }
  ]

  # cam baseline
  cam_password = {
    enabled = true
    password_must_contain        = "1!aA"
    password_minimum_length      = 8
    password_force_change        = 0
    password_reuse_limit         = 1
    password_retry_limit         = 10
  }

  cam_security = {
    enabled = true
    security_mfa_devices         = ["Stoken", "U2FToken", "Phone", "Mail"]
    security_mfa_login_strategy  = 1
    security_mfa_action_strategy = 2
    security_login_idle_timeout  = 900
    security_login_max_timeout   = 3600
  }

  # contact baseline
  account_contact = {
    enabled = true
    contacts = [
      {
        name:         "default_user",
        phone_num:    "13333333333",
        email:        "default_user@tencent.com",
        remark:       "Default user",
        country_code: "86"
      }
    ]
  }

  # tag baseline
  tag_info = {
    enabled = true
    tags = [
      {
        Key    = "env"
        Values = ["prod", "nonprod"]
      },
      {
        Key    = "dept"
        Values = ["network", "security", "audit", "finance", "resource", "common", "sandbox"]
      },
      {
        Key    = "created_by"
        Values = ["terraform", "admin", "user", "system", "script", "api", "console", "manual"]
      }
    ]
  }

  # security group baseline
  security_group = {
    enabled = true
    name   = "cam_security"
    remark = "CAM security group"
    region = "ap-shanghai"
    ingress_rules = [
      {
        cidr     = "0.0.0.0/0"
        protocol = "TCP"
        port     = "443"
        remark   = "Allow Web server HTTPS(443)"
        action   = "ACCEPT"
        type     = "HTTPS (443)"
      },
      {
        cidr     = "0.0.0.0/0"
        protocol = "TCP"
        port     = "80"
        remark   = "Allow Web server HTTP(80)"
        action   = "ACCEPT"
        type     = "HTTP (80)"
      }
    ]
    egress_rules = [
      {
        cidr     = "0.0.0.0/0"
        protocol = "TCP"
        port     = "443"
        remark   = "Allow Web server HTTPS(443)"
        action   = "DROP"
        type     = "Deny All HTTPS (443)"
      }
    ]
  }

  # vpc baseline
  vpc_info = {
    enabled = true
    name      = "cam_user_vpc"
    cidr      = "10.0.0.0/16"
    region    = "ap-shanghai"
    subnets   = [
      {
        subnet_name = "cam_user_subnet_1"
        cidr_block  = "10.0.0.0/24"
        zone        = "ap-shanghai-5"
      },
      {
        subnet_name = "cam_user_subnet_2"
        cidr_block  = "10.0.1.0/24"
        zone        = "ap-shanghai-8"
      }
    ]
  }
}