variable "logset_name" {
  description = "The logset name."
  type        = string
}

variable "logset_tags" {
  description = <<-EOT
    Tag description list (CLS resource). Mutually exclusive with `tags` (provider: ConflictsWith).
    - The CLS API supports up to 10 tag key-value pairs; duplicate keys are not allowed.
    - Defaults to `null` (NOT `[]`) so the attribute stays Computed: values read back from the
      CLS API are kept and produce no diff. Passing `[]` means "explicitly clear all tags".
  EOT

  type = list(object({
    key   = string # Tag key.   (Required in provider schema)
    value = string # Tag value. (Required in provider schema)
  }))
  default = null

  validation {
    condition     = var.logset_tags == null || length(var.logset_tags) <= 10
    error_message = "CLS logset_tags supports at most 10 tag key-value pairs."
  }

  validation {
    condition     = var.logset_tags == null || length(distinct([for t in var.logset_tags : t.key])) == length(var.logset_tags)
    error_message = "Duplicate keys are not allowed in logset_tags."
  }

  validation {
    condition     = var.logset_tags == null || alltrue([for t in var.logset_tags : t.key != "" && t.value != ""])
    error_message = "Both `key` and `value` are required for every entry in logset_tags."
  }
}