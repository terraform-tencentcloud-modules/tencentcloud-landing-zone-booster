################################################################################
# APM Application Configuration Variables
################################################################################
variable "instance_id" {
  description = "Business system ID."
  type        = string
}

variable "service_name" {
  description = "Application name."
  type        = string
}

variable "url_convergence_switch" {
  description = "URL convergence switch. 0: Off; 1: On."
  type        = number
}

variable "url_convergence_threshold" {
  description = "URL convergence threshold."
  type        = number
  default     = null
}

variable "exception_filter" {
  description = "Regex rules for exception filtering, separated by commas."
  type        = string
  default     = null
}

variable "url_convergence" {
  description = "Regex rules for URL convergence, separated by commas."
  type        = string
  default     = null
}

variable "error_code_filter" {
  description = "Error code filtering, separated by commas."
  type        = string
  default     = null
}

variable "url_exclude" {
  description = "Regex rules for URL exclusion, separated by commas."
  type        = string
  default     = null
}

variable "is_related_log" {
  description = "Log switch. 0: Off; 1: On."
  type        = number
  default     = null
}

variable "log_region" {
  description = "Log region."
  type        = string
  default     = null
}

variable "log_topic_id" {
  description = "Log topic ID."
  type        = string
  default     = null
}

variable "log_set" {
  description = "CLS log set/ES cluster ID."
  type        = string
  default     = null
}

variable "log_source" {
  description = "Log source: CLS or ES."
  type        = string
  default     = null
}

variable "ignore_operation_name" {
  description = "APIs to be filtered."
  type        = string
  default     = null
}

variable "enable_snapshot" {
  description = "Whether thread profiling is enabled."
  type        = bool
  default     = null
}

variable "snapshot_timeout" {
  description = "Timeout threshold for thread profiling."
  type        = number
  default     = null
}

variable "agent_enable" {
  description = "Whether agent is enabled."
  type        = bool
  default     = null
}

variable "trace_squash" {
  description = "Whether link compression is enabled."
  type        = bool
  default     = null
}

variable "event_enable" {
  description = "Switch for enabling application diagnosis."
  type        = bool
  default     = null
}

variable "enable_log_config" {
  description = "Whether to enable application log configuration."
  type        = bool
  default     = null
}

variable "enable_dashboard_config" {
  description = "Whether to enable the dashboard configuration for applications. false: disabled (consistent with the business system configuration); true: enabled (application-level configuration)."
  type        = bool
  default     = null
}

variable "is_related_dashboard" {
  description = "Whether to associate with Dashboard. 0: disabled; 1: enabled."
  type        = number
  default     = null
}

variable "dashboard_topic_id" {
  description = "dashboard ID."
  type        = string
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

variable "enable_security_config" {
  description = "Whether to enable application security configuration."
  type        = bool
  default     = null
}

variable "is_sql_injection_analysis" {
  description = "Whether to enable SQL injection analysis."
  type        = number
  default     = null
}

variable "is_instrumentation_vulnerability_scan" {
  description = "Whether to enable detection of component vulnerability."
  type        = number
  default     = null
}

variable "is_remote_command_execution_analysis" {
  description = "Whether remote command detection is enabled."
  type        = number
  default     = null
}

variable "is_memory_hijacking_analysis" {
  description = "Whether to enable detection of Java webshell."
  type        = number
  default     = null
}

variable "is_delete_any_file_analysis" {
  description = "Whether to enable the detection of deleting arbitrary files. (0 - disabled; 1: enabled.)."
  type        = number
  default     = null
}

variable "is_read_any_file_analysis" {
  description = "Whether to enable the detection of reading arbitrary files. (0 - disabled; 1 - enabled.)."
  type        = number
  default     = null
}

variable "is_upload_any_file_analysis" {
  description = "Whether to enable the detection of uploading arbitrary files. (0 - disabled; 1 - enabled.)."
  type        = number
  default     = null
}

variable "is_include_any_file_analysis" {
  description = "Whether to enable the detection of the inclusion of arbitrary files. (0: disabled, 1: enabled.)."
  type        = number
  default     = null
}

variable "is_directory_traversal_analysis" {
  description = "Whether to enable traversal detection of the directory. (0 - disabled; 1 - enabled)."
  type        = number
  default     = null
}

variable "is_template_engine_injection_analysis" {
  description = "Whether to enable template engine injection detection. (0: disabled; 1: enabled.)."
  type        = number
  default     = null
}

variable "is_script_engine_injection_analysis" {
  description = "Whether to enable script engine injection detection. (0 - disabled; 1 - enabled.)."
  type        = number
  default     = null
}

variable "is_expression_injection_analysis" {
  description = "Whether to enable expression injection detection. (0 - disabled; 1 - enabled.)."
  type        = number
  default     = null
}

variable "is_jndi_injection_analysis" {
  description = "Whether to enable JNDI injection detection. (0 - disabled; 1 - enabled.)."
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

variable "url_auto_convergence_enable" {
  description = "Automatic convergence switch for APIs. 0: disabled | 1: enabled."
  type        = bool
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

variable "disable_memory_used" {
  description = "Specifies the memory threshold for probe fusing."
  type        = number
  default     = null
}

variable "disable_cpu_used" {
  description = "Specifies the CPU threshold for probe fusing."
  type        = number
  default     = null
}

variable "agent_operation_config_view_list" {
  description = "Related configurations of the probe APIs."
  type = list(object({
    retention_valid     = optional(bool)   # Whether allowlist configuration is enabled for the current API.
    ignore_operation    = optional(string) # Blocklist configuration in API settings.
    retention_operation = optional(string) # Allowlist configuration in API settings.
  }))
  default = []
}

variable "instrument_list" {
  description = "Component List."
  type = list(object({
    name   = optional(string) # Component name.
    enable = optional(bool)   # Component switch.
  }))
  default = [
    {
      enable = true
      name   = "apm-spring-annotations"
    },
    {
      enable = true
      name   = "dubbo"
    },
    {
      enable = true
      name   = "googlehttpclient"
    },
    {
      enable = true
      name   = "grpc"
    },
    {
      enable = true
      name   = "httpclient3"
    },
    {
      enable = true
      name   = "httpclient4"
    },
    {
      enable = true
      name   = "hystrix"
    },
    {
      enable = true
      name   = "lettuce"
    },
    {
      enable = true
      name   = "mongodb"
    },
    {
      enable = true
      name   = "mybatis"
    },
    {
      enable = true
      name   = "mysql"
    },
    {
      enable = true
      name   = "okhttp"
    },
    {
      enable = true
      name   = "redis"
    },
    {
      enable = true
      name   = "rxjava"
    },
    {
      enable = true
      name   = "spring-webmvc"
    },
    {
      enable = true
      name   = "tomcat"
    }
  ]
}