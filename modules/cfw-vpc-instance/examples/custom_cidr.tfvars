# Custom firewall VPC CIDR example

mode = 0
name = "cfw-vpc-custom-cidr"
switch_mode = 4
fw_vpc_cidr = "10.10.10.0/24"

vpc_fw_instances = [
  {
    name = "cfw-instance-custom"
    vpc_ids = ["vpc-999"]
    fw_deploy = [
      {
        deploy_region = "ap-guangzhou"
        width = 100
        zone_set = ["ap-guangzhou-1"]
      }
    ]
  }
]
