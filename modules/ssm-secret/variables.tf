# Basic Configuration Variables
variable "secret_name" {
  type        = string
  description = "(Required) Name of the secret. The maximum length is 128 bytes. The name can only contain English letters, numbers, underscore and hyphen '-'. The first character must be a letter or number."
  validation {
    condition     = length(var.secret_name) > 0 && length(var.secret_name) <= 128
    error_message = "Secret name must be between 1 and 128 characters long."
  }
}

variable "secret_description" {
  type        = string
  description = "(Optional) Description of the secret. The maximum length is 2048 bytes."
  default     = "Managed by Terraform"
}

variable "secret_version_id" {
  type        = string
  description = "(Optional) Version number of the secret. If not specified, TencentCloud will automatically generate a version number starting with v1."
  default     = ""
}

variable "secret_string" {
  type        = string
  description = "(Optional) Text of the secret in plain text. Either `secret_string` or `secret_binary` must be specified, but not both."
  default     = ""
  sensitive   = true
}

variable "secret_binary" {
  type        = string
  description = "(Optional) Binary data of the secret in base64 format. Either `secret_string` or `secret_binary` must be specified, but not both."
  default     = ""
  sensitive   = true
}



# Other Configuration Variables
variable "recovery_window_in_days" {
  type        = number
  description = "(Optional) Number of days to wait before permanently deleting the secret. During this period, the secret can be recovered. Default is 0 (delete immediately)."
  default     = 0
  validation {
    condition     = var.recovery_window_in_days >= 0 && var.recovery_window_in_days <= 30
    error_message = "Recovery window must be between 0 and 30 days."
  }
}

variable "secret_enabled" {
  type        = bool
  description = "(Optional) Whether the secret is enabled. Default is true."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Tags of the secret."
  default     = {}
}

variable "kms_key_id" {
  type        = string
  description = "(Optional) KMS keyId used to encrypt secret. If it is empty, it means that the CMK created by SSM for you by default is used for encryption. You can also specify the KMS CMK created by yourself in the same region for encryption."
  default     = ""
}

variable "additional_config" {
  type        = string
  description = "(Optional) Additional config for specific secret types in JSON string format."
  default     = ""
}

variable "secret_type" {
  type        = number
  description = "(Optional) Type of secret. 0: user-defined secret. 4: redis secret. Default is 0."
  default     = 0
  validation {
    condition     = contains([0, 4], var.secret_type)
    error_message = "Secret type must be 0 (user-defined) or 4 (redis)."
  }
}