variable "create_policy" {
  description = "Whether to create the CAM policy"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of CAM policy."
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the CAM policy."
  type        = string
  default     = "CAM Policy"
}

variable "policy" {
  description = "Document of the CAM policy. The syntax refers to CAM POLICY. "
  type        = string
  default     = "{}"
}

variable "allowed_services" {
  description = "List of services to allow Describe options. Service name should be the same as corresponding service CAM prefix. See what it is for each service here https://www.tencentcloud.com/document/product/598/10588"
  type        = list(string)
  default     = []
}

variable "additional_policy" {
  description = "policy if you want to add custom actions"
  type = list(object({
    action   = list(string)
    effect   = string
    resource = list(string)
  }))
  default = []
}