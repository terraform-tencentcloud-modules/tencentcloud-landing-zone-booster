################################################################################
### Private DNS Inbound Endpoint Configuration
################################################################################
variable "inbound_endpoints" {
  description = "Map of Private DNS inbound endpoint configurations"
  type = map(object({
    endpoint_region = string # Region
    endpoint_name   = string # Endpoint name
    endpoint_vpc    = string # VPC ID

    # Subnet IP (at least 1 required)
    subnet_ip = list(object({
      subnet_id  = string           # Subnet ID
      subnet_vip = optional(string) # IP address (auto-assigned if not specified)
    }))
  }))
  default = {}
}