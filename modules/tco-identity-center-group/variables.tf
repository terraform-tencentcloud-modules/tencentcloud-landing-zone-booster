variable "create" {
  type        = bool
  default     = true
  description = "Create or use an existed one"
}

variable "zone_id" {
  type = string
  default = ""
  description = "cic zone id, copy from console"
}

variable "groups" {
  description = "Group configs for CIC group creation. Each group contains a name and a list of user IDs."
  type = map(object({
    group_name  = string
    users       = list(number)
    description = string
  }))
}