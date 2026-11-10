variable "public_ip" {
  description = "Public Ip."
  type        = string
}

variable "subnet_id" {
  description = "The first EIP switch in the vpc is turned on, and you need to specify a subnet to create a private connection. If `switch_mode` is 1 and `enable` is 1, this field is required."
  type        = string
  default     = null
}

variable "switch_mode" {
  description = "0: bypass; 1: serial."
  type        = number
  default     = 1
}

variable "enable" {
  description = "Switch, 0: off, 1: on."
  type        = number
  default     = 1
}