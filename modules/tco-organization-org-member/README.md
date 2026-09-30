# terraform-tencentcloud-tco-organization-org-member

Terraform module which creates Organization members and optionally binds security contact information (email/phone) on TencentCloud.

The following resources are included.

* [Organization Org Member](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_member)
* [Organization Org Member Email](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_member_email)

## Usage

```hcl
variable "members" {
  type = list(object({
    name                 = string            # Member name.
    node_id              = number            # Organization node ID.
    permission_ids       = list(number)      # Financial management permission IDs. 1: View bill, 2: Check balance, 3: Fund transfer, 4: Combine bill, 5: Issue invoice, 6: Inherit discount, 7: Pay on behalf. Values 1,2 required.
    policy_type          = string            # Organization policy type. Financial: Financial management policy.
    pay_uin              = string            # Payer UIN. Required when permission_ids contains 7.
    force_delete_account = optional(bool, false) # Whether to force delete the member account when deleting the member. Only for creation-type members.
    is_modify_nick_name  = optional(number)  # Whether to sync member name to account nickname. 1: sync, 0: do not sync.
    record_id            = optional(number)  # Create member record ID. Required when recreation is needed after a failed creation.
    remark               = optional(string)  # Remark.
    tags                 = optional(map(string)) # Member tags.
    enable_bound         = optional(bool, false) # Whether to bind security information; an activation email is sent to the email after binding.
    email                = optional(string)  # Email of the user or contact person.
    phone                = optional(string)  # Phone number of the user or contact person.
    country_code         = optional(number)  # Country code for the phone number (e.g., 86 for China).
  }))
  default = [
    {
      name           = "example-member"
      node_id        = 1001
      permission_ids = [1, 2]
      policy_type    = "Financial"
      pay_uin        = "100000001"
    }
  ]
}

module "organization_org_member" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-member.git"

  members = var.members
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| members | A list of organization members. Each item contains: `name` (member name), `node_id` (node ID), `permission_ids` (list of financial permission IDs), `policy_type` (Financial), `pay_uin` (payer UIN), optional `force_delete_account` (bool, default false), optional `is_modify_nick_name` (number), optional `record_id` (number), optional `remark` (string), optional `tags` (map(string)), optional `enable_bound` (bool, default false), optional `email`, optional `phone`, optional `country_code`. | list(object({ name = string, node_id = number, permission_ids = list(number), policy_type = string, pay_uin = string, force_delete_account = optional(bool, false), is_modify_nick_name = optional(number), record_id = optional(number), remark = optional(string), tags = optional(map(string)), enable_bound = optional(bool, false), email = optional(string), phone = optional(string), country_code = optional(number) })) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| member_uins | A map of member names to the created member UINs. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-member)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
