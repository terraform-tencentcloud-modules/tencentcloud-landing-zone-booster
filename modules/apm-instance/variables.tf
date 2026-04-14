################################################################################
# APM Instance Variables
################################################################################
variable "name" {
  description = "Name Of Instance."
  type        = string
}

variable "description" {
  description = "Description Of Instance."
  type        = string
  default     = null
}

variable "trace_duration" {
  description = "Duration Of Trace Data."
  type        = number
  default     = null
}

variable "span_daily_counters" {
  description = "Quota Of Instance Reporting."
  type        = number
  default     = null
}

variable "pay_mode" {
  description = "Modify the billing mode: `1` means prepaid, `0` means pay-as-you-go, the default value is `0`."
  type        = number
  default     = null
}

variable "free" {
  description = "Whether it is free (0 = paid edition; 1 = tsf restricted free edition; 2 = free edition), default 0."
  type        = number
  default     = null
}

variable "tags" {
  description = "Tag description list."
  type        = map(string)
  default     = {}
}

variable "open_billing" {
  description = "Billing switch."
  type        = bool
  default     = null
}

variable "err_rate_threshold" {
  description = "Error rate warning line. when the average error rate of the application exceeds this threshold, the system will give an abnormal note."
  type        = number
  default     = null
}

variable "sample_rate" {
  description = "Sampling rate (unit: %)."
  type        = number
  default     = null
}

variable "error_sample" {
  description = "Error sampling switch (0: off, 1: on)."
  type        = number
  default     = null
}

variable "slow_request_saved_threshold" {
  description = "Sampling slow call saving threshold (unit: ms)."
  type        = number
  default     = null
}

variable "is_related_log" {
  description = "Log feature switch (0: off; 1: on)."
  type        = number
  default     = null
}

variable "log_region" {
  description = "Log region, which takes effect after the log feature is enabled."
  type        = string
  default     = null
}

variable "log_topic_id" {
  description = "CLS log topic id, which takes effect after the log feature is enabled."
  type        = string
  default     = null
}

variable "log_set" {
  description = "Logset, which takes effect only after the log feature is enabled."
  type        = string
  default     = null
}

variable "log_source" {
  description = "Log source, which takes effect only after the log feature is enabled."
  type        = string
  default     = null
}

variable "custom_show_tags" {
  description = "List of custom display tags."
  type        = set(string)
  default     = null
}

variable "response_duration_warning_threshold" {
  description = "Response time warning line."
  type        = number
  default     = null
}

variable "is_related_dashboard" {
  description = "Whether to associate the dashboard (0 = off, 1 = on)."
  type        = number
  default     = null
}

variable "dashboard_topic_id" {
  description = "Associated dashboard id, which takes effect after the associated dashboard is enabled."
  type        = string
  default     = null
}

variable "is_sql_injection_analysis" {
  description = "SQL injection detection switch (0: off, 1: on)."
  type        = number
  default     = null
}

variable "is_instrumentation_vulnerability_scan" {
  description = "Whether to enable component vulnerability detection (0 = no, 1 = yes)."
  type        = number
  default     = null
}

variable "is_remote_command_execution_analysis" {
  description = "Whether to enable detection of the remote command attack."
  type        = number
  default     = null
}

variable "is_memory_hijacking_analysis" {
  description = "Whether to enable detection of Java webshell."
  type        = number
  default     = null
}

variable "log_index_type" {
  description = "CLS index type. (0 = full-text index; 1 = key-value index)."
  type        = number
  default     = null
}

variable "log_trace_id_key" {
  description = "Index key of traceId. It is valid when the CLS index type is key-value index."
  type        = string
  default     = null
}

variable "is_delete_any_file_analysis" {
  description = "Whether to enable the detection of deleting arbitrary files. (0 - disabled; 1: enabled)."
  type        = number
  default     = null
}

variable "is_read_any_file_analysis" {
  description = "Whether to enable the detection of reading arbitrary files. (0 - disabled; 1 - enabled)."
  type        = number
  default     = null
}

variable "is_upload_any_file_analysis" {
  description = "Whether to enable the detection of uploading arbitrary files. (0 - disabled; 1 - enabled)."
  type        = number
  default     = null
}

variable "is_include_any_file_analysis" {
  description = "Whether to enable the detection of the inclusion of arbitrary files. (0: disabled, 1: enabled)."
  type        = number
  default     = null
}

variable "is_directory_traversal_analysis" {
  description = "Whether to enable traversal detection of the directory. (0 - disabled; 1 - enabled)."
  type        = number
  default     = null
}

variable "is_template_engine_injection_analysis" {
  description = "Whether to enable template engine injection detection. (0: disabled; 1: enabled)."
  type        = number
  default     = null
}

variable "is_script_engine_injection_analysis" {
  description = "Whether to enable script engine injection detection. (0 - disabled; 1 - enabled)."
  type        = number
  default     = null
}

variable "is_expression_injection_analysis" {
  description = "Whether to enable expression injection detection. (0 - disabled; 1 - enabled)."
  type        = number
  default     = null
}

variable "is_jndi_injection_analysis" {
  description = "Whether to enable JNDI injection detection. (0 - disabled; 1 - enabled)."
  type        = number
  default     = null
}

variable "is_jni_injection_analysis" {
  description = "Whether to enable JNI injection detection. (0 - disabled, 1 - enabled)."
  type        = number
  default     = null
}

variable "is_webshell_backdoor_analysis" {
  description = "Whether to enable Webshell backdoor detection. (0 - disabled; 1 - enabled)."
  type        = number
  default     = null
}

variable "is_deserialization_analysis" {
  description = "Whether to enable deserialization detection. (0 - disabled; 1 - enabled)."
  type        = number
  default     = null
}

variable "url_long_segment_threshold" {
  description = "Convergence threshold for URL long segments."
  type        = number
  default     = null
}

variable "url_number_segment_threshold" {
  description = "Convergence threshold for URL numerical segments."
  type        = number
  default     = null
}