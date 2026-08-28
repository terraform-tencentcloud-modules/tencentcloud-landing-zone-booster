################################################################################
# common config
################################################################################
variable "create_cam_strategy" {
  type        = bool
  default     = false
  description = "Specify whether to create CAM role and relative essential policy. Set to false if you've enable by using TencentCloud Console."
}

variable "region" {
  description = "Log region"
  type        = string
  default     = null
}

variable "app_id" {
  description = "Org app ID."
  type        = string
  default     = null
}

variable "account_uin" {
  description = "Org member name or uin for audit"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = null
}

################################################################################
# Config
################################################################################
variable "config_enabled" {
  type        = bool
  description = "Config switch."
  default     = true
}

variable "deliver_enabled" {
  type        = bool
  description = "Delivery switch."
  default     = true
}

variable "deliver_name" {
  type        = string
  description = "Delivery service name."
}

variable "deliver_content_type" {
  type        = number
  description = "Delivery content type. Valid values: 1 (configuration change), 2 (resource list), 3 (all)."
  default     = 1

  validation {
    condition     = var.deliver_content_type == null || contains([1, 2, 3], var.deliver_content_type)
    error_message = "deliver_content_type must be one of 1, 2, or 3."
  }
}

variable "deliver_target_type" {
  type        = string
  description = "Delivery type. Valid values: COS, CLS."

  validation {
    condition     = var.deliver_target_type != null && contains(["COS", "CLS"], var.deliver_target_type)
    error_message = "deliver_target_type must be 'COS' or 'CLS'."
  }
}

variable "deliver_log_prefix" {
  type        = string
  description = "Log prefix for stored delivery content."
  default     = "config-log"
}

################################################################################
# COS Config
################################################################################
variable "cos_bucket" {
  description = "COS bucket name"
  type        = string
  default     = null
}

variable "cos_bucket_acl" {
  description = "COS bucket ACL"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "public-read", "public-read-write"], var.cos_bucket_acl)
    error_message = "ACL must be 'private', 'public-read' or 'public-read-write'。"
  }
}

variable "cos_multi_az" {
  description = "whether to enable multi-AZ"
  type        = bool
  default     = false
}

variable "cos_force_clean" {
  description = "whether to force clean"
  type        = bool
  default     = true
}

variable "cos_versioning_enable" {
  description = "whether to enable versioning"
  type        = bool
  default     = true
}

variable "cos_lifecycle_rules" {
  description = "List of lifecycle rules configuration"
  type = list(object({
    id            = optional(string)
    filter_prefix = optional(string)

    expiration = optional(object({
      days          = optional(number)
      date          = optional(string)
      delete_marker = optional(bool)
    }))

    transition = optional(list(object({
      days          = optional(number)
      date          = optional(string)
      storage_class = string
    })), [])

    non_current_expiration = optional(object({
      non_current_days = number
    }))

    non_current_transition = optional(list(object({
      non_current_days = number
      storage_class    = string
    })), [])

    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }))
  }))
  default = []
}

variable "cos_tags" {
  description = "Tags"
  type        = map(string)
  default     = null
}

################################################################################
# CLS Config
################################################################################
variable "cls_logset_name" {
  description = "cloud audit-track cls logset name"
  type        = string
  default     = null
}

variable "cls_logset_tags" {
  description = "Tag description list."
  type        = map(string)
  default     = null
}

variable "cls_topic_name" {
  description = "cloud audit-track cls logset name"
  type        = string
  default     = null
}

variable "cls_auto_split" {
  description = "Whether to enable automatic split. Default value: true."
  type        = bool
  default     = true
}

variable "cls_max_split_partitions" {
  description = "Maximum number of partitions to split into for this topic if automatic split is enabled. Default value: 50."
  type        = number
  default     = 50
}

variable "cls_partition_count" {
  description = "Number of log topic partitions. Default value: 1. Maximum value: 10."
  type        = number
  default     = 1

  validation {
    condition     = var.cls_partition_count >= 1 && var.cls_partition_count <= 10
    error_message = "cls_partition_count must be between 1 and 10."
  }
}

variable "cls_period" {
  description = "Lifecycle in days. Value range: 1~366. Default value: 30."
  type        = number
  default     = 30

  validation {
    condition     = var.cls_period >= 1 && var.cls_period <= 366
    error_message = "cls_period must be between 1 and 366."
  }
}

variable "cls_storage_type" {
  description = "Log topic storage class. Valid values: hot: real-time storage; cold: offline storage. Default value: hot. If cold is passed in, please contact the customer service to add the log topic to the allowlist first."
  type        = string
  default     = "hot"

  validation {
    condition     = contains(["hot", "cold"], var.cls_storage_type)
    error_message = "cls_storage_type must be 'hot' or 'cold'."
  }
}

