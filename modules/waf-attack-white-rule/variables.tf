################################################################################
# WAF attack white rule vars
################################################################################
variable "waf_attack_white_rule" {
  description = "WAF attack white rule object"
  type = object({
    name          = string                # Rule name.
    domain        = string                # Domain.
    status        = number                # Rule status.
    mode          = optional(number)      # 0: Whiten according to a specific rule ID, 1: Whiten according to the rule type.
    signature_ids = optional(set(string)) # Whitelist of rule IDs.
    type_ids      = optional(set(string)) # The whitened category rule ID.
    rules = list(object({
      match_content = string           # Matching content.
      match_field   = string           # Matching domains.
      match_method  = string           # Matching method.
      match_params  = optional(string) # Matching params.
    }))
  })
}
