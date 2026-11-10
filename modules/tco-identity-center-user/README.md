# terraform-tencentcloud-tco-identity-center-user

Terraform module which creates Identity Center users on TencentCloud.

The following resources are included.

* [Identity Center User](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/identity_center_user)

## Usage

```hcl
variable "zone_id" {
  type    = string
  default = "z-xxxxxxxxxxxxxxxxxxxx"
}

variable "users" {
  type = map(object({
    user_name    = string           # User name. Must be unique and cannot be modified. Format: numbers, English letters and special symbols (+, =, ,, ., @, -, _). Max 64 characters.
    email        = optional(string) # User's email address. Must be unique within the catalog. Max 128 characters.
    first_name   = optional(string) # User's first name. Max 64 characters.
    last_name    = optional(string) # User's last name. Max 64 characters.
    display_name = optional(string) # Display name of the user. Max 256 characters.
    user_status  = optional(string) # Status of the user. Enabled (default) or Disabled.
    description  = optional(string) # User description.
  }))
  default = {
    alice = {
      user_name    = "alice"
      email        = "alice@example.com"
      first_name   = "Alice"
      last_name    = "Smith"
      display_name = "Alice Smith"
      user_status  = "Enabled"
      description  = "Developer account"
    }
  }
}

module "identity_center_user" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-user.git"

  zone_id = var.zone_id
  users   = var.users
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Whether to create the Identity Center users. | bool | true | no |
| zone_id | CIC zone ID, copied from the console. | string | "" | no |
| users | A map of users for creation. Key is a unique user reference. Each object contains: `user_name` (required, unique, max 64 chars), optional `email` (unique, max 128 chars), optional `first_name` (max 64), optional `last_name` (max 64), optional `display_name` (max 256), optional `user_status` (Enabled/Disabled, default Enabled), optional `description`. | map(object({ user_name = string, email = optional(string), first_name = optional(string), last_name = optional(string), display_name = optional(string), user_status = optional(string), description = optional(string) })) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| users | A map of all created Identity Center user resources. |
| user_ids | A map of user keys to the created Identity Center user IDs. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-user)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
