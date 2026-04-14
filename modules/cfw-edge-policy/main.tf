locals {
  inbound_uuid_list = [ for idx, policy in var.inbound_policies : tencentcloud_cfw_edge_policy.inbounds[idx].uuid ]
  outbound_uuid_list = [ for idx, policy in var.outbound_policies : tencentcloud_cfw_edge_policy.outbounds[idx].uuid ]
}

resource "tencentcloud_cfw_edge_policy" "inbounds" {
  for_each = { for idx, policy in var.inbound_policies : idx => policy }

  direction      = 1
  port           = each.value.port
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  source_content = each.value.source_content
  source_type    = each.value.source_type
  target_content = each.value.target_content
  target_type    = each.value.target_type
  
  # optional
  description       = each.value.description
  enable            = each.value.enable
  param_template_id = each.value.param_template_id
  scope             = each.value.scope
}

resource "tencentcloud_cfw_edge_policy" "outbounds" {
  for_each = { for idx, policy in var.outbound_policies : idx => policy }

  direction      = 0
  port           = each.value.port
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  source_content = each.value.source_content
  source_type    = each.value.source_type
  target_content = each.value.target_content
  target_type    = each.value.target_type
  
  # optional
  description       = each.value.description
  enable            = each.value.enable
  param_template_id = each.value.param_template_id
  scope             = each.value.scope
}

resource "tencentcloud_cfw_edge_policy_order_config" "policies_order" {
  inbound_rule_uuid_list  = local.inbound_uuid_list
  outbound_rule_uuid_list = local.outbound_uuid_list

  depends_on = [
    tencentcloud_cfw_edge_policy.inbounds,
    tencentcloud_cfw_edge_policy.outbounds
  ]
}