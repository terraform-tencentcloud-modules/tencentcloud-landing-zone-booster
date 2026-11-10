# create ccn route tables for each attachment vpc
resource "tencentcloud_ccn_route_table" "route_table" {
  ccn_id      = var.ccn_id
  name        = var.ccn_route_table.name
  description = var.ccn_route_table.desc
}

# create route table input policies
resource "tencentcloud_ccn_route_table_input_policies" "input_policies" {
  count = length(var.ccn_route_table.input_policies) > 0 ? 1 : 0

  ccn_id         = var.ccn_id
  route_table_id = tencentcloud_ccn_route_table.route_table.id

  dynamic "policies" {
    for_each = var.ccn_route_table.input_policies
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
  count = length(var.ccn_route_table.associate_instances) > 0 ? 1 : 0

  ccn_id         = var.ccn_id
  route_table_id = tencentcloud_ccn_route_table.route_table.id

  dynamic "instances" {
    for_each = var.ccn_route_table.associate_instances
    content {
      instance_id   = instances.value.instance_id
      instance_type = instances.value.instance_type
    }
  }
}

# create route table broadcast policy for each route table
resource "tencentcloud_ccn_route_table_broadcast_policies" "broadcast_policies" {
  count = length(var.ccn_route_table.broadcast_policies) > 0 ? 1 : 0

  ccn_id         = var.ccn_id
  route_table_id = tencentcloud_ccn_route_table.route_table.id

  dynamic "policies" {
    for_each = var.ccn_route_table.broadcast_policies
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
