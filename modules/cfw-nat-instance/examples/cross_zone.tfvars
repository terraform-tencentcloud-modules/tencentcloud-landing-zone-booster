# Cross-zone example: enable cross a zone (disaster recovery)
mode = 0
name = "example-cfw-nat-crosszone"
width = 500
zone_set = ["ap-guangzhou-1", "ap-guangzhou-2"]
cross_a_zone = 1
new_mode_items = [
  {
    eips = ["1.2.3.5", "1.2.3.6"]
    vpc_list = ["vpc-aaaaaa", "vpc-bbbbbb"]
  }
]
