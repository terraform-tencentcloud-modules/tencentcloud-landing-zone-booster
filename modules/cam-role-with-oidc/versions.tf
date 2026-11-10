terraform {
  required_version = ">= 0.14"
  
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">=1.81.136"
    }
  }
}