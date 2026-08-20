variable "cam_role" {
  description = "Configuration for CAM role"
  type = object({
    name             = string                 # Name of the CAM role, must be unique
    description      = optional(string)       # Description of the CAM role
    document         = optional(string)       # Document of the CAM role
    session_duration = optional(number, 7200) # Maximum validity period of the temporary key in seconds, default is 7200 (2 hours)
    console_login    = optional(bool, false)  # Whether the role can be used to log in to the console, default is false
    tags             = optional(map(string))  # Tags for resource classification and management
  })
  default = null
}

variable "cam_policies" {
  description = "Configuration for CAM policy"
  type = list(object({
    name        = string           # Name of the CAM policy, must be unique
    description = optional(string) # Description of the CAM policy
    document    = optional(string) # Document of the CAM policy
  }))
  default = null
}

variable "bind_policy_names" {
  description = "Policy names of the attached CAM role"
  type        = list(string)
  default     = []
}
