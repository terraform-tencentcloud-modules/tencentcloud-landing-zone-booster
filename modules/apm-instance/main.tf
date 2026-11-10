resource "tencentcloud_apm_instance" "this" {
  # basic config
  name                = var.name
  description         = var.description
  trace_duration      = var.trace_duration
  span_daily_counters = var.span_daily_counters
  pay_mode            = var.pay_mode
  free                = var.free
  open_billing        = var.open_billing
  tags                = var.tags

  # monitor config
  err_rate_threshold                  = var.err_rate_threshold
  sample_rate                         = var.sample_rate
  error_sample                        = var.error_sample
  slow_request_saved_threshold        = var.slow_request_saved_threshold
  response_duration_warning_threshold = var.response_duration_warning_threshold

  # log config
  is_related_log   = var.is_related_log
  log_region       = var.log_region
  log_topic_id     = var.log_topic_id
  log_set          = var.log_set
  log_source       = var.log_source
  log_index_type   = var.log_index_type
  log_trace_id_key = var.log_trace_id_key

  # dashboard config
  is_related_dashboard = var.is_related_dashboard
  dashboard_topic_id   = var.dashboard_topic_id

  # security analysis config
  is_sql_injection_analysis             = var.is_sql_injection_analysis
  is_instrumentation_vulnerability_scan = var.is_instrumentation_vulnerability_scan
  is_remote_command_execution_analysis  = var.is_remote_command_execution_analysis
  is_memory_hijacking_analysis          = var.is_memory_hijacking_analysis
  is_delete_any_file_analysis           = var.is_delete_any_file_analysis
  is_read_any_file_analysis             = var.is_read_any_file_analysis
  is_upload_any_file_analysis           = var.is_upload_any_file_analysis
  is_include_any_file_analysis          = var.is_include_any_file_analysis
  is_directory_traversal_analysis       = var.is_directory_traversal_analysis
  is_template_engine_injection_analysis = var.is_template_engine_injection_analysis
  is_script_engine_injection_analysis   = var.is_script_engine_injection_analysis
  is_expression_injection_analysis      = var.is_expression_injection_analysis
  is_jndi_injection_analysis            = var.is_jndi_injection_analysis
  is_jni_injection_analysis             = var.is_jni_injection_analysis
  is_webshell_backdoor_analysis         = var.is_webshell_backdoor_analysis
  is_deserialization_analysis           = var.is_deserialization_analysis

  # other config
  custom_show_tags             = var.custom_show_tags
  url_long_segment_threshold   = var.url_long_segment_threshold
  url_number_segment_threshold = var.url_number_segment_threshold
}