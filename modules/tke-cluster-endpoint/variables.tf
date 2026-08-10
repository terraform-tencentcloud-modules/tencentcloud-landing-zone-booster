variable "cluster_id" {
  type        = string
  description = "existing cluster id, used when create_cluster is false"
}

# public access
variable "cluster_public_access" {
  type        = bool
  default     = false
  description = "Specify whether to open cluster public access."
}

variable "cluster_internet_domain" {
  type        = string
  default     = null
  description = "Domain name for cluster Kube-apiserver internet access. Be careful if you modify value of this parameter, the cluster_external_endpoint value may be changed automatically too"
}

variable "cluster_security_group_id" {
  type        = string
  default     = null
  description = "Name to use on cluster security group"
}

# private access
variable "cluster_private_access" {
  type        = bool
  default     = false
  description = "Specify whether to open cluster private access."
}

variable "cluster_intranet_domain" {
  type        = string
  default     = null
  description = "Domain name for cluster Kube-apiserver intranet access. Be careful if you modify value of this parameter, the pgw_endpoint value may be changed automatically too."
}

variable "cluster_private_access_subnet_id" {
  type        = string
  default     = null
  description = "Specify subnet_id for cluster private access."
}