variable "app_id" {
  description = "Your appid."
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
  default     = "mycos"
}

variable "bucket_acl" {
  description = "Access control list for the bucket."
  type        = string
  default     = "private"
}

variable "multi_az" {
  description = "Indicates whether to create a bucket of multi available zone. NOTE: If set to true, the versioning must enable."
  type        = bool
  default     = false
}

variable "force_clean" {
  description = "Whether to force cleanup all objects before delete bucket."
  type        = bool
  default     = false
}

variable "versioning_enable" {
  description = "Enable bucket versioning."
  type        = bool
  default     = false
}

variable "encryption_algorithm" {
  description = "The server-side encryption algorithm to use. Valid values are `AES256`, `KMS` and `SM4`."
  type        = string
  default     = null
}

variable "kms_id" {
  description = "The KMS Master Key ID. This value is valid only when `encryption_algorithm` is set to KMS. Set kms id to the specified value. If not specified, the default kms id is used."
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules configuration"
  type = list(object({
    id            = optional(string)
    filter_prefix = optional(string)
    expiration    = optional(object({
      days          = optional(number)
      date          = optional(string)
      delete_marker = optional(bool)
    }))

    transition = optional(list(object({
      days          = optional(number)
      date          = optional(string)
      storage_class = string
    })), [])

    non_current_expiration = optional(object({
      non_current_days = number
    }))

    non_current_transition = optional(list(object({
      non_current_days = number
      storage_class    = string
    })), [])

    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }))
  }))
  default = []
}

variable "cors_rules" {
  description = "A rule of Cross-Origin Resource Sharing"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), ["ETag", "Content-Length", "x-cos-request-id"])
    max_age_seconds = optional(number, 0)
  }))
  default = []
}

variable "origin_pull_rules" {
  description = "Bucket Origin-Pull settings"
  type = list(object({
    host                = string                # Allows only a domain name or IP address. You can optionally append a port number to the address.
    priority            = string                # Priority of origin-pull rules, do not set the same value for multiple rules.
    back_to_source_mode = optional(string)      # Back to source mode. Allow value: Proxy, Mirror, Redirect.
    custom_http_headers = optional(map(string)) # Specifies the custom headers that you can add for COS to access your origin server.
    follow_http_headers = optional(set(string)) # Specifies the pass through headers when accessing the origin server.
    follow_query_string = optional(bool)        # Specifies whether to pass through COS request query string when accessing the origin server.
    follow_redirection  = optional(bool)        # Specifies whether to follow 3XX redirect to another origin server to pull data from.
    http_redirect_code  = optional(string)      # Redirect code. Effective when back_to_source_mode is Redirect. ex: 301, 302, 307. Default is 302.
    prefix              = optional(string)      # Triggers the origin-pull rule when the requested file name matches this prefix.
    protocol            = optional(string)      # the protocol used for COS to access the specified origin server. The available value include HTTP, HTTPS and FOLLOW.
  }))
  default = []
}

variable "log_enable" {
  description = "Indicate the access log of this bucket to be saved or not."
  type        = bool
  default     = false
}

variable "log_prefix" {
  description = "The prefix log name which saves the access log of this bucket per 5 minutes. Eg. MyLogPrefix/. The log access file format is log_target_bucket/log_prefix{YYYY}/{MM}/{DD}/{time}{random}{index}.gz. Only valid when log_enable is true."
  type        = string
  default     = ""
}

variable "log_target_bucket" {
  description = "The target bucket name which saves the access log of this bucket per 5 minutes. The log access file format is log_target_bucket/log_prefix{YYYY}/{MM}/{DD}/{time}{random}{index}.gz. Only valid when log_enable is true. User must have full access on this bucket."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}