variable "clb_instance_id" {
  description = "CLB instance ID."
  type        = string
}

variable "logset_period" {
  description = "Logset retention period in days. Maximun value is `90`."
  type        = number
  default     = 7
}

variable "log_topic_name" {
  description = "Log topic of CLB instance."
  type        = string
}

variable "log_topic_status" {
  description = "The status of log topic. true: enable; false: disable. Default is true."
  type        = bool
  default     = true
}