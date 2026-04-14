variable "name" {
  description = "The name of PostgreSQL instance"
  type        = string
}

variable "availability_zones" {
  description = "The list of available zone of the PostgreSQL instance, the first record will always be PRIMARY node"
  type        = list(string)
  default     = ["ap-singapore-2"]
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet within this VPC"
  type        = string
}

variable "db_major_version" {
  description = "PostgreSQL major version number. Valid values: 10, 11, 12, 13, 14, 15, 16, 17. If it is specified"
  type        = string
  default     = "17"
}

variable "password" {
  description = "Password to set, random password if password not supplied"
  type        = string
  default     = null
}

variable "random_password_length" {
  description = "The maximum length of generated password"
  type        = number
  default     = 12
}

variable "random_password_special" {
  description = "Whether the generate password contain special character"
  type        = bool
  default     = true
}

variable "random_password_min_special" {
  description = "Minimum special character in random password"
  type        = number
  default     = 1
}

variable "random_password_min_upper" {
  description = "Minimum upper case character in random password"
  type        = number
  default     = 1
}

variable "random_password_min_lower" {
  description = "Minimum lower case character in random password"
  type        = number
  default     = 1
}

variable "random_password_min_numeric" {
  description = "Minimum numeric character in random password"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "Number of CPU cores"
  type        = number
}

variable "memory" {
  description = "Memory size (in GB)"
  type        = number
}

variable "storage" {
  description = "Volume size (in GB), Allowed value must be a multiple of 10"
  type        = number
}

variable "allow_cidr_list" {
  description = "List of CIDR to be allow to access PostgreSQL"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "port" {
  description = "Port number to allow to access PostgreSQL"
  type        = number
  default     = 5432
}

variable "backup_period" {
  description = "List of backup period per week, available values: monday, tuesday, wednesday, thursday, friday, saturday, sunday. NOTE: At least specify two days"
  type        = list(string)
  default     = ["wednesday", "saturday"]
}

variable "backup_retention_period" {
  description = "Specify days of the backup retention"
  type        = number
  default     = 5
}

variable "backup_min_start_time" {
  description = "Specify earliest backup start time, format hh:mm:ss"
  type        = string
  default     = "01:10:00"
}

variable "backup_max_start_time" {
  description = "Specify latest backup start time, format hh:mm:ss"
  type        = string
  default     = "02:10:00"
}

variable "readonly_instances" {
  description = "Number of readonly instances"
  type        = number
  default     = 0
}

variable "ro_cpu" {
  description = "Number of CPU cores for Read-Only instances"
  type        = number
  default     = null
}

variable "ro_memory" {
  description = "Memory size (in GB) for Read-Only instances"
  type        = number
  default     = null
}

variable "ro_storage" {
  description = "Volume size (in GB) for Read-Only instances, Allowed value must be a multiple of 10"
  type        = number
  default     = null
}

variable "create_kms_key" {
  description = "Whether create kms key"
  type        = bool
  default     = false
}

variable "users" {
  description = "Whether create custom user for database"
  type = map(object({
    password = optional(string)
    type     = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
