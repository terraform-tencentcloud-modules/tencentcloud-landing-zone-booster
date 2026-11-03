################################################################################
### TKE cluster user permissions variables
################################################################################
variable "default_cluster_id" {
  description = "Default TKE cluster ID. Used when permission item does not specify cluster_id"
  type        = string
  default     = null
}

variable "authz_permissions" {
  description = "User authorization settings and the complete list of TKE permissions."

  type = map(object({
    target_uin  = optional(string) # Optional, cam user uin or role uin
    target_name = optional(string) # Optional, cam used name or role name
    target_type = optional(string) # Enum values: user (cam user), role (cam role).

    permissions = optional(list(object({
      cluster_id = optional(string)
      role_name  = string # Predefined roles include: tke:admin (cluster administrator), tke:ops (operations personnel), tke:dev (developer), tke:ro (read-only user), tke:ns:dev (namespace developer), tke:ns:ro (namespace read-only user), others are user-defined roles.
      role_type  = string # Enum values: cluster (cluster-level permissions, corresponding to ClusterRoleBinding), namespace (namespace-level permissions, corresponding to RoleBinding).
      is_custom  = optional(bool, false)
      namespace  = optional(string)
    })), [])
  }))

  validation {
    condition = var.default_cluster_id != null || alltrue(flatten([
      for uin, user in var.authz_permissions : [
        for p in user.permissions : p.cluster_id != null && p.cluster_id != ""
      ]
    ]))

    error_message = "When default_cluster_id is not set, the cluster_id field is required for every permission item in authz_permissions."
  }

  validation {
    condition = alltrue([
      for user in var.authz_permissions : (
        (user.target_uin != null && user.target_uin != "") ||
        (user.target_name != null && user.target_name != "")
      )
    ])

    error_message = "Each item in authz_permissions must specify at least one of target_uin or target_name; they cannot both be empty."
  }

  validation {
    condition = alltrue([
      for user in var.authz_permissions : (
        (user.target_uin != null && user.target_uin != "") ||
        (user.target_type != null &&
        user.target_type != "" &&
        contains(["user", "role"], user.target_type))
      )
    ])

    error_message = "Each item in authz_permissions must specify a non-empty target_type which must be one of: user, role."
  }
}
