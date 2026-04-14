variable "ccn_id" {
  type        = string
  description = "CCN instance ID"
}

variable "routes" {
  type = list(object({
    route_id = string
    switch   = optional(string, "on")  # on: publish to CCN, off: withdraw from CCN
  }))
  default     = []
  description = "List of routes to publish/withdraw from CCN"
}
