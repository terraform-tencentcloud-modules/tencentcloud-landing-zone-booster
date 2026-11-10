output "id" {
  value       = local.private_dns_zone_id
  description = "The ID of private_dns_zone."
}

output "domain" {
  value = var.domain
}