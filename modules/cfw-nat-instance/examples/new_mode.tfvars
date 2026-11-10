# New mode example: create NAT CFW instance in new mode
mode = 0
name = "example-cfw-nat-newmode"
width = 100
zone_set = ["ap-guangzhou-1"]
cross_a_zone = 0
new_mode_items = [
  {
    eips = ["1.2.3.4"]
    vpc_list = ["vpc-xxxxxx"]
  }
]
