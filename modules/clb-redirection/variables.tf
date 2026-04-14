variable "clb_redirections" {
  description = "The CLB redirection config list."
  type = list(object({
    clb_id                  = string           # ID of the CLB instance
    target_listener_id      = string           # ID of the target listener
    target_rule_id          = string           # ID of the target rule 
    source_listener_id      = optional(string) # ID of the source listener
    source_rule_id          = optional(string) # Rule ID of the source listener
    delete_all_auto_rewrite = optional(bool)   # Whether to delete all auto rewrite
    is_auto_rewrite         = optional(bool)   # Whether to auto rewrite
  }))
  default = []
}