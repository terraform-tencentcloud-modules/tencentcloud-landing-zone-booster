variable "cluster_id" {
  type        = string
  description = "existing cluster id, used when create_cluster is false"
}

variable "vpc_id" {
  type        = string
  description = "Specify the vpc_id of tke cluster."
}

variable "node_pool" {
  description = "Map of self-managed node pool definitions to create. see `tencentcloud_kubernetes_node_pool` "
  type        = any
  default     = {}
}