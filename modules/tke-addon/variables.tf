variable "cluster_id" {
  type        = string
  description = "existing cluster id, used when create_cluster is false"
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `addon_name`, see `tencentcloud_kubernetes_addon`"
  type = list(object({
    addon_name    = string # Name of addon.
    addon_version = optional(string) # Version of addon. If no set, the latest version will be installed by default.
    raw_values    = optional(string) # Params of addon, base64 encoded json format.
  }))
  default = []
}