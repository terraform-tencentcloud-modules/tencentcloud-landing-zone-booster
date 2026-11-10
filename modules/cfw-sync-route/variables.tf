variable "sync_type" {
  description = "Synchronization operation type: Route, synchronize firewall routing."
  type        = string
  default     = "Route"
}

variable "fw_type" {
  description = "Firewall type; nat: nat firewall; ew: inter-vpc firewall."
  type        = string
  default     = null
}