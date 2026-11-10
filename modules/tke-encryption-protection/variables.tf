variable "cluster_id" {
  description = "Cluster ID. Identifies the resource (the resource id IS the cluster id). ForceNew."
  type        = string
}

variable "kms_key_id" {
  description = "Custom KMS key ID. If not specified, a default key will be generated (TKE-KMS). Optional."
  type        = string
  default     = null
}

variable "kms_region" {
  description = "Region of the KMS key. Used when generating a default key or customizing the key region. Optional."
  type        = string
  default     = null
}
