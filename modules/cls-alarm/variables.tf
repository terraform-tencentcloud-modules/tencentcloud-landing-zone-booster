variable "cls_alarm_policy_name" {
  description = "The name of alarm"
  type        = string
}

variable "alarm_notice_ids" {
  description = "(Required, Set: [String]) list of alarm notice id"
  type        = list(string)
}

variable "alarm_period" {
  description = "(Required, Int) alarm repeat cycle"
  type        = number
}

variable "analysis_content" {
  description = "Analysis content"
  type        = string
  default     = "*"
}

variable "analysis_name" {
  description = "Analysis name"
  type        = string
  default     = "core log"
}

variable "analysis_type" {
  description = "Type of data being analyzed. Valid values: query, field, original"
  type        = string
  default     = "original"
}

variable "analysis_config_infos" {
  description = "Analysis configuration"
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    { key : "Fields", value : "*" },
    { key : "QueryIndex", value : "1" },
    { key : "Format", value : "1" },
    { key : "Limit", value : "1" },
    { key : "CustomQuery", value : "error" },
    { key : "SyntaxRule", value : "1" },
  ]
}

variable "multi_conditions" {
  description = "Trigger conditions"
  type = list(object({
    alarm_level = number
    condition   = string
  }))
}

variable "message_template" {
  description = "(Optional, String) user define alarm notice"
  type        = string
  default     = ""
}

variable "status" {
  description = "(Optional, Bool) whether to enable the alarm policy"
  type        = bool
  default     = true
}

variable "trigger_count" {
  description = "(Required, Int) continuous cycle"
  type        = number
  default     = 1
}

# alarm_targets
variable "logset_id" {
  description = "logset id"
  type        = string
}

variable "topic_id" {
  description = "Topic id"
  type        = string
}

variable "query" {
  description = "query rules"
  type        = string
}

variable "start_time_offset" {
  description = "search start time of offset"
  type        = number
  default     = -15
}

variable "end_time_offset" {
  description = "(Required, Int) continuous cycle"
  type        = number
  default     = 0
}

variable "syntax_rule" {
  description = "Retrieve grammar rules, 0: Lucene syntax, 1: CQL syntax, Default value is 0."
  type        = number
  default     = 1
}

variable "monitor_time" {
  description = "Monitor time"
  type = object({
    time = number
    type = string
  })
}

variable "policy_tag" {
  description = "Tag description list."
  type        = map(string)
  default     = {}
}
