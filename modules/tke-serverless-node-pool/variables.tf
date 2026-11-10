variable "cluster_id" {
  type        = string
  description = "existing cluster id, used when create_cluster is false"
}

variable "serverless_node_pool" {
  description = "Map of self-managed serverless node pool definitions to create. see `tencentcloud_kubernetes_serverless_node_pool` "
  type        = list(object({
    name = string #serverless node pool name.
    # node list of serverless node pool.
    serverless_nodes = list(object({
      display_name = optional(string)
      subnet_id    = string
    }))
    # security groups of serverless node pool.
    security_group_ids = optional(list(string))
    # labels of serverless node.
    labels = optional(map(string))
    # taints of serverless node. effect valid values: NoSchedule, PreferNoSchedule, NoExecute.
    taints = optional(list(object({
      key    = string # Key of the taint. The taint key name does not exceed 63 characters, only supports English, numbers,'/','-', and does not allow beginning with ('/').
      value  = string # Value of the taint.
      effect = string # Effect of the taint. Valid values are: `NoSchedule`, `PreferNoSchedule`, `NoExecute`.
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for pool in var.serverless_node_pool :
      alltrue([
        for taint in pool.taints : contains(["NoSchedule", "PreferNoSchedule", "NoExecute"], taint.effect)
      ])
    ])
    error_message = "Effect must be one of: NoSchedule, PreferNoSchedule, NoExecute."
  }
}