locals {
  dns_forward_rule_id = var.create ? concat(tencentcloud_private_dns_forward_rule.forward_rule.*.id, [""])[0] : ""
  dns_forward_rule_name = var.dns_forward_rule_name
}


resource "tencentcloud_private_dns_forward_rule" "forward_rule" {
  count = var.create ? 1 : 0
  rule_name    = local.dns_forward_rule_name
  rule_type    = var.rule_type # "DOWN"
  zone_id      = var.private_dns_zone_id
  end_point_id = var.dns_end_point_id
}