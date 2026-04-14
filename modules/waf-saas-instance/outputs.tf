output "id" {
  description = "ID of the resource."
  value       = tencentcloud_waf_saas_instance.tc_waf_saas_instance.id
}

output "instance_id" {
  description = "WAF instance id"
  value       = tencentcloud_waf_saas_instance.tc_waf_saas_instance.instance_id
}

output "edition" {
  description = "waf instance edition, clb or saas."
  value       = tencentcloud_waf_saas_instance.tc_waf_saas_instance.edition
}

output "status" {
  description = "Instance status"
  value       = tencentcloud_waf_saas_instance.tc_waf_saas_instance.status
}

output "begin_time" {
  description = "waf instance start time"
  value       = tencentcloud_waf_saas_instance.tc_waf_saas_instance.begin_time
}

output "valid_time" {
  description = "waf instance valid time."
  value       = tencentcloud_waf_saas_instance.tc_waf_saas_instance.valid_time
}