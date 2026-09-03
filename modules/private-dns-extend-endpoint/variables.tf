variable "create" {
  type        = bool
  default     = true
  description = "Create or use an existed one"
}

variable "end_point_name" {
  type        = string
  default     = ""
  description = "Endpoint name"
}

variable "end_point_region" {
  default     = ""
  type        = string
  description = "Endpoint region, which should be consistent with the region of the endpoint service."
}

variable "forwards" {
  description = <<-EOT
    Forwarding targets of the Private DNS outbound endpoint.

    Each entry maps to one `forward_ip` block:
      - access_type "CLB": single target via `host` + `port`, no `access_gateway_id`.
      - access_type "CCN": one or more targets via `hosts` ("ip:port" strings) + `access_gateway_id` (CCN instance ID); `port` may be any port listed in `hosts`.

    Note: `forward_ip` is ForceNew in the provider. Any change to this variable
    recreates the endpoint and, transitively, dependent forward rules.
  EOT
  type = list(object({
    access_type       = string
    host              = optional(string)
    hosts             = optional(set(string))
    port              = number
    vpc_id            = string
    access_gateway_id = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.forwards : (
        f.access_type == "CLB" && f.host != null && f.hosts == null && f.access_gateway_id == null
        ) || (
        f.access_type == "CCN" && f.host == null && f.hosts != null && length(f.hosts) > 0 && alltrue([for h in f.hosts : trimprefix(h, "") != ""]) && f.access_gateway_id != null && can(regex("^ccn-", f.access_gateway_id))
      )
    ])
    error_message = "Each forward must be either: access_type=\"CLB\" with host and port set (no hosts/access_gateway_id), or access_type=\"CCN\" with non-empty hosts (\"ip:port\" list, no empty strings), port and access_gateway_id (must be non-empty and start with 'ccn-') set."
  }

  validation {
    condition     = !var.create || length(var.forwards) > 0
    error_message = "At least one entry in `forwards` is required when `create` is true (the endpoint API requires a forwarding target)."
  }
}