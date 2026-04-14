resource "tencentcloud_apm_application_config" "this" {
  # required
  instance_id            = var.instance_id
  service_name           = var.service_name
  url_convergence_switch = var.url_convergence_switch

  # optional
  # basic config
  exception_filter          = var.exception_filter
  error_code_filter         = var.error_code_filter
  url_exclude               = var.url_exclude
  url_convergence           = var.url_convergence
  url_convergence_threshold = var.url_convergence_threshold

  # log config
  enable_log_config = var.enable_log_config
  is_related_log    = var.is_related_log
  log_region        = var.log_region
  log_topic_id      = var.log_topic_id
  log_set           = var.log_set
  log_index_type    = var.log_index_type
  log_source        = var.log_source
  log_trace_id_key  = var.log_trace_id_key

  # agent config
  agent_enable          = var.agent_enable
  enable_snapshot       = var.enable_snapshot
  snapshot_timeout      = var.snapshot_timeout
  trace_squash          = var.trace_squash
  event_enable          = var.event_enable
  ignore_operation_name = var.ignore_operation_name

  # dashboard config
  enable_dashboard_config = var.enable_dashboard_config
  is_related_dashboard    = var.is_related_dashboard
  dashboard_topic_id      = var.dashboard_topic_id

  # security config
  enable_security_config                = var.enable_security_config
  is_delete_any_file_analysis           = var.is_delete_any_file_analysis
  is_deserialization_analysis           = var.is_deserialization_analysis
  is_directory_traversal_analysis       = var.is_directory_traversal_analysis
  is_expression_injection_analysis      = var.is_expression_injection_analysis
  is_include_any_file_analysis          = var.is_include_any_file_analysis
  is_instrumentation_vulnerability_scan = var.is_instrumentation_vulnerability_scan
  is_jndi_injection_analysis            = var.is_jndi_injection_analysis
  is_jni_injection_analysis             = var.is_jni_injection_analysis
  is_memory_hijacking_analysis          = var.is_memory_hijacking_analysis
  is_read_any_file_analysis             = var.is_read_any_file_analysis
  is_remote_command_execution_analysis  = var.is_remote_command_execution_analysis
  is_script_engine_injection_analysis   = var.is_script_engine_injection_analysis
  is_sql_injection_analysis             = var.is_sql_injection_analysis
  is_template_engine_injection_analysis = var.is_template_engine_injection_analysis
  is_upload_any_file_analysis           = var.is_upload_any_file_analysis
  is_webshell_backdoor_analysis         = var.is_webshell_backdoor_analysis

  # url auto convergence config
  url_auto_convergence_enable  = var.url_auto_convergence_enable
  url_long_segment_threshold   = var.url_long_segment_threshold
  url_number_segment_threshold = var.url_number_segment_threshold

  # Circuit breaker configuration
  disable_memory_used = var.disable_memory_used
  disable_cpu_used    = var.disable_cpu_used

  # Agent operation configuration
  dynamic agent_operation_config_view {
    for_each = { for idx, item in var.agent_operation_config_view_list : idx => item }
    content {
      retention_valid     = agent_operation_config_view.value.retention_valid
      ignore_operation    = agent_operation_config_view.value.ignore_operation
      retention_operation = agent_operation_config_view.value.retention_operation
    }
  }

  # instrument config
  dynamic instrument_list {
    for_each = { for idx, item in var.instrument_list : idx => item }
    content {
      enable = instrument_list.value.enable
      name   = instrument_list.value.name
    }
  }
}