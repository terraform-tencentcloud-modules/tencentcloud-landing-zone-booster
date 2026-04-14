variable "end_point_name" {
  description = "The name of the Private DNS endpoint"
  type        = string
  default     = ""
}

variable "end_point_service_id" {
  description = "The service ID associated with the Private DNS endpoint"
  type        = string
  default     = ""
}

variable "end_point_region" {
  description = "The region for the Private DNS endpoint"
  type        = string
  default     = ""
}

variable "ip_num" {
  description = "The number of IPs for the endpoint"
  type        = number
  default     = 1
}