variable "member_uin_list" {
  description = "Member account UIN, which is also the UIN of the account to which the baseline is applied."
  type        = list(number)
}

variable "baseline_config_items" {
  description = "List of baseline item configuration information."
  type = list(object({
    identifier    = string           # A unique identifier for an Account Factory baseline item, which can only contain English letters, digits, and @,._[]-:()+=. It must be 2-128 characters long.Note: This field may return null, indicating that no valid values can be obtained.
    configuration = optional(string) # Account Factory baseline item configuration. Different items have different parameters.Note: This field may return null, indicating that no valid values can be obtained.
  }))
}