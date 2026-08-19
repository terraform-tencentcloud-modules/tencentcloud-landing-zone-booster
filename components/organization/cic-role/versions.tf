terraform {
  required_version = ">= 1.2.0"
  
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">=1.81.136"
    }
  }
}
