################################################################################
### Private DNS Extend End Points (支持多个 forward_ip)
################################################################################
resource "tencentcloud_private_dns_extend_end_point" "extend_end_points" {
  for_each = var.extend_end_points

  end_point_name   = each.value.end_point_name
  end_point_region = each.value.end_point_region

  # 支持多个 forward_ip
  dynamic "forward_ip" {
    for_each = each.value.forward_ip
    content {
      access_type       = forward_ip.value.access_type
      host              = forward_ip.value.host
      hosts             = forward_ip.value.hosts
      port              = forward_ip.value.port
      vpc_id            = forward_ip.value.vpc_id
      access_gateway_id = forward_ip.value.access_gateway_id
    }
  }
}