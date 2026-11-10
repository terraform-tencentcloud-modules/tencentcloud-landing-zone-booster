variable "create" {
  type        = bool
  default     = true
  description = "Create or use an existed one"
}

variable "private_dns_zone_id" {
  type        = string
  default     = ""
  description = "Used when create is false. Specify an existed private_dns"
}

variable "dns_forward_rule_name" {
  type = string
  default = ""
  description = " Forwarding rule name."
}

variable "rule_type" {
  type = string
  default = "UP"
  description = "Forwarding rule type. DOWN: From cloud to off-cloud; UP: From off-cloud to cloud."
}

variable "dns_end_point_id" {
  type = string
  default = ""
  description = "Endpoint ID."
}