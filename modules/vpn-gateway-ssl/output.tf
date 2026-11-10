output "vpn_ssl_server_id" {
  description = "The Id of VPN SSL Server."
  value       = concat(tencentcloud_vpn_ssl_server.server[*].id, [""])[0]
}

output "vpn_ssl_client_id" {
  description = "The Id of VPN SSL Client."
  value       = concat(tencentcloud_vpn_ssl_client.client[*].id, [""])[0]
}