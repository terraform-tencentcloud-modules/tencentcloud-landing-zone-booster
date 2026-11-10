/*
 **NOTE:** 
 If you want to unbind all VPCs bound to the current private dns zone, simply clearing the declaration will not take effect; 
 you need to set the `region` and `uniq_vpc_id` in `vpc_set` to an empty string.
*/

locals {
  private_dns_zone_id = concat(tencentcloud_private_dns_zone.zone.*.id, [""])[0]
}

resource "tencentcloud_private_dns_zone" "zone" {
  count  = var.create ? 1 : 0
  domain = var.domain
  tags   = var.tags

  remark             = var.remark
  dns_forward_status = var.dns_forward_status

  lifecycle {
    ignore_changes = [
      vpc_set,
      account_vpc_set
    ]
  }
}
