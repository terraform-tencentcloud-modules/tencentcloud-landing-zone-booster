terraform {
    required_version = ">= 0.14"

    required_providers {
      tencentcloud = {
        source  = "tencentcloudstack/tencentcloud"
        version = ">1.83.35"
      }
      random = {
        source  = "hashicorp/random"
        version = ">= 3.0"
      }
    }
  }
  