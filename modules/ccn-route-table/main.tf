locals {
  route_table_id  = [ for k, rt in tencentcloud_ccn_route_table.route_tables : rt.id ][0]
  route_table_ids = { for k, rt in tencentcloud_ccn_route_table.route_tables : k => rt.id }
}

# create ccn route tables for each attachment vpc
resource "tencentcloud_ccn_route_table" "route_tables" {
  for_each = { for rt in var.route_tables : rt.name => rt }

  ccn_id      = var.ccn_id
  name        = each.value.name
  description = each.value.desc
}

# create route table input policies
resource "tencentcloud_ccn_route_table_input_policies" "input_policies" {
  for_each = { for rt_policy in var.input_policies : rt_policy.route_table_name => rt_policy }

  ccn_id         = var.ccn_id
  route_table_id = tencentcloud_ccn_route_table.route_tables["${each.value.route_table_name}"].id
  dynamic "policies" {
    for_each = each.value.policies
    content {
      action      = policies.value.action
      description = policies.value.desc
      dynamic "route_conditions" {
        for_each = policies.value.route_conditions
        content {
          name          = route_conditions.value.name
          values        = route_conditions.value.values
          match_pattern = route_conditions.value.match_pattern
        }
      }
    }
  }
}

# route table associate instance
resource "tencentcloud_ccn_route_table_associate_instance_config" "associate" {
  for_each = { for instance in var.associate_instances : instance.route_table_name => instance }

  ccn_id         = var.ccn_id
  route_table_id = tencentcloud_ccn_route_table.route_tables["${each.value.route_table_name}"].id
  dynamic "instances" {
    for_each = each.value.instances
    content {
      instance_id   = instances.value.instance_id
      instance_type = instances.value.instance_type
    }
  }
}

# create route table broadcast policy for each route table
resource "tencentcloud_ccn_route_table_broadcast_policies" "broadcast_policies" {
  for_each = { for rt_name in var.broadcast_policies : rt_name.route_table_name => rt_name }

  ccn_id         = var.ccn_id
  route_table_id = tencentcloud_ccn_route_table.route_tables["${each.value.route_table_name}"].id

  dynamic "policies" {
    for_each = each.value.policies
    content {
      action      = policies.value.action
      description = policies.value.desc
      dynamic "route_conditions" {
        for_each = policies.value.route_conditions
        content {
          name          = route_conditions.value.name
          values        = route_conditions.value.values
          match_pattern = route_conditions.value.match_pattern
        }
      }
      dynamic "broadcast_conditions" {
        for_each = policies.value.broadcast_conditions
        content {
          name          = broadcast_conditions.value.name
          values        = broadcast_conditions.value.values
          match_pattern = broadcast_conditions.value.match_pattern
        }
      }
    }
  }
}
