###############################################################################
### Edgeone Zone ssl certificate outputs
###############################################################################
output "cert_id" {
  description = "ID of the certificate config"
  value       = try(tencentcloud_teo_certificate_config.cert[0].id, null)
}
