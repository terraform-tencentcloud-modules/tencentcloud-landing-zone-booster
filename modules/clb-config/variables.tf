variable "clb_config_name" {
  description = "Name of Customized Config."
  type        = string
  default     = "default-lb-config"
}

variable "clb_config_content" {
  description = "Content of Customized Config."
  type        = string
  default     = ""
}

variable "clb_ids" {
  description = "List of LoadBalancer Ids."
  type        = list(string)
  default     = []
}
