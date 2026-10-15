resource "tencentcloud_config_compliance_pack" "this" {
  for_each = var.compliance_packs

  compliance_pack_name = each.value.compliance_pack_name
  risk_level           = each.value.risk_level
  description           = each.value.description
  status               = each.value.status

  dynamic "config_rules" {
    for_each = each.value.config_rules
    content {
      identifier               = config_rules.value.identifier
      rule_name                = config_rules.value.rule_name
      description              = config_rules.value.description
      risk_level              = config_rules.value.risk_level
      managed_rule_identifier  = config_rules.value.managed_rule_identifier
      config_rule_id           = config_rules.value.config_rule_id
      compliance_pack_id       = config_rules.value.compliance_pack_id

      dynamic "input_parameter" {
        for_each = config_rules.value.input_parameter
        content {
          parameter_key = input_parameter.value.parameter_key
          type          = input_parameter.value.type
          value         = input_parameter.value.value
        }
      }
    }
  }

  # NOTE: the cloud does NOT support deleting a compliance pack via API.
  # The provider's delete returns an error ("please contact the work order for
  # processing"). Protect against accidental destroy in `terraform destroy`.
  lifecycle {
    prevent_destroy = true
  }
}
