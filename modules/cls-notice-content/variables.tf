variable "notice_content_name" {
  description = "The name of notice content"
  type        = string
}

variable "notice_content_channel" {
  description = "Channel type. Email, Sms, WeChat, Phone, WeCom, DingTalk, Lark, Http"
  type        = string
  default     = "Http"
}

variable "notice_content_trigger_title" {
  description = "The title of notice content"
  type        = string
  default     = ""
}

variable "notice_content_trigger_content" {
  description = "Notification content template body information"
  type        = string
}

variable "notice_content_trigger_headers" {
  description = "Request headers: In HTTP requests, request headers contain additional information sent by the client to the server"
  type        = set(string)
  default     = ["Content-Type:application/json"]
}

variable "notice_content_recovery_title" {
  description = "The title of notice content"
  type        = string
  default     = ""
}

variable "notice_content_recovery_content" {
  description = "Notification content template body information"
  type        = string
}

variable "notice_content_recovery_headers" {
  description = "Request headers: In HTTP requests, request headers contain additional information sent by the client to the server"
  type        = set(string)
  default     = ["Content-Type:application/json"]
}
