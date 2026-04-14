variable "vpc_id" {
  description = "ID of the VPC associated with the target group"
  type        = string
  default     = null
}

variable "target_group_name" {
  description = "The name of the target group"
  type        = string
  default     = null
}

variable "target_group_type" {
  description = "Target group type, currently supported v1 (legacy version target group) and v2 (new version target group), defaults to v1 (legacy version target group)."
  type        = string
  default     = null
}

variable "target_group_protocol" {
  description = "Backend forwarding protocol of the target group. this field is required for the new version (v2) target group. currently supports TCP, UDP, HTTP, HTTPS, GRPC."
  type        = string
  default     = null
}

variable "target_group_port" {
  description = "The default port of targets register to the target group"
  type        = number
  default     = null
}

variable "target_instances" {
  description = "List of instances to attach to the target group"
  type = list(object({
    bind_ip = string
    port    = number
    weight  = optional(number, 10)
  }))
  default = []
}