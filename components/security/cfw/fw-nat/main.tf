locals {
  inbound_uuid_list = [ for idx, policy in var.inbound_policies : tencentcloud_cfw_nat_policy.inbounds[idx].uuid ]
  outbound_uuid_list = [ for idx, policy in var.outbound_policies : tencentcloud_cfw_nat_policy.outbounds[idx].uuid ]
}

resource "tencentcloud_cfw_nat_instance" "instance" {
  mode         = var.mode
  name         = var.name
  width        = var.width
  zone_set     = var.zone_set
  cross_a_zone = var.cross_a_zone

  # Create mode (mode = 0): Use new_mode_items to configure new NAT firewall instance
  dynamic "new_mode_items" {
    for_each = var.mode == 0 ? var.new_mode_items : []
    content {
      eips    = new_mode_items.value.eips
      vpc_list = new_mode_items.value.vpc_list
    }
  }

  # Access mode (mode = 1): Use nat_gw_list to access existing NAT gateways
  nat_gw_list = var.mode == 1 ? var.nat_gw_list : null
}

resource "tencentcloud_cfw_nat_firewall_switch" "switch" {
  count = length(var.switches)

  nat_ins_id = tencentcloud_cfw_nat_instance.instance.id
  enable     = var.switches[count.index].enable
  subnet_id  = var.switches[count.index].subnet_id

  depends_on = [ tencentcloud_cfw_nat_instance.instance ]
}

resource "tencentcloud_cfw_nat_policy" "inbounds" {
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

resource "tencentcloud_cfw_nat_policy" "outbounds" {
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

resource "tencentcloud_cfw_nat_policy_order_config" "policies_order" {
  inbound_rule_uuid_list = local.inbound_uuid_list
  outbound_rule_uuid_list = local.outbound_uuid_list

  depends_on = [
    tencentcloud_cfw_nat_policy.inbounds,
    tencentcloud_cfw_nat_policy.outbounds
  ]
}