variable "cls_describes" {
  description = "default cls topic"
  type        = string
  default     = null
}

variable "cls_hot_period" {
  description = "default is 0: Turn off log sinking. Non 0: The number of days of standard storage after enabling log settling"
  type        = number
  default     = 0
}

variable "cls_is_web_tracking" {
  description = "No authentication switch. False: closed; True: Enable. The default is false. After activation, anonymous access to the log topic will be supported for specified operations."
  type        = bool
  default     = false
}

variable "cls_encryption" {
  description = "Encryption-related parameters. This parameter is supported for users with an open access list and from encrypted regions; it cannot be passed in other scenarios. 0 or not passed: No encryption. 1: KMS-CLS cloud product key encryption. Once enabled, it cannot be disabled.\nSupported regions: ap-beijing, ap-guangzhou, ap-shanghai, ap-singapore, ap-bangkok, ap-jakarta, eu-frankfurt, ap-seoul, ap-tokyo."
  type        = number
  default     = null
}

variable "cls_topic_tags" {
  description = "Tag description list."
  type        = map(string)
  default     = null
}

variable "cls_create_index" {
  description = "Controls if cls index should be created."
  type        = bool
  default     = false
}

variable "cls_index_status" {
  description = "Whether to take effect. Default value: true."
  type        = bool
  default     = true
}

variable "cls_include_internal_fields" {
  description = "Internal field marker of full-text index. Default value: false. Valid value: false: excluding internal fields; true: including internal fields."
  type        = bool
  default     = false
}

variable "cls_metadata_flag" {
  description = "Metadata flag. Default value: 0. Valid value: 0: full-text index (including the metadata field with key-value index enabled); 1: full-text index (including all metadata fields); 2: full-text index (excluding metadata fields)."
  type        = number
  default     = 0

  validation {
    condition     = contains([0, 1, 2], var.cls_metadata_flag)
    error_message = "cls_metadata_flag must be one of 0, 1, or 2."
  }
}

variable "cls_rules" {
  description = "Index rule. Mirrors the `rule` block of tencentcloud_cls_index (resource_tc_cls_index.go)."
  type = set(object({
    # Full-text index configuration. tokenizer/contain_z_h are Optional in the provider.
    full_text = list(object({
      case_sensitive = bool
      tokenizer      = optional(string)
      contain_z_h    = optional(bool, true)
    }))

    # Key-value index configuration.
    key_value = list(object({
      case_sensitive = bool
      key_values = list(object({
        key = string
        value = list(object({
          type                      = string
          tokenizer                 = optional(string)
          sql_flag                  = optional(bool)
          contain_z_h               = optional(bool)
          alias                     = optional(string)
          open_index_for_child_only = optional(bool)
          # JSON child node index. Terraform has no recursive types, so only one
          # level of nesting is modeled here (the provider supports up to 5 levels).
          child_node = optional(list(object({
            key = optional(string)
            value = list(object({
              type                      = string
              tokenizer                 = optional(string)
              sql_flag                  = optional(bool)
              contain_z_h               = optional(bool)
              alias                     = optional(string)
              open_index_for_child_only = optional(bool)
            }))
          })))
        }))
      }))
    }))

    # Metafield (tag) index configuration.
    tag = list(object({
      case_sensitive = bool
      key_values = list(object({
        key = string
        value = list(object({
          type                      = string
          tokenizer                 = optional(string)
          sql_flag                  = optional(bool)
          contain_z_h               = optional(bool)
          alias                     = optional(string)
          open_index_for_child_only = optional(bool)
          child_node = optional(list(object({
            key = optional(string)
            value = list(object({
              type                      = string
              tokenizer                 = optional(string)
              sql_flag                  = optional(bool)
              contain_z_h               = optional(bool)
              alias                     = optional(string)
              open_index_for_child_only = optional(bool)
            }))
          })))
        }))
      }))
    }))

    # Dynamic (auto) key-value index. If empty, the feature is disabled.
    dynamic_index = optional(list(object({
      status = bool
    })), [])
  }))
  default = []

  validation {
    condition     = length(var.cls_rules) <= 1
    error_message = "Only 1 rule is allowed."
  }

  validation {
    condition = alltrue([
      for rule in var.cls_rules : (length(rule.full_text) <= 1) && (length(rule.key_value) <= 1) && (length(rule.tag) <= 1) && (length(rule.dynamic_index) <= 1)
    ])
    error_message = "Only 1 rule.* is allowed."
  }
}