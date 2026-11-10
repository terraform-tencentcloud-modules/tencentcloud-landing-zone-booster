locals {
  dns_end_point_id   = var.create ? concat(tencentcloud_private_dns_extend_end_point.extend_endpoint.*.id, [""])[0] : ""
  dns_end_point_name = var.end_point_name
}

resource "tencentcloud_private_dns_extend_end_point" "extend_endpoint" {
  count = var.create ? 1 : 0

  end_point_name   = var.end_point_name
  end_point_region = var.end_point_region

  dynamic "forward_ip" {
    for_each = var.forwards
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