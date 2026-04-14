locals {
  policy_uuid_list = [ for idx, policy in var.policies : tencentcloud_cfw_vpc_policy.policies[idx].uuid ]
}

resource "tencentcloud_cfw_vpc_policy" "policies" {
  for_each = { for idx, policy in var.policies : idx => policy }

  fw_group_id = var.fw_group_id

  description    = each.value.description
  dest_content   = each.value.dest_content
  dest_type      = each.value.dest_type
  port           = each.value.port
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  source_content = each.value.source_content
  source_type    = each.value.source_type
  # optional
  enable = try(each.value.enable, true)
}

resource "tencentcloud_cfw_vpc_policy_order_config" "policies_order" {
  rule_uuid_list = local.policy_uuid_list

  depends_on = [
    tencentcloud_cfw_vpc_policy.policies
  ]
}