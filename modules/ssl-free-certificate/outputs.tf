output "certificate_id" {
  value       = tencentcloud_ssl_free_certificate.free.id
  description = "The certificate ID."
}

output "certificate_domain" {
  value       = tencentcloud_ssl_free_certificate.free.domain
  description = "The certificate domain."
}

output "certificate_status" {
  value       = tencentcloud_ssl_free_certificate.free.status
  description = "The certificate status."
}