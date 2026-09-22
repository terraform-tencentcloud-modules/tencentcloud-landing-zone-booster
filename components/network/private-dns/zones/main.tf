################################################################################
### Private DNS Zones
################################################################################
resource "tencentcloud_private_dns_zone" "zones" {
  for_each = var.zones

  domain               = each.value.domain
  remark               = each.value.remark
  dns_forward_status   = each.value.dns_forward_status
  cname_speedup_status = each.value.cname_speedup_status

  # VPC Associations
  dynamic "vpc_set" {
    for_each = each.value.vpc_set
    content {
      uniq_vpc_id = vpc_set.value.uniq_vpc_id
      region      = vpc_set.value.region
    }
  }

  # Account VPC Associations (cross-account)
  dynamic "account_vpc_set" {
    for_each = each.value.account_vpc_set
    content {
      uin         = account_vpc_set.value.uin
      uniq_vpc_id = account_vpc_set.value.uniq_vpc_id
      region      = account_vpc_set.value.region
      vpc_name    = account_vpc_set.value.vpc_name
    }
  }

  tags = each.value.tags
}

################################################################################
### Private DNS Records
################################################################################
resource "tencentcloud_private_dns_record" "records" {
  for_each = var.records

  zone_id      = try(tencentcloud_private_dns_zone.zones[each.value.zone_key].id, each.value.zone_id)
  record_type  = each.value.record_type
  sub_domain   = each.value.sub_domain
  record_value = each.value.record_value
  ttl          = each.value.ttl
  weight       = each.value.weight
  mx           = each.value.mx
}

################################################################################
### Private DNS Zone VPC Attachments
################################################################################
resource "tencentcloud_private_dns_zone_vpc_attachment" "vpc_attachments" {
  for_each = var.vpc_attachments

  zone_id = try(tencentcloud_private_dns_zone.zones[each.value.zone_key].id, each.value.zone_id)

  # VPC Set
  dynamic "vpc_set" {
    for_each = each.value.vpc_set != null ? [each.value.vpc_set] : []
    content {
      uniq_vpc_id = vpc_set.value.uniq_vpc_id
      region      = vpc_set.value.region
    }
  }

  # Account VPC Set (cross-account)
  dynamic "account_vpc_set" {
    for_each = each.value.account_vpc_set != null ? [each.value.account_vpc_set] : []
    content {
      uin         = account_vpc_set.value.uin
      uniq_vpc_id = account_vpc_set.value.uniq_vpc_id
      region      = account_vpc_set.value.region
    }
  }
}

################################################################################
### Private DNS Forward Rules
################################################################################
resource "tencentcloud_private_dns_forward_rule" "forward_rules" {
  for_each = var.forward_rules

  rule_name    = each.value.rule_name
  rule_type    = each.value.rule_type
  zone_id      = try(tencentcloud_private_dns_zone.zones[each.value.zone_key].id, each.value.zone_id)

  # Priority: end_point_id (direct) > extend_endpoint_key > endpoint_key
  end_point_id = coalesce(
    each.value.end_point_id,
    try(tencentcloud_private_dns_extend_end_point.extend_end_points[each.value.extend_endpoint_key].id, null),
    try(tencentcloud_private_dns_end_point.end_points[each.value.endpoint_key].id, null)
  )
}