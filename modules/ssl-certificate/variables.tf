variable "project_id" {
  type        = number
  description = "(Optional) Project ID of the SSL certificate. Default is `0`."
  default     = 0
}

variable "name" {
  type        = string
  description = "(Optional) Name of the SSL certificate."
  default     = ""
}

variable "type" {
  type        = string
  description = "(Required) Type of the SSL certificate. Valid values: `CA` and `SVR`."
}

variable "cert" {
  type        = string
  description = "(Required) Content of the SSL certificate. Not allowed newline at the start and end."
}

variable "key" {
  type        = string
  description = "(Optional) Key of the SSL certificate and required when certificate type is `SVR`. Not allowed newline at the start and end."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags of the SSL certificate."
}