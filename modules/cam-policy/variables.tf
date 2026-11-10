variable "create_policy" {
  description = "Whether to create the CAM policy"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of CAM policy."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the CAM policy."
  type        = string
  default     = "CAM Policy"
}

variable "policy" {
  description = "Document of the CAM policy. The syntax refers to CAM POLICY. "
  type        = string
  default     = ""
}
