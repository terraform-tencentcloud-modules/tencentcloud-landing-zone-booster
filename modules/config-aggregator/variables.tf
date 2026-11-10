variable "name" {
  description = "Aggregator name."
  type        = string
}

variable "description" {
  description = "Aggregator description."
  type        = string
}

variable "type" {
  description = "Aggregator type. Valid values: \"RD\" (global aggregator, members derived from resource directory), \"CUSTOM\" (custom aggregator, must specify aggregator_accounts with at least one member). ForceNew."
  type        = string

  validation {
    condition     = contains(["RD", "CUSTOM"], var.type)
    error_message = "The type of an aggregator must be either \"RD\" or \"CUSTOM\"."
  }
}

variable "owner_uin" {
  description = "Creator UIN of the aggregator. Required by Describe/Update/Delete APIs. ForceNew."
  type        = string
}

variable "aggregator_accounts" {
  description = "Member accounts of the aggregator. Required when type = \"CUSTOM\" (at least one); ignored when type = \"RD\" (members derived from the resource directory). Up to 100 entries."
  type = list(object({
    member_uin  = number
    member_name = string
  }))
  default = []

  validation {
    condition     = var.type == "RD" || (var.type == "CUSTOM" && length(var.aggregator_accounts) > 0)
    error_message = "When type is \"CUSTOM\", aggregator_accounts must contain at least one member account; when type is \"RD\", aggregator_accounts must be empty (members are derived from the resource directory)."
  }
}