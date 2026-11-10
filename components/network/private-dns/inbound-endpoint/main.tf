################################################################################
### Private DNS Inbound Endpoints
################################################################################
resource "tencentcloud_private_dns_inbound_endpoint" "inbound_endpoints" {
  for_each = var.inbound_endpoints

  endpoint_region = each.value.endpoint_region
  endpoint_name   = each.value.endpoint_name
  endpoint_vpc    = each.value.endpoint_vpc

  dynamic "subnet_ip" {
    for_each = each.value.subnet_ip
    content {
      subnet_id  = subnet_ip.value.subnet_id
      subnet_vip = subnet_ip.value.subnet_vip # IP address (auto-assigned if not specified)
    }
  }
}