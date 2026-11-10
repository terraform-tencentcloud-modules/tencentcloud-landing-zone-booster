variable "create" {
  type        = bool
  default     = true
  description = "Whether to create share unit and related resources."
}

variable "name" {
  type        = string
  default     = ""
  description = "The name of the share unit."
}

variable "area" {
  type        = string
  default     = ""
  description = "The area of the share unit."
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of the share unit."
}

variable "unit_member_uins" {
  type        = list(string)
  default     = []
  description = "List of member UINs to be added to the share unit."
}

variable "unit_resources" {
  description = "A map of resources to be added to the share unit."
  type = map(object({
    type                = string
    product_resource_id = string
  }))
  default = {}
}