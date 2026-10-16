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
# Config Aggregator
################################################################################
variable "aggregator_name" {
  description = "Aggregator name."
  type        = string
}

variable "aggregator_description" {
  description = "Aggregator description."
  type        = string
}

variable "aggregator_type" {
  description = "Aggregator type. Valid values: \"RD\" (global aggregator, members derived from resource directory), \"CUSTOM\" (custom aggregator, must specify aggregator_accounts with at least one member). ForceNew."
  type        = string

  validation {
    condition     = contains(["RD", "CUSTOM"], var.aggregator_type)
    error_message = "The type of an aggregator must be either \"RD\" or \"CUSTOM\"."
  }
}

variable "aggregator_owner_uin" {
  description = "Creator UIN of the aggregator. Required by Describe/Update/Delete APIs. ForceNew."
  type        = string
}

variable "aggregator_accounts" {
  description = "Member accounts of the aggregator. Required when type = \"CUSTOM\" (at least one); ignored when type = \"RD\" (members derived from the resource directory). Up to 100 entries."
  type = list(object({
    member_uin  = number
    member_name = string
  }))
  default = []

  validation {
    condition     = var.aggregator_type == "RD" || (var.aggregator_type == "CUSTOM" && length(var.aggregator_accounts) > 0)
    error_message = "When type is \"CUSTOM\", aggregator_accounts must contain at least one member account; when type is \"RD\", aggregator_accounts must be empty (members are derived from the resource directory)."
  }
}

################################################################################
# Config Deliver
################################################################################
variable "deliver_enabled" {
  description = "Delivery switch. Valid values: false (0 - disabled), true (1 - enabled)."
  type        = bool
  default     = true
}

variable "deliver_name" {
  description = "Delivery service name (optional)."
  type        = string
  default     = null
}

variable "target_arn" {
  description = "Resource ARN. COS format: qcs::cos:$region:$account:prefix/$appid/$BucketName. CLS format: qcs::cls:$region:$account:cls/topicId. (optional)"
  type        = string
  default     = null
}

variable "deliver_prefix" {
  description = "Log prefix for stored delivery content (optional)."
  type        = string
  default     = null
}

variable "deliver_type" {
  description = "Delivery type. Valid values: COS, CLS. Defaults to COS on the cloud side when omitted."
  type        = string
  default     = null

  validation {
    condition     = var.deliver_type == null || contains(["COS", "CLS"], var.deliver_type)
    error_message = "deliver_type must be COS or CLS."
  }
}

variable "deliver_uin" {
  description = "Member account uin that supports cross-account delivery. Only the delegated administrator can be used. Default 0 means delivery to the administrator account (optional)."
  type        = number
  default     = 0
}

variable "deliver_content_type" {
  description = "Delivery content type. Valid values: 1 (configuration change), 2 (resource list), 3 (all). Defaults to 1 on the cloud side when omitted."
  type        = number
  default     = null

  validation {
    condition     = var.deliver_content_type == null || contains([1, 2, 3], var.deliver_content_type)
    error_message = "deliver_content_type must be 1 (configuration change), 2 (resource list) or 3 (all)."
  }
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
  description = "Tags"
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
          type                      = string           # Field type. Valid values: long, text, double.
          tokenizer                 = optional(string) # Field delimiter, which is meaningful only if the field type is text. Each character in the entered string represents a delimiter.
          sql_flag                  = optional(bool)   # Whether the analysis feature is enabled for the field.
          contain_z_h               = optional(bool)   # Whether Chinese characters are contained.
          alias                     = optional(string) # Field alias.
          open_index_for_child_only = optional(bool)   # Only enable index for child nodes, this field itself is not enabled. Note: only json type fields can configure this parameter.
          # Json child node list (recursive, up to 3 levels supported here; provider supports up to 5).
          child_node = optional(list(object({
            key = string # Field name of the json child node.
            value = optional(list(object({
              type                      = string
              tokenizer                 = optional(string)
              sql_flag                  = optional(bool)
              contain_z_h               = optional(bool)
              alias                     = optional(string)
            })), [])
          })), [])
        })), [])
      })), [])
    })), [])
    # Tag index configuration.
    tag = optional(list(object({
      case_sensitive = bool                   # Case sensitivity.
      key_values     = optional(list(object({ # Key-Value pair information of the index to be created. Up to 100 key-value pairs can be configured.
        key   = string        # When a key value or metafield index needs to be configured for a field, the metafield Key does not need to be prefixed with __TAG__. and is consistent with the one when logs are uploaded. __TAG__. will be prefixed automatically for display in the console.
        value = optional(list(object({ # Field index description information.
          type                      = string           # Field type. Valid values: long, text, double.
          tokenizer                 = optional(string) # Field delimiter, which is meaningful only if the field type is text. Each character in the entered string represents a delimiter.
          sql_flag                  = optional(bool)   # Whether the analysis feature is enabled for the field.
          contain_z_h               = optional(bool)   # Whether Chinese characters are contained.
          alias                     = optional(string) # Field alias.
          open_index_for_child_only = optional(bool)   # Only enable index for child nodes, this field itself is not enabled. Note: only json type fields can configure this parameter.
          # Json child node list (recursive, up to 3 levels supported here; provider supports up to 5).
          child_node = optional(list(object({
            key = string # Field name of the json child node.
            value = optional(list(object({
              type                      = string
              tokenizer                 = optional(string)
              sql_flag                  = optional(bool)
              contain_z_h               = optional(bool)
              alias                     = optional(string)
            })), [])
          })), [])
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