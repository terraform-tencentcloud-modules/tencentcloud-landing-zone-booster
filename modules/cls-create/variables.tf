# common
variable "region" {
  description = "The topic and logset region."
  type        = string
  default     = ""
}

# logset
variable "logset_name" {
  description = "The logset name."
  type        = string
}

variable "logset_tags" {
  description = "Tag description list."
  type        = map(string)
  default     = null
}

# topic
variable "topic_name" {
  description = "Log topic name."
  type        = string
}

variable "partition_count" {
  description = "Number of log topic partitions. Default value: 1. Maximum value: 10."
  type        = number
  default     = null
}

variable "auto_split" {
  description = "Whether to enable automatic split. Default value: true."
  type        = bool
  default     = true
}

variable "max_split_partitions" {
  description = "Maximum number of partitions to split into for this topic if automatic split is enabled. Default value: 50."
  type        = number
  default     = 50
}

variable "storage_type" {
  description = "Log topic storage class. Valid values: hot: real-time storage; cold: offline storage. Default value: hot. If cold is passed in, please contact the customer service to add the log topic to the allowlist first."
  type        = string
  default     = "hot"
}

variable "period" {
  description = "Lifecycle in days. Value range: 1~366. Default value: 30."
  type        = number
  default     = 30
}

variable "topic_tags" {
  description = "Tag description list."
  type        = map(string)
  default     = null
}

variable "hot_period" {
  description = "0: Turn off log sinking. Non 0: The number of days of standard storage after enabling log settling. HotPeriod needs to be greater than or equal to 7 and less than Period. Only effective when StorageType is hot."
  type        = number
  default     = 7
}

variable "is_web_tracking" {
  description = "No authentication switch. False: closed; True: Enable. The default is false. After activation, anonymous access to the log topic will be supported for specified operations."
  type        = bool
  default     = false
}

variable "encryption" {
  description = "Encryption-related parameters. This parameter is supported for users with an open access list and from encrypted regions; it cannot be passed in other scenarios. 0 or not passed: No encryption. 1: KMS-CLS cloud product key encryption. Once enabled, it cannot be disabled.\nSupported regions: ap-beijing, ap-guangzhou, ap-shanghai, ap-singapore, ap-bangkok, ap-jakarta, eu-frankfurt, ap-seoul, ap-tokyo."
  type        = number
  default     = null
}

variable "describes" {
  description = "Log Topic Description."
  type        = string
  default     = null
}

# index
variable "create_index" {
  type        = bool
  default     = false
  description = "Controls if cls index should be created."
}

variable "index_status" {
  description = "Whether to take effect. Default value: true."
  type        = bool
  default     = true
}

variable "include_internal_fields" {
  description = "Internal field marker of full-text index. Default value: false. Valid value: false: excluding internal fields; true: including internal fields."
  type        = bool
  default     = false
}

variable "metadata_flag" {
  description = "Metadata flag. Default value: 0. Valid value: 0: full-text index (including the metadata field with key-value index enabled); 1: full-text index (including all metadata fields); 2: full-text index (excluding metadata fields)."
  type        = number
  default     = 0
}

# index rules
variable "rules" {
  description = "Index rule."
  type = set(object({
    # Full-Text index configuration.
    full_text = optional(list(object({
      case_sensitive = bool   # Case sensitive.
      tokenizer      = string # Full-Text index delimiter. Each character in the string represents a delimiter.
      contain_z_h    = bool   # Whether Chinese characters are contained.
    })), [])
    # Key-Value index configuration.
    key_value = optional(list(object({
      case_sensitive = bool # Case sensitivity.
      key_values     = optional(list(object({
        key   = string                 # When a key value or metafield index needs to be configured for a field, the metafield Key does not need to be prefixed with __TAG__. and is consistent with the one when logs are uploaded. __TAG__. will be prefixed automatically for display in the console.
        value = optional(list(object({ # Field index description information.
          type        = string           # Field type. Valid values: long, text, double.
          tokenizer   = optional(string) # Field delimiter, which is meaningful only if the field type is text. Each character in the entered string represents a delimiter.
          sql_flag    = optional(bool)   # Whether the analysis feature is enabled for the field.
          contain_z_h = optional(bool)   # Whether Chinese characters are contained.
        })), [])
      })), [])
    })), [])
    # Tag index configuration.
    tag = optional(list(object({
      case_sensitive = bool                   # Case sensitivity.
      key_values     = optional(list(object({ # Key-Value pair information of the index to be created. Up to 100 key-value pairs can be configured.
        key   = string        # When a key value or metafield index needs to be configured for a field, the metafield Key does not need to be prefixed with __TAG__. and is consistent with the one when logs are uploaded. __TAG__. will be prefixed automatically for display in the console.
        value = optional(list(object({ # Field index description information.
          type        = string           # Field type. Valid values: long, text, double.
          tokenizer   = optional(string) # Field delimiter, which is meaningful only if the field type is text. Each character in the entered string represents a delimiter.
          sql_flag    = optional(bool)   # Whether the analysis feature is enabled for the field.
          contain_z_h = optional(bool)   # Whether Chinese characters are contained.
        })), [])
      })), [])
    })), [])
    # The key value index is automatically configured. If it is empty, it means that the function is not enabled.
    dynamic_index = optional(list(object({
      status = bool # index automatic configuration switch.
    })), [])
  }))
  default = []

  validation {
    condition     = length(var.rules) <= 1
    error_message = "Only 1 rule is allowed."
  }

  validation {
    condition = alltrue([
      for rule in var.rules : (length(rule.full_text) <= 1) && (length(rule.key_value) <= 1) && (length(rule.tag) <= 1) && (length(rule.dynamic_index) <= 1)
    ])
    error_message = "Only 1 rule.* is allowed."
  }
}