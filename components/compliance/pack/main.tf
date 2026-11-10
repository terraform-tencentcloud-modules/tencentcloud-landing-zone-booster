# Get the full list of system (preset) compliance packs
data "tencentcloud_system_config_compliance_packs" "system" {}

locals {
  # Filter the target system compliance pack by compliance_pack_id
  target_pack_list = [
    for pack in data.tencentcloud_system_config_compliance_packs.system.compliance_pack_list : pack
    if (var.system_compliance_pack_id != null && pack.compliance_pack_id == var.system_compliance_pack_id) ||
       (var.system_compliance_pack_name != null && pack.compliance_pack_name == var.system_compliance_pack_name)
  ]

  target_pack = length(local.target_pack_list) > 0 ? local.target_pack_list[0] : null

  # Map the source pack rules into the structure required by tencentcloud_config_compliance_pack.
  # `identifier` is the only required attribute per rule; the rest are optional but carried over
  # from the source pack for completeness.
  source_config_rules = local.target_pack != null ? [
    for rule in local.target_pack.config_rules : {
      identifier              = rule.identifier
      rule_name               = rule.rule_name
      description             = rule.description
      risk_level              = rule.risk_level
      managed_rule_identifier = null
      config_rule_id          = null
      compliance_pack_id      = null
      input_parameter         = []
    }
    if !contains(var.exclude_rules, rule.identifier)
  ] : []

  # Normalize user-provided custom rules into the same structure.
  custom_config_rules_mapped = [
    for rule in var.custom_config_rules : {
      identifier              = rule.identifier
      rule_name               = rule.rule_name
      description             = rule.description
      risk_level              = rule.risk_level
      managed_rule_identifier = rule.managed_rule_identifier
      config_rule_id          = rule.config_rule_id
      compliance_pack_id      = rule.compliance_pack_id
      input_parameter         = rule.input_parameter
    }
  ]

  # Final rule set: source rules (minus any overridden by custom) + custom rules.
  # Custom rules sharing an identifier with a source rule override that source rule.
  custom_identifiers  = [for r in local.custom_config_rules_mapped : r.identifier]
  merged_config_rules = concat(
    [for r in local.source_config_rules : r if !contains(local.custom_identifiers, r.identifier)],
    local.custom_config_rules_mapped
  )
}

# Create a custom compliance pack based on the system compliance pack
resource "tencentcloud_config_compliance_pack" "pack" {
  compliance_pack_name = var.compliance_pack_name
  risk_level           = var.risk_level
  description          = var.description
  status               = var.status

  dynamic "config_rules" {
    for_each = local.merged_config_rules
    content {
      identifier              = config_rules.value.identifier
      rule_name               = config_rules.value.rule_name
      description             = config_rules.value.description
      risk_level              = config_rules.value.risk_level
      managed_rule_identifier = config_rules.value.managed_rule_identifier
      config_rule_id          = config_rules.value.config_rule_id

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
}
