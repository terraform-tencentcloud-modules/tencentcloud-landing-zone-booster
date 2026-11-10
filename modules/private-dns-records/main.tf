locals {
  records = { for k, v in var.records: k => v if var.create}
}

resource "tencentcloud_private_dns_record" "records" {
  for_each     = local.records
  zone_id      = var.private_dns_zone_id
  record_type  = try(each.value.record_type, "A")
  record_value = try(each.value.record_value, "")
  sub_domain   = try(each.value.sub_domain, "")
  ttl          = try(each.value.ttl, 600)
  weight       = try(each.value.weight, null)
  mx           = try(each.value.mx, null)
}