output "instance_id" {
  description = "id of instance."
  value       = local.create_instance ? tencentcloud_instance.instance[0].id : ""
}

output "instance_status" {
  description = "The state of instance."
  value       = local.create_instance ? tencentcloud_instance.instance[0].instance_status : ""
}

output "public_ip" {
  description = "The public ip of instance."
  value       = local.create_instance ? tencentcloud_instance.instance[0].public_ip : ""
}

output "private_ip" {
  description = "The private ip of instance."
  value       = local.create_instance ? tencentcloud_instance.instance[0].private_ip : ""
}

output "placement_group_id" {
  description = "The Placement Group Id to start the instance in."
  value       = local.create_placement_group ? tencentcloud_placement_group.this[0].id : var.placement_group_id
}