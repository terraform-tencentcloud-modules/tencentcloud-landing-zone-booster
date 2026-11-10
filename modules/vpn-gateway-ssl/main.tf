################################################################################
# VPN Ssl Server
################################################################################
resource "tencentcloud_vpn_ssl_server" "server" {
  local_address       = var.local_address
  remote_address      = var.remote_address
  ssl_vpn_server_name = var.ssl_vpn_server_name
  vpn_gateway_id      = var.vpn_gateway_id
  ssl_vpn_protocol    = var.ssl_vpn_protocol
  ssl_vpn_port        = var.ssl_vpn_port
  integrity_algorithm = var.integrity_algorithm
  encrypt_algorithm   = var.encrypt_algorithm
  compress            = var.compress
}

################################################################################
# VPN Ssl Client
################################################################################
resource "tencentcloud_vpn_ssl_client" "client" {
  ssl_vpn_server_id   = tencentcloud_vpn_ssl_server.server.id
  ssl_vpn_client_name = var.ssl_vpn_client_name
}