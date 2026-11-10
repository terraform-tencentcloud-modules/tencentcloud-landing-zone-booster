output "fw_group_id" {
  description = "Firewall group ID for policy configuration."
  value       = tencentcloud_cfw_vpc_instance.vpc_instance.fw_group_id
}

output "vpc_instances" {
  description = "vpc firewall instance list"
  value       = local.vpc_instances
}