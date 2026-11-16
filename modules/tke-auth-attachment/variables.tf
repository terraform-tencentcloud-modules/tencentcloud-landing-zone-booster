################################################################################
### TKE cluster authentication options attachment variables
################################################################################
variable "cluster_id" {
  type        = string
  description = "ID of the TKE cluster to attach the authentication options to."
}

variable "use_tke_default" {
  type        = bool
  default     = null
  description = "If set to `true`, the `issuer` and `jwks_uri` will be generated automatically by TKE. Do not set `issuer` and `jwks_uri` at the same time."
}

variable "issuer" {
  type        = string
  default     = null
  description = "Specify service-account-issuer. If `use_tke_default` is set to `true`, do not set this field."
}

variable "jwks_uri" {
  type        = string
  default     = null
  description = "Specify service-account-jwks-uri. If `use_tke_default` is set to `true`, do not set this field."
}

variable "auto_create_discovery_anonymous_auth" {
  type        = bool
  default     = false
  description = "If set to `true`, the rbac rule will be created automatically which allows anonymous user to access `/.well-known/openid-configuration` and `/openid/v1/jwks`."
}

variable "auto_create_oidc_config" {
  type        = bool
  default     = null
  description = "Creating an identity provider (OIDC config)."
}

variable "auto_create_client_id" {
  type        = list(string)
  default     = []
  description = "Creating ClientId list of the identity provider (OIDC config)."
}

variable "auto_install_pod_identity_webhook_addon" {
  type        = bool
  default     = null
  description = "Creating the PodIdentityWebhook component. If `auto_create_oidc_config` is true, this field must be set to true."
}

################################################################################
### CAM OIDC config data variables
################################################################################
variable "result_output_file" {
  type        = string
  default     = null
  description = "Used to save the query results to a local file."
}