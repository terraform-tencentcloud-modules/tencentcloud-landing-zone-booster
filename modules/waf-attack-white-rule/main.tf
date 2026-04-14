resource "tencentcloud_waf_attack_white_rule" "white_rule" {
  name          = var.waf_attack_white_rule.name
  domain        = var.waf_attack_white_rule.domain
  status        = var.waf_attack_white_rule.status
  mode          = var.waf_attack_white_rule.mode
  signature_ids = var.waf_attack_white_rule.signature_ids
  type_ids      = var.waf_attack_white_rule.type_ids

  dynamic "rules" {
    for_each = var.waf_attack_white_rule.rules
    content {
      match_content = rules.value.match_content
      match_field   = rules.value.match_field
      match_method  = rules.value.match_method
      match_params  = rules.value.match_params
    }
  }
}
