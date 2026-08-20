################################################################################
### TKE cluster user permissions variables
################################################################################
variable "authz_uin" {
  description = "Unique identifier of the user to be authorized (supports sub-account UIN and role UIN). If not specified, current user UIN will be used"
  type        = string
  default     = null
}

variable "cluster_id" {
  description = "Default TKE cluster ID. Used when permission item does not specify cluster_id"
  type        = string
  default     = null
}

variable "permissions" {
  description = "Complete list of permissions that the user should ultimately have."
  type = list(object({
    cluster_id = optional(string)
    role_name  = string # Predefined roles include: tke:admin (cluster administrator), tke:ops (operations personnel), tke:dev (developer), tke:ro (read-only user), tke:ns:dev (namespace developer), tke:ns:ro (namespace read-only user), others are user-defined roles.
    role_type  = string # Enum values: cluster (cluster-level permissions, corresponding to ClusterRoleBinding), namespace (namespace-level permissions, corresponding to RoleBinding).
    is_custom  = optional(bool, false)
    namespace  = optional(string)
  }))
  default = []
}
