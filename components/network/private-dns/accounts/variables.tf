################################################################################
### Private DNS Account Association Configuration
################################################################################
variable "account_associations" {
  description = "Map of Private DNS account associations for cross-account VPC binding. Key is a unique identifier, value contains account_uin."
  type = map(object({
    account_uin = string # Required: UIN of the associated account
  }))
  default = {}
}