resource "tencentcloud_config_rule" "this" {
  for_each = var.config_rules

  identifier      = each.value.identifier
  identifier_type = each.value.identifier_type
  rule_name       = each.value.rule_name
  resource_type   = each.value.resource_type
  risk_level      = each.value.risk_level
  description     = each.value.description
  status          = each.value.status

  dynamic "trigger_type" {
    for_each = each.value.trigger_type
    content {
      message_type                = trigger_type.value.message_type
      maximum_execution_frequency = trigger_type.value.maximum_execution_frequency
    }
  }

  dynamic "input_parameter" {
    for_each = each.value.input_parameter
    content {
      parameter_key = input_parameter.value.parameter_key
      type          = input_parameter.value.type
      value         = input_parameter.value.value
    }
  }

  dynamic "regions_scope" {
    for_each = each.value.regions_scope == null ? [] : each.value.regions_scope
    content {
      regions_scope = regions_scope.value
    }
  }

  dynamic "tags_scope" {
    for_each = each.value.tags_scope
    content {
      tag_key   = tags_scope.value.tag_key
      tag_value = tags_scope.value.tag_value
    }
  }

  dynamic "exclude_resource_ids_scope" {
    for_each = each.value.exclude_resource_ids_scope == null ? [] : each.value.exclude_resource_ids_scope
    content {
      exclude_resource_ids_scope = exclude_resource_ids_scope.value
    }
  }
}
