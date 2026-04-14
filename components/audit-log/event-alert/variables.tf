# ============================================================
# Alarm notice variables
# ============================================================
variable "enable_notice" {
  description = "Whether enbale alarm notice."
  type        = bool
  default     = false
}

variable "notice_name" {
  description = "Alarm notice name."
  type        = string
}

variable "notice_type" {
  description = "Notice type. Value: Trigger, Recovery, All."
  type        = string

  validation {
    condition     = contains(["Trigger", "Recovery", "All"], var.notice_type)
    error_message = "notice_type only support: Trigger, Recovery and All."
  }
}

variable "notice_receivers" {
  description = "Notice receivers."
  type = list(object({
    receiver_type     = string           # Receiver type, Uin or Group.
    receiver_ids      = list(number)     # Receiver id list.
    receiver_channels = list(string)     # Receiver channels, Value: Email, Sms, WeChat, Phone.
    notice_content_id = optional(string) # Notice content ID.
    start_time        = optional(string) # Start time allowed to receive messages.
    end_time          = optional(string) # End time allowed to receive messages.
  }))
  default = []

  validation {
    condition = alltrue([
      for nr in var.notice_receivers : contains(["Uin", "Group"], nr.receiver_type)
    ])
    error_message = "receiver_type only support: Uin or Group."
  }

  validation {
    condition = alltrue([
      for nr in var.notice_receivers : alltrue([
        for ch in nr.receiver_channels : contains(["Email", "Sms", "WeChat", "Phone"], ch)
      ])
    ])
    error_message = "receiver_channels only support: Email, Sms, WeChat, Phone."
  }
}

variable "notice_web_callbacks" {
  description = "Callback info."
  type = list(object({
    callback_type     = string # Callback type, Values: Http, WeCom, DingTalk, Lark.
    url               = string # Callback url.
    web_callback_id   = optional(string) # Integration configuration ID.
    method            = optional(string) # Method, POST or PUT.
    notice_content_id = optional(string) # Notice content ID.
    remind_type       = optional(number) # Remind type. 0: Do not remind; 1: Specified person; 2: Everyone.
    mobiles           = optional(list(string)) # Telephone list.
    user_ids          = optional(list(string)) # User ID list.
  }))
  default = []

  validation {
    condition = alltrue([
      for w in var.notice_web_callbacks : contains(["Http", "WeCom", "DingTalk", "Lark"], w.callback_type)
    ])
    error_message = "callback_type only support: Http, WeCom, DingTalk, Lark."
  }

  validation {
    condition = alltrue([
      for w in var.notice_web_callbacks : contains(["POST", "PUT"], w.method)
    ])
    error_message = "method only supoort: POST or PUT."
  }
}

variable "notice_tags" {
  description = "Tag description list."
  type        = map(string)
  default     = null
}

# ============================================================
# Alarm Variables
# ============================================================
variable "alarms" {
  description = "Alarm config list"
  type = list(object({
    name               = string # log alarm name.
    trigger_count = optional(number, 1) # Continuous cycle, default is 1.
    alarm_period  = optional(number, 15) # Alarm repeat cycle (minute), the same alert will be sent only once within this period. Default is 15 minutes.
    monitor_time_type  = string # Period for periodic execution, Fixed for regular execution.
    monitor_time_value = number # Time period or point in time.
    message_template   = optional(string)     # User define alarm notice.
    classifications    = optional(map(string)) # Alarm classification information map. Key must match regex `^[a-z]([a-z0-9_]{0,49})$`, value length cannot exceed 200 characters. Maximum 20 entries.
    status             = optional(bool, true)  # Whether to enable the alarm policy.
    tags               = optional(map(string)) # Tag description list.
    
    # list of alarm target.
    alarm_targets = list(object({
      logset_id         = optional(string, null) # Logset id.
      logset_name       = optional(string, null) # Logset name.
      topic_id          = optional(string, null) # Topic id.
      topic_name        = optional(string, null) # Topic name.
      query             = string # Query rules.
      number            = number # The number of alarm object.
      start_time_offset = number # Search start time of offset.
      end_time_offset   = number # Search end time of offset.
      syntax_rule       = optional(number, 0) # Retrieve grammar rules, 0: Lucene syntax, 1: CQL syntax, Default value is 0.
    }))
    
    # Multidimensional analysis.
    analysis_fields = optional(list(object({
      name    = string # Field name.
      type    = string # Analysis type, support type: "field", "average", "sum", "min", "max"
      content = string # Field content.
      config_info = optional(list(object({
        key   = string # Config key.
        value = string # Config value.
      })), [])
    })), [])
    
    # Multiple triggering conditions.
    multi_conditions = optional(list(object({
      condition   = optional(string)    # Trigger condition.
      alarm_level = optional(number, 0) # Alarm level. 0: Warning; 1: Info; 2: Critical. Default is 0.
    })), [])
    
    # Alarm notice ids.
    alarm_notice_ids = optional(list(string), [])
    
    # Monitor notice configuration for observable platform. Note: AlarmNoticeIds and MonitorNotice cannot be set at the same time.
    monitor_notice = optional(list(object({
      # List of monitor notice rules.
      notices = optional(list(object({
        notice_id       = string                 # Observable platform notification template ID.
        content_tmpl_id = optional(string)       # Observable platform content template ID. If empty, use default content template.
        alarm_levels    = optional(list(number)) # Alarm levels. 0: Warning; 1: Info; 2: Critical.
      })), [])
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for alarm in var.alarms : alarm.trigger_count >= 1 && alarm.trigger_count <= 2000
    ])
    error_message = "The value range of trigger_count is from 1 to 2000."
  }

  validation {
    condition = alltrue([
      for alarm in var.alarms :
        contains([0, 5, 10, 15, 30, 60, 120, 180, 360, 1440], alarm.alarm_period)
    ])
    error_message = "The value range of alarm_period is from 0 to 1440 minutes."
  }

  validation {
    condition = alltrue([
      for alarm in var.alarms : length(alarm.alarm_targets) >= 1
    ])
    error_message = "At least one alarm monitoring object needs to be configured."
  }

  validation {
    condition = alltrue([
      for alarm in var.alarms : contains(["Period", "Time"], alarm.monitor_time_type)
    ])
    error_message = "monitor_time_type only support: Period or Time."
  }

  validation {
    condition = alltrue([
      for alarm in var.alarms : alarm.monitor_time_value >= 1 && alarm.monitor_time_value <= 1440
    ])
    error_message = "The value range of monitor_time_value is from 1 to 1440 minutes."
  }

  validation {
    condition = alltrue([
      for alarm in var.alarms : length(alarm.monitor_notice) <= 1
    ])
    error_message = "monitor_notice at most one."
  }

  validation {
    condition = alltrue([
      for alarm in var.alarms : length(alarm.alarm_notice_ids) == 0 || length(alarm.monitor_notice) == 0
    ])
    error_message = "The alarm_notice_ids and monitor_notice cannot be set at the same time."
  }
}