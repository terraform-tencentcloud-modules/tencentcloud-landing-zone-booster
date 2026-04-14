variable "ccn_id" {
  description = "The ID of ccn which to attach."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Type of attached instance network, and available values include VPC, DIRECTCONNECT, BMVPC and VPNGW."
  type        = string
  default     = "VPC"
}

variable "instance_id" {
  description = "ID of instance which will be attached."
  type        = string
  default     = ""
}

variable "instance_region" {
  description = "The region which the attached instance locates at."
  type        = string
}

variable "description" {
  description = "Description of the CCN to be created, and maximum length does not exceed 100 bytes."
  type        = string
  default     = ""
}

variable "ccn_uin" {
  description = "Uin of the ccn attached. If not set, which means the uin of this account. This parameter is used with case when attaching ccn of other account to the instance of this account. For now only support instance type `VPC`."
  type        = string
  default     = null
}