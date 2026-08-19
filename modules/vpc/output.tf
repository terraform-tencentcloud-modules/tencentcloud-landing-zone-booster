output "vpc_id" {
  description = "The id of vpc."
  value       = tencentcloud_vpc.vpc.id
}

output "vpc_subnets" {
  description = "The id of subnet."
  value       = local.vpc_subnets
}