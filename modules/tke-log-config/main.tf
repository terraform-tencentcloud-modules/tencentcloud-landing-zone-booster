################################################################################
# Local Variables
################################################################################
locals {
  # Build extract rule with snake_case to camelCase conversion
  extract_rule = {
    backtracking  = var.cls_detail.extract_rule.backtracking
    isGBK         = var.cls_detail.extract_rule.is_gbk
    jsonStandard  = var.cls_detail.extract_rule.json_standard
    unMatchUpload = var.cls_detail.extract_rule.un_match_upload
    unMatchedKey  = var.cls_detail.extract_rule.un_matched_key
  }

  # Build indexs array with camelCase keys
  indexs = [for idx in var.cls_detail.indexs : { indexName = idx.index_name }]

  # Build clsDetail object
  cls_detail = {
    topicId            = var.cls_detail.topic_id
    region             = var.cls_detail.region
    logType            = var.cls_detail.log_type
    logFormat          = var.cls_detail.log_format
    storageType        = var.cls_detail.storage_type
    hotPeriod          = var.cls_detail.hot_period
    partitionCount     = var.cls_detail.partition_count
    maxSplitPartitions = var.cls_detail.max_split_partitions
    extractRule        = local.extract_rule
    indexs             = local.indexs
  }

  #-----------------------------------------------------------------------------
  # containerStdout mutual exclusion handling
  # allContainers=true => cannot use workloads, includeLabels, excludeLabels
  # workloads          => cannot use includeLabels, excludeLabels, container
  # labels             => cannot use workloads, namespace, excludeNamespace
  #-----------------------------------------------------------------------------
  stdout_cfg = var.input_detail.container_stdout

  stdout_has_workloads     = local.stdout_cfg != null ? (local.stdout_cfg.workloads != null && length(local.stdout_cfg.workloads) > 0) : false
  stdout_has_labels        = local.stdout_cfg != null ? (local.stdout_cfg.include_labels != null || local.stdout_cfg.exclude_labels != null) : false
  stdout_has_container     = local.stdout_cfg != null ? (local.stdout_cfg.container != null) : false
  stdout_has_all           = local.stdout_cfg != null ? local.stdout_cfg.all_containers : false

  # Mutex validations
  stdout_all_violation     = local.stdout_has_all && (local.stdout_has_workloads || local.stdout_has_labels)
  stdout_workload_violation = local.stdout_has_workloads && (local.stdout_has_labels || local.stdout_has_container)

  # Build containerStdout object
  container_stdout = local.stdout_cfg != null ? merge(
    {
      metadataContainer = local.stdout_cfg.metadata_container
      includeLabels     = local.stdout_has_workloads || local.stdout_has_all ? {} : (local.stdout_cfg.include_labels != null ? local.stdout_cfg.include_labels : {})
      excludeLabels     = local.stdout_has_workloads || local.stdout_has_all ? {} : (local.stdout_cfg.exclude_labels != null ? local.stdout_cfg.exclude_labels : {})
    },
    local.stdout_has_all ? { allContainers = true } : {},
    # Namespace (comma-separated string, mutex with excludeNamespace)
    local.stdout_cfg.namespace != null ? { namespace = local.stdout_cfg.namespace } : {},
    local.stdout_cfg.exclude_namespace != null && local.stdout_cfg.namespace == null ? { excludeNamespace = local.stdout_cfg.exclude_namespace } : {},
    local.stdout_cfg.ns_label_selector != null && local.stdout_cfg.ns_label_selector != "" ? { nsLabelSelector = local.stdout_cfg.ns_label_selector } : {},
    # Metadata labels & custom labels
    local.stdout_cfg.metadata_labels != null ? { metadataLabels = local.stdout_cfg.metadata_labels } : {},
    local.stdout_cfg.custom_labels != null ? { customLabels = local.stdout_cfg.custom_labels } : {},
    # Workload mode
    local.stdout_has_workloads && !local.stdout_has_all ? {
      workloads = [for w in local.stdout_cfg.workloads : merge(
        { kind = w.kind, name = w.name, namespace = w.namespace },
        w.container != null ? { container = w.container } : {}
      )]
    } : {},
    # Container filter (only when not using workloads and not allContainers)
    !local.stdout_has_workloads && !local.stdout_has_all && local.stdout_has_container ? { container = local.stdout_cfg.container } : {}
  ) : null

  #-----------------------------------------------------------------------------
  # containerFile mutual exclusion handling
  # workload => cannot use includeLabels, excludeLabels
  # labels   => cannot use workload
  #-----------------------------------------------------------------------------
  file_cfg = var.input_detail.container_file

  file_has_workload = local.file_cfg != null ? (local.file_cfg.workload != null) : false
  file_has_labels   = local.file_cfg != null ? (local.file_cfg.include_labels != null || local.file_cfg.exclude_labels != null) : false

  # Mutex validation
  file_mutex_violation = local.file_has_workload && local.file_has_labels

  # Build containerFile object
  container_file = local.file_cfg != null ? merge(
    {
      metadataContainer = local.file_cfg.metadata_container
      logPath           = local.file_cfg.log_path
      filePattern       = local.file_cfg.file_pattern
      includeLabels     = local.file_has_workload ? {} : (local.file_cfg.include_labels != null ? local.file_cfg.include_labels : {})
      excludeLabels     = local.file_has_workload ? {} : (local.file_cfg.exclude_labels != null ? local.file_cfg.exclude_labels : {})
    },
    # Namespace (single value for containerFile)
    local.file_cfg.namespace != null ? { namespace = local.file_cfg.namespace } : {},
    local.file_cfg.exclude_namespace != null && local.file_cfg.namespace == null ? { excludeNamespace = local.file_cfg.exclude_namespace } : {},
    local.file_cfg.ns_label_selector != null && local.file_cfg.ns_label_selector != "" ? { nsLabelSelector = local.file_cfg.ns_label_selector } : {},
    # Container filter
    local.file_cfg.container != null ? { container = local.file_cfg.container } : {},
    # Metadata labels & custom labels
    local.file_cfg.metadata_labels != null ? { metadataLabels = local.file_cfg.metadata_labels } : {},
    local.file_cfg.custom_labels != null ? { customLabels = local.file_cfg.custom_labels } : {},
    # Workload mode (single workload: name + optional container)
    local.file_has_workload ? {
      workload = merge(
        { name = local.file_cfg.workload.name },
        local.file_cfg.workload.container != null ? { container = local.file_cfg.workload.container } : {}
      )
    } : {}
  ) : null

  #-----------------------------------------------------------------------------
  # hostFile
  #-----------------------------------------------------------------------------
  host_cfg = var.input_detail.host_file

  host_file = local.host_cfg != null ? merge(
    {
      logPath     = local.host_cfg.log_path
      filePattern = local.host_cfg.file_pattern
    },
    local.host_cfg.custom_labels != null ? { customLabels = local.host_cfg.custom_labels } : {}
  ) : null

  #-----------------------------------------------------------------------------
  # Build inputDetail object
  #-----------------------------------------------------------------------------
  input_detail = {
    type            = var.input_detail.type
    containerStdout = var.input_detail.type == "container_stdout" ? local.container_stdout : null
    containerFile   = var.input_detail.type == "container_file" ? local.container_file : null
    hostFile        = var.input_detail.type == "host_file" ? local.host_file : null
  }

  # Build complete log_config object
  log_config = {
    apiVersion = "cls.cloud.tencent.com/v1"
    kind       = "LogConfig"
    metadata   = { name = var.log_config_name }
    spec = {
      clsDetail   = local.cls_detail
      inputDetail = local.input_detail
    }
  }
}

################################################################################
# TKE Log Config Resource
################################################################################
resource "tencentcloud_kubernetes_log_config" "tke_log_config_cls" {
  log_config_name = var.log_config_name
  cluster_id      = var.tke_cluster_id
  cluster_type    = var.cluster_type
  logset_id       = var.logset_id
  log_config      = jsonencode(local.log_config)

  lifecycle {
    precondition {
      condition     = !local.stdout_all_violation
      error_message = "containerStdout: allContainers=true cannot be used with workloads/includeLabels/excludeLabels"
    }
    precondition {
      condition     = !local.stdout_workload_violation
      error_message = "containerStdout: workloads cannot be used with includeLabels/excludeLabels/container"
    }
    precondition {
      condition     = !local.file_mutex_violation
      error_message = "containerFile: workload cannot be used with includeLabels/excludeLabels"
    }
  }
}
