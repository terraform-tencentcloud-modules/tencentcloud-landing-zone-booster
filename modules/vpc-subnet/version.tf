terraform {
  required_version = ">= 0.12"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">1.18.1"
    }
  }
}

# Configure the TencentCloud Provider
# provider "tencentcloud" {
#   secret_id  = ""
#   secret_key = ""
#   region     = ""
# }