# Publish VPC route table entries to CCN
# This resource uses the NotifyRoutes API to publish routes to Cloud Connect Network

resource "tencentcloud_vpc_notify_routes" "notify" {
  count          = length(var.route_item_ids) > 0 ? 1 : 0
  route_table_id = var.route_table_id
  route_item_ids = var.route_item_ids
}
