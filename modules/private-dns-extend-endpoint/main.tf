locals {
  dns_end_point_id = var.create ? concat(tencentcloud_private_dns_extend_end_point.endpoint.*.id, [""])[0] : ""
  dns_end_point_name = var.end_point_name
}

resource "tencentcloud_private_dns_extend_end_point" "extend_endpoint" {
  count = var.create ? 1 : 0
  end_point_name   = var.end_point_name
  end_point_region = var.end_point_region
  forward_ip {
    access_type       = var.forward.access_type
    host              = var.forward.host
    port              = var.forward.port
    vpc_id            = var.forward.vpc_id
    access_gateway_id = try(var.forward.access_gateway_id, null) 
  }
}