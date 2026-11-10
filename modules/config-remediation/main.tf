resource "tencentcloud_config_remediation" "this" {
  for_each = var.remediations

  rule_id                 = each.value.rule_id
  remediation_type        = each.value.remediation_type
  remediation_template_id = each.value.remediation_template_id
  invoke_type             = each.value.invoke_type
  source_type             = each.value.source_type
}
