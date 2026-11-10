###############################################################################
### EdgeOne L7 Acceleration Rule outputs
###############################################################################
output "rule_id" {
  description = "The rule ID of the acceleration rule"
  value       = tencentcloud_teo_l7_acc_rule_v2.acc_rule.rule_id
}
