# terraform-tencentcloud-tco-invite-organization-member-operation

Terraform module which invites a member account to join a TencentCloud Organization on TencentCloud.

The following resources are included.

* [Invite Organization Member Operation](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/invite_organization_member_operation)

## Usage

```hcl
variable "member_uin" {
  type    = string
  default = "100000001"
}

variable "name" {
  type    = string
  default = "example-member"
}

variable "node_id" {
  type    = number
  default = 1001
}

module "invite_organization_member_operation" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-invite-organization-member-operation.git"

  member_uin     = var.member_uin
  name           = var.name
  node_id        = var.node_id
  policy_type    = "Financial"
  permission_ids = [1, 2]
  is_allow_quit  = "Allow"
  remark         = "Invited member"
  pay_uin        = null
  tags = {
    env = "prod"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Whether to invite the member. | bool | true | no |
| member_uin | (Required, ForceNew) Invited account UIN. | string | n/a | yes |
| name | Member name. | string | n/a | yes |
| node_id | Organization node ID. | number | n/a | yes |
| policy_type | Organization policy type. `Financial`: Financial management policy. | string | "Financial" | no |
| permission_ids | Financial management permission IDs. Valid values: 1 (View bill), 2 (Check balance), 3 (Fund transfer), 4 (Combine bill), 5 (Issue an invoice), 6 (Inherit discount), 7 (Pay on behalf). Values 1 and 2 are required. | list(number) | [] | no |
| is_allow_quit | (Optional, ForceNew) Whether to allow members to withdraw. `Allow` or `Disallow`. | string | "Allow" | no |
| pay_uin | Payer UIN. The member needs to pay on behalf of this UIN. | string | null | no |
| remark | Remark. | string | "" | no |
| region | Region. | string | "" | no |
| tags | Resource tags. | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| member_uin | The UIN of the invited member. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-invite-organization-member-operation)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.