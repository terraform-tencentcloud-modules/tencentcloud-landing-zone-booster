output "redis_instance_id" {
  description = "ID of the Redis instance."
  value       = tencentcloud_redis_instance.redis_instance.id
}

output "redis_instance_ip" {
  description = "IP address of the Redis instance."
  value       = tencentcloud_redis_instance.redis_instance.ip
}

output "redis_instance_port" {
  description = "Port of the Redis instance."
  value       = tencentcloud_redis_instance.redis_instance.port
}
