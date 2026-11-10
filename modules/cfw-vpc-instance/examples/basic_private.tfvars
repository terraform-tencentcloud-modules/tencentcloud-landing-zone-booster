# Basic private-mode example: single firewall instance with auto CIDR

mode = 0
name = "cfw-vpc-basic"
switch_mode = 1

vpc_fw_instances = [
  {
    name = "cfw-instance-1"
    vpc_ids = ["vpc-aaa111", "vpc-bbb222"]
    fw_deploy = [
      {
        deploy_region = "ap-guangzhou"
        width = 100
        zone_set = ["ap-guangzhou-1", "ap-guangzhou-2"]
      }
    ]
  }
]
