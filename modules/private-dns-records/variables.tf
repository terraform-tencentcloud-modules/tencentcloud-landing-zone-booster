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

variable "records" {
  description = "A map of DNS records to create, and sub_domain is the map key."
  type = map(object({
    record_type  = optional(string)
    record_value = optional(string)
    sub_domain   = optional(string)
    ttl          = optional(number)
    weight       = optional(number)
    mx           = optional(number)
  }))
  default = {
    example = {
      record_type  = "A"
      record_value = "1.1.1.1"
      sub_domain   = "www"
      ttl          = 600
      weight       = 10
      mx           = 5 // 5, 10, 15, 20, 30, 40, 50.
    }
  }
}