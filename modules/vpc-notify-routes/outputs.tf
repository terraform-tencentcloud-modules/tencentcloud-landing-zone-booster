output "published_to_vbc" {
  description = "Whether the routes have been published to VBC (CCN)"
  value       = try(tencentcloud_vpc_notify_routes.notify[0].published_to_vbc, false)
}

output "id" {
  description = "The ID of the notify routes resource"
  value       = try(tencentcloud_vpc_notify_routes.notify[0].id, "")
}
