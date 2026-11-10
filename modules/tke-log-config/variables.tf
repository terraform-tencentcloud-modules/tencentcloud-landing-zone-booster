################################################################################
# Basic Configuration
################################################################################
variable "log_config_name" {
  description = "Log config name."
  type        = string
}

variable "tke_cluster_id" {
  description = "TKE cluster ID."
  type        = string
}

variable "logset_id" {
  description = "CLS logset ID."
  type        = string
}

variable "cluster_type" {
  description = "Cluster type: tke or eks."
  type        = string
  default     = "tke"
}

################################################################################
# CLS Detail Configuration
################################################################################
variable "cls_detail" {
  description = "CLS detail configuration object."
  type = object({
    topic_id             = string                           # CLS topic ID
    region               = optional(string, "ap-jakarta")   # Tencent cloud region
    log_type             = optional(string, "json_log")     # Log type: minimalist_log, multiline_log, json_log
    log_format           = optional(string, "default")      # Log format
    storage_type         = optional(string, "hot")          # Storage type: hot, cold
    hot_period           = optional(number, 15)             # Hot storage period in days
    partition_count      = optional(number, 2)              # Number of partitions
    max_split_partitions = optional(number, 50)             # Max partitions for auto-split
    extract_rule = optional(object({
      backtracking    = optional(string, "0")               # Backtracking offset
      is_gbk          = optional(string, "false")           # Whether encoding is GBK
      json_standard   = optional(string, "true")            # Whether JSON is standard format
      un_match_upload = optional(string, "true")            # Upload unmatched logs
      un_matched_key  = optional(string, "parseFailed")     # Key name for unmatched logs
    }), {})
    indexs = optional(list(object({
      index_name = string                                   # Index field name
    })), [{ index_name = "namespace" }, { index_name = "pod_name" }, { index_name = "container_name" }])
  })
}

################################################################################
# Input Detail Configuration
#
# Mutual Exclusion Rules for containerStdout:
#   1. allContainers=true => cannot use workloads, includeLabels, excludeLabels
#   2. workloads         => cannot use includeLabels, excludeLabels, container
#   3. includeLabels/excludeLabels => cannot use workloads, namespace, excludeNamespace
#
# Mutual Exclusion Rules for containerFile:
#   1. workload          => cannot use includeLabels, excludeLabels
#   2. includeLabels/excludeLabels => cannot use workload
################################################################################
variable "input_detail" {
  description = "Log input detail configuration object."
  type = object({
    type = optional(string, "container_stdout")                       # Input type: container_stdout, container_file, host_file
    container_stdout = optional(object({
      all_containers     = optional(bool, false)                      # Collect all containers (mutex with workloads/labels)
      namespace          = optional(string, null)                     # Comma-separated namespaces (mutex with exclude_namespace)
      exclude_namespace  = optional(string, null)                     # Comma-separated excluded namespaces (mutex with namespace)
      ns_label_selector  = optional(string, null)                     # Namespace label selector expression
      container          = optional(string, null)                     # Container name filter (mutex with workloads)
      include_labels     = optional(map(string), null)                # Include pods with labels (mutex with workloads)
      exclude_labels     = optional(map(string), null)                # Exclude pods with labels (mutex with workloads)
      metadata_labels    = optional(list(string), null)               # Pod labels to collect as metadata
      custom_labels      = optional(map(string), null)                # User-defined custom metadata
      metadata_container = optional(list(string), [                   # Metadata fields to collect
        "namespace", "pod_name", "pod_ip", "pod_uid",
        "container_id", "container_name", "image_name", "cluster_id"
      ])
      workloads = optional(list(object({                              # Workload-based selection (mutex with labels/container)
        kind      = string                                            # Workload type: deployment, statefulset, daemonset, job, cronjob
        name      = string                                            # Workload name
        namespace = string                                            # Workload namespace
        container = optional(string, null)                            # Container name within workload
      })), null)
    }), null)
    container_file = optional(object({
      namespace          = optional(string, null)                     # Kubernetes namespace (required, single value)
      exclude_namespace  = optional(string, null)                     # Comma-separated excluded namespaces (mutex with namespace)
      ns_label_selector  = optional(string, null)                     # Namespace label selector expression
      container          = optional(string, null)                     # Container name filter (* for all)
      log_path           = string                                     # Log file directory (no wildcards)
      file_pattern       = optional(string, "*.log")                  # Log file name pattern (* and ? supported)
      include_labels     = optional(map(string), null)                # Include pods with labels (mutex with workload)
      exclude_labels     = optional(map(string), null)                # Exclude pods with labels (mutex with workload)
      metadata_labels    = optional(list(string), null)               # Pod labels to collect as metadata
      custom_labels      = optional(map(string), null)                # User-defined custom metadata
      metadata_container = optional(list(string), [                   # Metadata fields to collect
        "namespace", "pod_name", "pod_ip", "pod_uid",
        "container_id", "container_name", "image_name", "cluster_id"
      ])
      workload = optional(object({                                    # Single workload selection (mutex with labels)
        name      = string                                            # Workload name
        container = optional(string, null)                            # Container name within workload
      }), null)
    }), null)
    host_file = optional(object({
      log_path      = string                                          # Log file directory (no wildcards)
      file_pattern  = optional(string, "*.log")                       # Log file name pattern (* and ? supported)
      custom_labels = optional(map(string), null)                     # User-defined custom metadata
    }), null)
  })
  default = {
    type             = "container_stdout"
    container_stdout = {}
  }
}
