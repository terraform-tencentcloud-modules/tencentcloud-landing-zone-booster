output "id" {
  description = "ID of the resource."
  value       = tencentcloud_waf_saas_domain.tc_waf_saas_domain.domain
}

output "domain_id" {
  description = "Domain ID."
  value       = tencentcloud_waf_saas_domain.tc_waf_saas_domain.id
}