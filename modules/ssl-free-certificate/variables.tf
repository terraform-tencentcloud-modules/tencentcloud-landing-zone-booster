variable "project_id" {
  type        = number
  default     = null
  description = "ID of projects which this certification belong to."
}

variable "alias" {
  type        = string
  default     = null
  description = "Specify alias for remark."
}

variable "dv_auth_method" {
  type        = string
  description = "Specify DV authorize method. Available values: `DNS_AUTO` - automatic DNS auth, `DNS` - manual DNS auth, `FILE` - auth by file."

  validation {
    condition     = contains(["DNS_AUTO", "DNS", "FILE"], var.dv_auth_method)
    error_message = "dv_auth_method must be one of: DNS_AUTO, DNS, FILE."
  }
}

variable "domain" {
  type        = string
  description = "Specify domain name."
}

variable "package_type" {
  type        = string
  default     = "2"
  description = "Type of package. Only support `2` (TrustAsia TLS RSA CA)."

  validation {
    condition     = var.package_type == "2"
    error_message = "package_type only support '2' (TrustAsia TLS RSA CA)."
  }
}

variable "contact_email" {
  type        = string
  default     = null
  description = "Email address."
}

variable "contact_phone" {
  type        = string
  default     = null
  description = "Phone number."
}

variable "validity_period" {
  type        = string
  default     = "3"
  description = "Specify validity period in month, only support `3` months for now."

  validation {
    condition     = var.validity_period == "3"
    error_message = "validity_period only support '3' months."
  }
}

variable "csr_encrypt_algo" {
  type        = string
  default     = "RSA"
  description = "Specify CSR encrypt algorithm, only support `RSA` for now."

  validation {
    condition     = var.csr_encrypt_algo == "RSA"
    error_message = "csr_encrypt_algo only support 'RSA'."
  }
}

variable "csr_key_parameter" {
  type        = string
  default     = "2048"
  description = "Specify CSR key parameter, only support `2048` for now."

  validation {
    condition     = var.csr_key_parameter == "2048"
    error_message = "csr_key_parameter only support '2048'."
  }
}

variable "csr_key_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "Specify CSR key password."
}

variable "old_certificate_id" {
  type        = string
  default     = null
  description = "Specify old certificate ID, used for re-apply."
}