variable "name" {
  description = "Name of CAM role"
  type = string
}

variable "description" {
  description = "Description of CAM role"
  type = string
  default = ""
}

variable "statement" {
	description = "Statement of CAM role"
	type = list(any)
}

variable "session_duration" {
	description = "The maximum validity period of the temporary key for creating a role"
	type = number
	default = 7200
}

variable "tag" {
	description = "A list of tags used to associate different resources"
	type = map(string)
	default = {}
}

variable "role_name" {
  description = "Name of the attached CAM role"
  type = string
}

variable "policy_name" {
  description = "Name of the policy"
  type = string
}