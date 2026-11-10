variable "org_manage_policies" {
  description = "Organization management policy"
  type = list(object({
    name        = string # Policy name.\nThe length is 1~128 characters, which can include Chinese characters, English letters, numbers, and underscores.
    content     = string # Policy content. Refer to the CAM policy syntax.
    type        = optional(string, "SERVICE_CONTROL_POLICY") # Policy type. Default value is SERVICE_CONTROL_POLICY. Valid values:`SERVICE_CONTROL_POLICY`: Service control policy. `TAG_POLICY`: Tag policy.
    description = optional(string, "") # Policy description.
  }))
}