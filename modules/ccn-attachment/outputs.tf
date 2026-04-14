output "ccn_route_ids" {
  description = "The route IDs from CCN attachment (ccnr-xxxxxxxx format)"
  value       = try(tencentcloud_ccn_attachment_v2.attachment.route_ids, [])
}