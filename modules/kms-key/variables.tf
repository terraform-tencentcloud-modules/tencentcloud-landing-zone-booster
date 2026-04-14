variable "create_key" {
  description = "Whether to create the KMS key"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "Name of the KMS key"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = ""
}
variable "is_enabled" {
  description = "Whether the key is enabled"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the KMS key"
  type        = map(string)
  default     = {}
}
