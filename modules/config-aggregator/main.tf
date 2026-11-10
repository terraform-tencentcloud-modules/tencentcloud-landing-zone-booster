resource "tencentcloud_config_aggregator" "this" {
  name        = var.name
  description = var.description
  type        = var.type
  owner_uin   = var.owner_uin

  # Member accounts are only relevant for a CUSTOM aggregator. For RD (global)
  # aggregators the members are maintained by the cloud and must not be set here.
  dynamic "aggregator_accounts" {
    for_each = var.type == "CUSTOM" ? var.aggregator_accounts : []
    content {
      member_uin  = aggregator_accounts.value.member_uin
      member_name = aggregator_accounts.value.member_name
    }
  }
}