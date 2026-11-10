terraform {
  required_version = ">= 1.6"
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.81.136"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}
