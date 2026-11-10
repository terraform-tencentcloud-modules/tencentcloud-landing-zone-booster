# terraform-tencentcloud-tco-organization-org-member-auth-identity

Terraform module which attaches organization identities (cross-account access identities) to members on TencentCloud.

The following resources are included.

* [Organization Org Member Auth Identity Attachment](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_member_auth_identity_attachment)

## Usage

```hcl
variable "member_identity_ids" {
  type = list(object({
    member_uin   = number       # Member UIN.
    identity_ids = list(number) # Identity ID list. Up to 5.
  }))
  default = [
    {
      member_uin   = 1000001
      identity_ids = [1, 2]
    }
  ]
}

module "organization_org_member_auth_identity" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-member-auth-identity.git"

  member_identity_ids = var.member_identity_ids
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| member_identity_ids | A list of member identity attachments. Each item contains: `member_uin` (member UIN), `identity_ids` (list of identity IDs, up to 5). | list(object({ member_uin = number, identity_ids = list(number) })) | n/a | yes |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-member-auth-identity)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
