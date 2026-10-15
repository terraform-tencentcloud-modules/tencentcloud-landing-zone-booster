variable "status" {
  description = "Whether to enable resource monitoring. true: enable (OpenConfigRecorder), false: disable (CloseConfigRecorder). This is an account-level singleton: only ONE recorder config exists per account, so this module manages a single instance (do not declare multiple)."
  type        = bool
}

variable "resource_types" {
  description = "Resource type list to monitor (e.g. QCS::CAM::Group, QCS::CVM::Instance). Optional; each item must start with 'QCS::'. When omitted, the recorder keeps its existing or default monitoring scope."
  type        = list(string)
  default     = null
}
