variable "baseline_name" {
  description = "Baseline name"
  type        = string
}

variable "member_list" {
  description = "Member account UIN, which is also the UIN of the account to which the baseline is applied. UIN and Name must be set at least one"
  type        = list(object({
    member_uin  = optional(number, null) # Member UIN, if not set, use member name
    member_name = optional(string, null) # Member Name, if not set, use member uin
  }))
}

variable "cam_security" {
  description = "Cam user password must contain"
  type        = object({
    enabled = bool
    security_mfa_devices         = optional(list(string), ["Stoken", "U2FToken", "Phone", "Mail"]) # Cam user security mfa devices
    security_mfa_login_strategy  = optional(number, 1)      # Cam user security login strategy, 1 - MFA is Enforced, 2 - Choose by User
    security_mfa_action_strategy = optional(number, 2)      # Cam user security action strategy, 2 - Choose by User
    security_login_idle_timeout  = optional(number, 900)    # Cam user login idle session timeout
    security_login_max_timeout   = optional(number, 3600)   # Cam user login max session timeout
  })
  default = {
    enabled = false
  }

  validation {
    condition = contains([1, 2], var.cam_security.security_mfa_login_strategy)
    error_message = "security_mfa_login_strategy must be 1 or 2."
  }

  validation {
    condition = contains([2], var.cam_security.security_mfa_action_strategy)
    error_message = "security_mfa_action_strategy must be 2."
  }
}

variable "cam_password" {
  description = "Cam user password must contain"
  type        = object({
    enabled = bool
    password_must_contain        = optional(string, "1!aA") # Cam user password must contain
    password_minimum_length      = optional(number, 8)      # Cam user password minimum length, maximum value is 32
    password_force_change        = optional(number, 0)      # Cam user force password change, maximum value is 365, 0 means no limit
    password_reuse_limit         = optional(number, 1)      # Cam user password reuse limit, maximum limit is 24, 0 means no limit
    password_retry_limit         = optional(number, 10)     # Cam user password retry limit, minimum limit is 1/hour
  })
  default = {
    enabled = false
  }
}

# Contact
variable "account_contact" {
  description = "Account contacts"
  type = object({
    enabled  = bool
    contacts = optional(list(object({
      name         = string
      phone_num    = string
      email        = string
      remark       = string
      country_code = string
    })), [])
  })
  default = {
    enabled = false
  }
}

# Message
variable "account_message" {
  description = "Account message"
  type = object({
    enabled  = bool
    messages = optional(list(object({
      msg_type = string
      channel  = string
      names    = list(string)
    })), [])
  })
  default = {
    enabled = false
  }
}

# preset tags
variable "tag_info" {
  description = "Tag values"
  type = object({
    enabled = bool
    tags    = optional(list(object({
      Key    = string
      Values = list(string)
    })), [])
  })
  default = {
    enabled = false
  }
}

variable "security_group" {
  description = "Security group name"
  type = object({
    enabled = bool
    name    = optional(string) # Security group name
    region  = optional(string) # Region
    remark  = optional(string, "") # Security group remark
    ingress_rules = optional(list(object({
      cidr     = string
      protocol = string
      port     = string
      remark   = string
      action   = string
      type     = string
    })), [])
    egress_rules = optional(list(object({
      cidr     = string
      protocol = string
      port     = string
      remark   = string
      action   = string
      type     = string
    })), [])
  })
  default = {
    enabled = false
  }
}

variable "vpc_info" {
  description = "VPC baseline info"
  type = object({
    enabled = bool
    name    = optional(string) # VPC name
    cidr    = optional(string) # VPC CIDR block
    region  = optional(string) # VPC region
    subnets = optional(list(object({
      subnet_name = string
      cidr_block  = string
      zone        = string
    })))
  })
  default = {
    enabled = false
  }
}

variable "share_image" {
  description = "Share image baseline info"
  type = object({
    enabled = bool
    images  = optional(list(object({
      region     = string
      image_id   = string
      image_name = string
    })), [])
  })
  default = {
    enabled = false
  }
}