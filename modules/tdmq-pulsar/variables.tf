################################################################################
# Zone list by product
################################################################################
variable "zone_query_product" {
  description = "Product name for which to query the zones."
  type        = string
  default     = "vpc"
}

################################################################################
# TDMQ for Pulsar Professional Cluster
# NOTE: tencentcloud_tdmq_instance is DEPRECATED (Create returns an error);
#       use tencentcloud_tdmq_professional_cluster as the cluster/instance.
################################################################################
variable "cluster" {
  description = "(Required) TDMQ for Pulsar professional cluster configuration. NOTE: tencentcloud_tdmq_instance is deprecated; use professional_cluster."
  type = object({
    cluster_name     = string           # Name of cluster. No Chinese/special chars except - and _, <=64 chars.
    zone_names       = list(string)     # Multi-AZ: 3 zone names.
    product_name     = string           # Cluster spec code, e.g. "pulsar.2u4g". See Professional Cluster Specifications.
    instance_version = string           # Cluster version information. User can specify a version when creating the cluster.
    storage_size     = number           # Storage specification in GB.
    auto_renew_flag  = number           # 1: auto renew on, 0: off.
    time_span        = optional(number) # Purchase duration 1~50, default 1. ForceNew.
    auto_voucher     = optional(number) # 1: use voucher, 0: no. Default 0. ForceNew.
    vpc_id           = optional(string) # VPC to deploy the cluster into (private access). Must be set together with subnet_id.
    subnet_id        = optional(string) # Subnet for the VPC above. Must be set together with vpc_id.
    tags             = optional(map(string), {})
  })

  validation {
    condition     = (var.cluster.vpc_id == null) == (var.cluster.subnet_id == null)
    error_message = "vpc_id and subnet_id must be provided together (both or neither)."
  }
}

################################################################################
# Namespaces
################################################################################
variable "namespaces" {
  description = "(Optional) List of TDMQ namespaces created under the cluster."
  type = list(object({
    environ_name = string # Namespace (environment) name.
    msg_ttl      = number # Expiration time of unconsumed message, in seconds.
    remark       = optional(string)
    retention_policy = optional(object({
      time_in_minutes = optional(number) # Retention time in minutes.
      size_in_mb      = optional(number) # Retention size in MB.
    }))
    tags = optional(list(object({
      tag_key   = string
      tag_value = string
    })), [])
  }))
  default = []
}

################################################################################
# Roles
################################################################################
variable "roles" {
  description = "(Optional) List of TDMQ roles created under the cluster."
  type = list(object({
    role_name = string # Role name.
    remark    = string # Role description (required by API).
  }))
  default = []
}

################################################################################
# Topics
################################################################################
variable "topics" {
  description = "(Optional) List of TDMQ topics created under the cluster."
  type = list(object({
    environ_id        = string           # Namespace (environ) name this topic belongs to.
    topic_name        = string           # Topic name.
    partitions        = number           # Number of partitions.
    pulsar_topic_type = optional(number) # 0: non-persistent non-partitioned, 1: non-persistent partitioned, 2: persistent non-partitioned, 3: persistent partitioned.
    remark            = optional(string)
    tags = optional(list(object({
      tag_key   = string
      tag_value = string
    })), [])
  }))
  default = []
}

################################################################################
# Subscriptions
################################################################################
variable "subscriptions" {
  description = "(Optional) List of TDMQ subscriptions created under the cluster."
  type = list(object({
    environment_id           = string # Namespace (environ) name.
    topic_name               = string # Topic name to subscribe to.
    subscription_name        = string # Subscriber name (<=128 chars).
    remark                   = optional(string)
    auto_create_policy_topic = optional(bool, false) # Auto create DLQ/retry topic.
    auto_delete_policy_topic = optional(bool, false) # Auto delete DLQ/retry topic (only when auto_create_policy_topic=true).
  }))

  validation {
    condition = alltrue([
      for s in var.subscriptions :
      s.auto_create_policy_topic || !s.auto_delete_policy_topic
    ])
    error_message = "auto_delete_policy_topic can only be true when auto_create_policy_topic is true."
  }

  default = []
}

################################################################################
# Namespace-Role Attachments
################################################################################
variable "namespace_role_attachments" {
  description = "(Optional) List of namespace-role permission attachments."
  type = list(object({
    environ_id  = string       # Namespace (environ) name.
    role_name   = string       # Role name to attach.
    permissions = list(string) # Permissions, e.g. ["produce", "consume"].
  }))
  default = []
}
