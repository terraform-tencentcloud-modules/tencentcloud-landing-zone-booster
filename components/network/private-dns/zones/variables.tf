################################################################################
### Enable Private Zone Service
################################################################################
variable "enable_private_zone_service" {
  description = "Whether to enable private zone service subscription"
  type        = bool
  default     = false
}

################################################################################
### Private DNS Zone Configuration
################################################################################
variable "zones" {
  description = "Map of Private DNS zone configurations"
  type = map(object({
    # Basic Configuration
    domain = string                        # Required: domain name
    remark = optional(string)              # Optional: zone description

    # DNS Configuration
    dns_forward_status   = optional(string, "DISABLED") # ENABLED or DISABLED
    cname_speedup_status = optional(string, "ENABLED")  # ENABLED or DISABLED

    # VPC Associations (same account)
    vpc_set = optional(list(object({
      uniq_vpc_id = string # VPC ID
      region      = string # Region
    })), [])

    # Account VPC Associations (cross-account)
    account_vpc_set = optional(list(object({
      uin         = string # Account UIN
      uniq_vpc_id = string # VPC ID
      region      = string # Region
      vpc_name    = string # VPC name (required)
    })), [])

    # Tags
    tags = optional(map(string), {})
  }))
  default = {}
}

################################################################################
### Private DNS Record Configuration
################################################################################
variable "records" {
  description = "Map of Private DNS record configurations"
  type = map(object({
    zone_key     = optional(string) # Reference to zone key in var.zones
    zone_id      = optional(string) # Direct zone ID (alternative to zone_key)
    record_type  = string           # A, AAAA, CNAME, MX, TXT, PTR
    sub_domain   = string           # Subdomain name
    record_value = string           # Record value
    ttl          = optional(number, 600)
    weight       = optional(number) # 1-100, for load balancing
    mx           = optional(number) # 1-50, only for MX records
  }))
  default = {}
}

################################################################################
### Private DNS Zone VPC Attachment Configuration
################################################################################
variable "vpc_attachments" {
  description = "Map of Private DNS zone VPC attachment configurations"
  type = map(object({
    zone_key = optional(string) # Reference to zone key in var.zones
    zone_id  = optional(string) # Direct zone ID (alternative to zone_key)

    # VPC Set (same account)
    vpc_set = optional(object({
      uniq_vpc_id = string # VPC ID
      region      = string # Region
    }))

    # Account VPC Set (cross-account)
    account_vpc_set = optional(object({
      uin         = string # Account UIN
      uniq_vpc_id = string # VPC ID
      region      = string # Region
    }))
  }))
  default = {}
}

################################################################################
### Private DNS Forward Rule Configuration
################################################################################
variable "forward_rules" {
  description = "Map of Private DNS forward rule configurations"
  type = map(object({
    rule_name           = string           # Forward rule name
    rule_type           = string           # DOWN (from cloud to IDC) or UP (from IDC to cloud)
    zone_key            = optional(string) # Reference to zone key in var.zones
    zone_id             = optional(string) # Direct zone ID (alternative to zone_key)
    endpoint_key        = optional(string) # Reference to endpoint key in var.end_points
    extend_endpoint_key = optional(string) # Reference to extend endpoint key in var.extend_end_points
    end_point_id        = optional(string) # Direct endpoint ID (alternative to endpoint_key)
  }))
  default = {}
}