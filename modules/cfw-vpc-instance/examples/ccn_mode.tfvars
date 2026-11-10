# CCN mode example: deploy firewall in cloud connect network

mode = 1
name = "cfw-vpc-ccn"
switch_mode = 2
ccn_id = "ccn-xxxx"

vpc_fw_instances = [
  {
    name = "cfw-instance-ccn"
    vpc_ids = ["vpc-ccc333"]
    fw_deploy = [
      {
        deploy_region = "ap-beijing"
        width = 200
        zone_set = ["ap-beijing-1"]
        cross_a_zone = 1
      }
    ]
  }
]
