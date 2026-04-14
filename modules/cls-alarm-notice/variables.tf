variable "notice_name" {
  description = "Alarm notice name"
  type        = string
}

variable "notice_type" {
  description = "Notice type. Valid values: `Trigger`, `Recovery`, `All`."
  type        = string
}

variable "notice_receivers_channels" {
  description = "Receiver channels, Vales: Email, Sms, WeChat, Phone"
  type        = set(string)
  default     = []
}

variable "notice_receivers_ids" {
  description = "Receiver ids"
  type        = set(string)
  default     = []
}

variable "notice_receivers_type" {
  description = "Receiver type. Values: `Group`, `Uin`"
  type        = string
  default     = ""
}

variable "notice_content_id" {
  description = "Notice content id"
  type        = string
  default     = ""
}

variable "notice_receivers_start_time" {
  description = "Start time allowed to receive messages"
  type        = string
  default     = ""
}

variable "notice_receivers_end_time" {
  description = "End time allowed to receive messages"
  type        = string
  default     = ""
}

variable "web_callback_id" {
  description = "Web Callback id"
  type        = string
  default     = ""
}

variable "web_callback_name" {
  description = "Callback name"
  type        = string
  default     = ""
}

variable "web_callback_type" {
  description = "Callback type. Values: Http, WeCom, DingTalk, Lark"
  type        = string
  default     = ""
}

variable "web_callback_url" {
  description = "Callback url"
  type        = string
  default     = ""
}

variable "web_callback_method" {
  description = "Callback method. Values: GET, POST"
  type        = string
  default     = "POST"
}

variable "notice_tag" {
  description = "Tag description list."
  type        = map(string)
  default     = {}
}
