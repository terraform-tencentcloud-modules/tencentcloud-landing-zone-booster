################################################################################
# common config
################################################################################
variable "app_id" {
  description = "Org app ID."
  type        = string
  default     = null
}

variable "account_id" {
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
# cloud audit config
################################################################################
variable "cloudaudit_action_type" {
  type        = string
  default     = "*"
  description = "Track interface type, optional: (Read: Read interface, Write: Write interface, *: All interface),  Default is *."
}

variable "cloudaudit_resource_type" {
  type        = string
  default     = "*"
  description = "Track product, optional: (*: All product, Single product, such as cos), Default is *."
}

variable "cloudaudit_event_names" {
  type        = list(string)
  default     = ["*"]
  description = "Track interface name list. When resource_type is *, event_names is must *; When resource_type is a single product, event_names support all interfaces(*) and some interfaces, up to 10."
}

variable "cloudaudit_track_name" {
  description = "CloudAudit track name"
  type        = string
  default     = "track_audit"
}

variable "cloudaudit_track_for_all_members" {
  description = "CloudAudit track for all members"
  type        = number
  default     = 1
  
  validation {
    condition     = contains([0, 1], var.cloudaudit_track_for_all_members)
    error_message = "CloudAudit track for all members must be 0 or 1"
  }
}

variable "cloudaudit_track_status" {
  type        = number
  default     = 1
  description = "Track status, optional: (close: 0, open: 1)."
}

variable "cloudaudit_storage_type" {
  description = "CloudAudit storage type"
  type        = string
  
  validation {
    condition     = var.cloudaudit_storage_type != null ? contains(["cos", "cls", "ckafka"], var.cloudaudit_storage_type) : false
    error_message = "CloudAudit storage type must be `cos`, `cls` or `ckafka`"
  }
}

variable "cloudaudit_storage_region" {
  description = "CloudAudit storage region"
  type        = string
}

variable "cloudaudit_storage_name" {
  description = "CloudAudit storage name"
  type        = string
}

variable "cloudaudit_storage_prefix" {
  description = "CloudAudit storage prefix"
  type        = string
}

################################################################################
# cloud audit-track cos config
################################################################################
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
# cloud audit-track cls config
################################################################################
variable "cls_logset_name" {
  description = "cloud audit-track cls logset name"
  type        = string
}

variable "cls_logset_tags" {
  description = "Tag description list."
  type        = map(string)
  default     = null
}

variable "cls_auto_split" {
  description = "Whether to enable automatic split. Default value: true."
  type = bool
  default = true
}

variable "cls_max_split_partitions" {
  description = "Maximum number of partitions to split into for this topic if automatic split is enabled. Default value: 50."
  type = number
  default = 50
}

variable "cls_partition_count" {
  description = "Number of log topic partitions. Default value: 1. Maximum value: 10."
  type        = number
  default     = 1
}

variable "cls_period" {
  description = "Lifecycle in days. Value range: 1~366. Default value: 30."
  type = number
  default = 30
}

variable "cls_storage_type" {
  description = "Log topic storage class. Valid values: hot: real-time storage; cold: offline storage. Default value: hot. If cold is passed in, please contact the customer service to add the log topic to the allowlist first."
  type = string
  default = "hot"
}

variable "cls_describes" {
  description = "default cls topic"
  type = string
  default = null
}

variable "cls_hot_period" {
  description = "default is 0: Turn off log sinking. Non 0: The number of days of standard storage after enabling log settling"
  type = number
  default = null
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
  type        = bool
  default     = false
  description = "Controls if cls index should be created."
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
}

variable "cls_rules" {
  description = "Index rule."
  type = set(object({
    full_text = list(object({
      case_sensitive = bool
      tokenizer = string
      contain_z_h = bool
    }))
    key_value = list(object({
      case_sensitive=bool
      key_values=list(object({
        key = string
        value=list(object({
          type = string
          tokenizer=string
          sql_flag=bool
          contain_z_h=bool
        }))
      }))
    }))
    tag = list(object({
      case_sensitive=bool
      key_values=list(object({
        key = string
        value=list(object({
          type = string
          tokenizer=string
          sql_flag=bool
          contain_z_h=bool
        }))
      }))
    }))
  }))
  default = []
}