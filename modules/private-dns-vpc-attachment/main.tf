/* 
**NOTE:** 
If you need to bind account A to account B's VPC resources, you need to first grant role authorization to account A.
*/
resource "tencentcloud_private_dns_zone_vpc_attachment" "vpc_attachments" {
  for_each = { for k, vpc_set in var.vpc_sets: k => vpc_set if var.create }
  zone_id = var.private_dns_zone_id

  vpc_set {
    region      = each.value.region
    uniq_vpc_id = each.value.uniq_vpc_id
  }
}

resource "tencentcloud_private_dns_zone_vpc_attachment" "account_vpc_attachments" {
  for_each = { for k, account_vpc_set in var.account_vpc_sets: k => account_vpc_set if var.create }
  zone_id = var.private_dns_zone_id

  account_vpc_set {
    region      = each.value.region
    uniq_vpc_id = each.value.uniq_vpc_id
    uin         = each.value.uin
  }
}