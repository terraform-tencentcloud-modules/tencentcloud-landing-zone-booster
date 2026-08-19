################################################################################
# CCN Routes - Publish/Withdraw routes to/from CCN
################################################################################
resource "tencentcloud_ccn_routes" "switch" {
  for_each = { for idx, route in var.routes : idx => route }

  ccn_id   = var.ccn_id
  route_id = each.value.route_id
  switch   = each.value.switch  # "on" = publish, "off" = withdraw
}
