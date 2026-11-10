################################################################################
### Private DNS Zone Outputs
################################################################################
output "zone_ids" {
  description = "Map of zone keys to their IDs"
  value       = { for k, v in tencentcloud_private_dns_zone.zones : k => v.id }
}

output "zone_domains" {
  description = "Map of zone keys to their domain names"
  value       = { for k, v in tencentcloud_private_dns_zone.zones : k => v.domain }
}

output "zones" {
  description = "Complete Private DNS zone resource objects"
  value       = tencentcloud_private_dns_zone.zones
}

################################################################################
### Private DNS Record Outputs
################################################################################
output "record_ids" {
  description = "Map of record keys to their IDs"
  value       = { for k, v in tencentcloud_private_dns_record.records : k => v.id }
}

output "record_sub_domains" {
  description = "Map of record keys to their sub domains"
  value       = { for k, v in tencentcloud_private_dns_record.records : k => v.sub_domain }
}

output "records" {
  description = "Complete Private DNS record resource objects"
  value       = tencentcloud_private_dns_record.records
}

################################################################################
### Private DNS Zone VPC Attachment Outputs
################################################################################
output "vpc_attachment_ids" {
  description = "Map of VPC attachment keys to their IDs"
  value       = { for k, v in tencentcloud_private_dns_zone_vpc_attachment.vpc_attachments : k => v.id }
}

output "vpc_attachments" {
  description = "Complete Private DNS zone VPC attachment resource objects"
  value       = tencentcloud_private_dns_zone_vpc_attachment.vpc_attachments
}

################################################################################
### Private DNS Forward Rule Outputs
################################################################################
output "forward_rule_ids" {
  description = "Map of forward rule keys to their IDs"
  value       = { for k, v in tencentcloud_private_dns_forward_rule.forward_rules : k => v.id }
}

output "forward_rules" {
  description = "Complete Private DNS forward rule resource objects"
  value       = tencentcloud_private_dns_forward_rule.forward_rules
}

################################################################################
### Private DNS End Point Outputs
################################################################################
output "end_point_ids" {
  description = "Map of end point keys to their IDs"
  value       = { for k, v in tencentcloud_private_dns_end_point.end_points : k => v.id }
}

output "end_points" {
  description = "Complete Private DNS end point resource objects"
  value       = tencentcloud_private_dns_end_point.end_points
}

################################################################################
### Private DNS Extend End Point Outputs
################################################################################
output "extend_end_point_ids" {
  description = "Map of extend end point keys to their IDs"
  value       = { for k, v in tencentcloud_private_dns_extend_end_point.extend_end_points : k => v.id }
}

output "extend_end_points" {
  description = "Complete Private DNS extend end point resource objects"
  value       = tencentcloud_private_dns_extend_end_point.extend_end_points
}