################################################################################
### EIP Resource
################################################################################
resource "tencentcloud_eip" "eip" {
  name                       = var.eip.name
  type                       = var.eip.type
  internet_charge_type       = var.eip.internet_charge_type
  internet_max_bandwidth_out = var.eip.internet_max_bandwidth_out
  internet_service_provider  = var.eip.internet_service_provider
  prepaid_period             = var.eip.prepaid_period
  auto_renew_flag            = var.eip.auto_renew_flag
  bandwidth_package_id       = var.eip.bandwidth_package_id
  egress                     = var.eip.egress
  anycast_zone               = var.eip.anycast_zone
  anti_ddos_package_id       = var.eip.anti_ddos_package_id

  tags = var.tags
}
