variable "create_key" {
  description = "Whether to create the KMS key"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "Name of the KMS key"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = ""
}
variable "is_enabled" {
  description = "Whether the key is enabled"
  type        = bool
  default     = true
}

variable "key_usage" {
  description = "Usage of CMK. Available values include `ENCRYPT_DECRYPT`, `ASYMMETRIC_DECRYPT_RSA_2048`, `ASYMMETRIC_DECRYPT_SM2`, `ASYMMETRIC_SIGN_VERIFY_SM2`, `ASYMMETRIC_SIGN_VERIFY_RSA_2048`, `ASYMMETRIC_SIGN_VERIFY_ECC`. Default value is `ENCRYPT_DECRYPT`."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "key_rotation_enabled" {
  description = "Specify whether to enable key rotation, valid when key_usage is `ENCRYPT_DECRYPT`. Default value is `false`."
  type        = bool
  default     = false
}

variable "hsm_cluster_id" {
  description = "The HSM cluster ID corresponding to KMS Advanced Edition (only valid for KMS Exclusive/Managed Edition service instances)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the KMS key"
  type        = map(string)
  default     = {}
}
