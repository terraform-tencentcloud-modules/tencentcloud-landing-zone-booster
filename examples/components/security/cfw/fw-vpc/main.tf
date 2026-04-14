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

module "cfw_vpc_fw" {
  source = "../../../../../components/security/cfw/fw-vpc"

  ccn_id       = "ccn-xxxx"
  name         = "cfw-vpc"
  mode         = 1
  switch_mode  = 4
  fw_vpc_cidr  = ""
  fw_instances = [
    {
      # (Required, String) Firewall instance name.
      name = "vpc-fw-instance-1"
      fw_deploy = [{
        # (Required, String) Deployment region.
        deploy_region = "ap-shanghai"
        # (Required, Int) Bandwidth, unit: Mbps.
        width = 100
        # (Required, Set) zone list
        zone_set = ["ap-shanghai-5", "ap-shanghai-8"]
        # (Optional, Int) Off-site disaster recovery 1: use off-site disaster recovery; 0: do not use off-site disaster recovery; 
        # if it is empty, off-site disaster recovery will not be used by default.
        cross_a_zone = 0
      }]
    }
  ]

  vpc_fw_policies = [
    {
      description    = "Allow ICMP from VPC1 to VPC2"
      source_type    = "net"
      source_content = "0.0.0.0/0"
      dest_type      = "net"
      dest_content   = "0.0.0.0/0"
      protocol       = "ICMP"
      port           = "-1/-1"
      rule_action    = "accept"
      enable         = "true"
    }
  ]
}