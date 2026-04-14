variable "org_manage_policy_targets" {
  description = "Organization management policy target"
  type = list(object({
    target_id   = number # Binding target ID of the policy. Member Uin or Department ID.
    target_type = string # Target type.\nValid values:\n  - `NODE`: Department.\n  - `MEMBER`: Check Member.
    policy_id   = number # Policy Id.
    policy_type = optional(string, "SERVICE_CONTROL_POLICY") # Policy type. Default value is SERVICE_CONTROL_POLICY.\nValid values:\n  - `SERVICE_CONTROL_POLICY`: Service control policy.\n  - `TAG_POLICY`: Tag policy.
  }))
}