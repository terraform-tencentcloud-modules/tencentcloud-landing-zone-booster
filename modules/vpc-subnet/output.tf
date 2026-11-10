output "subnet_id" {
  description = "The id of subnet."
  value       = tencentcloud_subnet.subnet.*.id
}

output "availability_zone" {
  description = "The availability zone of the subnet."
  value       = tencentcloud_subnet.subnet.*.availability_zone
}