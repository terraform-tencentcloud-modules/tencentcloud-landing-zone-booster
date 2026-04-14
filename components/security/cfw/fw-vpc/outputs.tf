output "vpc_instances" {
  description = "vpc firewall instance list"
  value       = local.vpc_instances
}

output "fw_group_id" {
  description = "Firewall group ID for policy configuration."
  value       = tencentcloud_cfw_vpc_instance.instance.fw_group_id
}