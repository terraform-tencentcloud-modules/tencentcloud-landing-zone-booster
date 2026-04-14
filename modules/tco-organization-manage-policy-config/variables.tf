variable "organization_id" {
  type        = number
  description = "Organization ID"
}

variable "policy_type" {
  type        = string
  description = "Policy type. Default value is SERVICE_CONTROL_POLICY.\nValid values:\n  - `SERVICE_CONTROL_POLICY`: Service control policy.\n  - `TAG_POLICY`: Tag policy."
  default     = "SERVICE_CONTROL_POLICY"
}