variable "create" {
  type        = bool
  default     = true
  description = "Create or use an existed one"
}

variable "zone_id" {
  type = string
  default = ""
}

variable "sso_status" {
  type        = string
  default     = "Enabled"
  description = "(Optional, String) SSO enabling status. Valid values: Enabled, Disabled (default)."
}
variable "encoded_metadata_document" {
  type = string
  default = null
  description = " IdP metadata document (Base64 encoded). Provided by an IdP that supports the SAML 2.0 protocol."
}

variable "entity_id" {
  type = string
  default = null
  description = "IdP identifier"
}

variable "login_url" {
  type =string
  default = null
  description = "IdP login URL."
}

variable "x509_certificate" {
  type = string
  default = null
  description = "X509 certificate in PEM format. If this parameter is specified, all existing certificates will be replaced."
}