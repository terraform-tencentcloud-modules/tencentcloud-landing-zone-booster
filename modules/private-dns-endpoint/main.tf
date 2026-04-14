resource "tencentcloud_private_dns_end_point" "endpoint" {
  end_point_name       = var.end_point_name
  end_point_service_id = var.end_point_service_id
  end_point_region     = var.end_point_region
  ip_num               = var.ip_num
}