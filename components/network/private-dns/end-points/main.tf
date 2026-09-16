################################################################################
### Private DNS End Points
################################################################################
resource "tencentcloud_private_dns_end_point" "end_points" {
  for_each = var.end_points

  end_point_name       = each.value.end_point_name
  end_point_region     = each.value.end_point_region
  end_point_service_id = each.value.end_point_service_id
  ip_num               = each.value.ip_num
}