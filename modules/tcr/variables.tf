################################################################################
### TCR Cam Role Configuration
################################################################################
variable "create_cam_strategy" {
  type        = bool
  default     = false
  description = "Specify whether to create CAM role and relative TKE essential policy. Set to false if you've enable by using TencentCloud Console."
}

################################################################################
### TCR Instance Configuration
################################################################################
variable "instance_config" {
  description = "Configuration for TCR instance."
  type = object({
    name                   = string                    # Name of the TCR instance
    type                   = optional(string, "basic") # TCR types: basic, standard, premium
    delete_bucket          = optional(bool, false)     # ndicate to delete the COS bucket which is auto-created with the instance or not, default is false
    enable_internet_access = optional(bool, false)     # Enable public network access, default false
    charge_type            = optional(number, 1)       # 1: postpaid, 2: prepaid
    prepaid_period         = optional(number, 1)       # Prepaid period in months (1-12)
    prepaid_renew_flag     = optional(number, 2)       # 1: manual, 2: auto renew, 3: no renew
    security_policies = optional(list(object({         # Public network allowlist policies
      cidr_block  = optional(string)                   # CIDR block for access control
      description = optional(string)                   # Description of the policy
    })), [])
  })
}

################################################################################
### VPC Attachment Configuration
################################################################################
variable "vpc_attachment_config" {
  description = "Configuration for VPC attachment."
  type = object({
    region = optional(string, "ap-jakarta")           # Region for VPC attachment
    vpc_subnet_pairs = optional(list(object({         # List of VPC and subnet pairs
      vpc_id                   = string               # VPC ID to attach
      subnet_id                = string               # Subnet ID within the VPC
      enable_public_domain_dns = optional(bool, true) # Enable public domain DNS
      enable_vpc_domain_dns    = optional(bool, true) # Enable VPC domain DNS
    })), [])
  })
  default = {}
}

################################################################################
### TCR Namespace Configuration
################################################################################
variable "tcr_namespaces" {
  description = "TCR namespace configuration list."
  type = set(object({
    name           = string                # Namespace name (required)
    is_auto_scan   = optional(bool, true)  # Auto scan images for vulnerabilities
    is_public      = optional(bool, false) # Make namespace publicly accessible
    is_prevent_vul = optional(bool, true)  # Block vulnerable image deployment
    severity       = optional(string)      # Vulnerability severity: low, medium, high
  }))
  default = []
}

################################################################################
### TCR Repository Configuration
################################################################################
variable "tcr_repositories" {
  description = "TCR container repository list."
  type = set(object({
    namespace_name  = string           # Namespace name (required)
    repository_name = string           # Repository name (required)
    brief_desc      = optional(string) # Brief description (optional)
    description     = optional(string) # Detailed description (optional)
  }))
  default = []
}

################################################################################
### TCR Service Account Configuration
################################################################################
variable "tcr_service_accounts" {
  description = "TCR service account configuration list."
  type = set(object({
    account_name           = string                # Service account name (required)
    description            = optional(string)      # Account description (optional)
    disable                = optional(bool, false) # Disable the account, default false
    duration               = optional(number)      # Token validity duration in seconds
    expires_at             = optional(number)      # Service account expiration time (time stamp, unit: milliseconds)
    password               = optional(string, "")  # Custom password (optional), if empty, a random password will be generated
    password_length        = optional(number, 32)  # Random password length, default 32
    permissions = list(object({                    # List of permission objects
      namespace       = string                     # Target namespace for permission
      permission_type = optional(number, 1)        # 1: read/write, 0: read only
    }))
  }))
  default = []
}

################################################################################
### Common Tags
################################################################################
variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "store_credentials_in_ssm" {
  description = "Store credentials in SSM"
  type        = bool
  default     = false
}
