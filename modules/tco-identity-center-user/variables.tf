variable "create" {
  type = bool
  default = true
  description = "create or not"
}

variable "zone_id" {
  type = string
  description = "cic zone id, copy from console"
  default = ""
}

variable "users" {
  description = "A map of users for creation. Key is unique user reference."
  type = map(object({
    user_name    = string           # User name. It must be unique in space. Modifications are not supported. Format: Contains numbers, English letters and special symbols(+, =, ,, ., @, -, _). Length: Maximum 64 characters.
    email        = optional(string) # The user's email address. Must be unique within the catalog. Length: Maximum 128 characters.
    first_name   = optional(string) # The user's first name. Length: Maximum 64 characters.
    last_name    = optional(string) # The user's last name. Length: Maximum 64 characters.
    display_name = optional(string) # The display name of the user. Length: Maximum 256 characters.
    user_status  = optional(string) # The status of the user. Value: Enabled (default): Enabled. Disabled: Disabled.
    description  = optional(string) # center user description
  }))
}