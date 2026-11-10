################################################################################
### CAM OIDC config data source variables
################################################################################
variable "name" {
  type        = string
  description = "Name of the OIDC identity provider config to query."
}

variable "result_output_file" {
  type        = string
  default     = null
  description = "Used to save the query results to a local file."
}
