# Multi-instance, multi-region example

mode = 0
name = "cfw-vpc-multi"
switch_mode = 2

vpc_fw_instances = [
  {
    name = "cfw-instance-a"
    vpc_ids = ["vpc-111", "vpc-112"]
    fw_deploy = [
      {
        deploy_region = "ap-guangzhou"
        width = 100
        zone_set = ["ap-guangzhou-1"]
      },
      {
        deploy_region = "ap-shanghai"
        width = 150
        zone_set = ["ap-shanghai-1", "ap-shanghai-2"]
      }
    ]
  },
  {
    name = "cfw-instance-b"
    vpc_ids = ["vpc-221"]
    fw_deploy = [
      {
        deploy_region = "ap-beijing"
        width = 100
        zone_set = ["ap-beijing-1"]
      }
    ]
  }
]
