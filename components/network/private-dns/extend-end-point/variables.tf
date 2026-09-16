################################################################################
### Private DNS Extend End Point Configuration
################################################################################
variable "extend_end_points" {
  description = "Map of Private DNS extend end point configurations (supports multiple forward IPs)"
  type = map(object({
    end_point_name   = string # Endpoint name
    end_point_region = string # Region

    # Forward IP configuration (supports multiple IPs)
    forward_ip = list(object({
      access_type       = string           # CLB or CCN
      host              = optional(string) # IP address (mutually exclusive with hosts)
      hosts             = optional(set(string)) # IP addresses set (mutually exclusive with host)
      port              = number           # Port number (1-65535)
      vpc_id            = string           # VPC ID (required)
      access_gateway_id = optional(string) # CCN ID (required when access_type is CCN)
    }))
  }))
  default = {}
}