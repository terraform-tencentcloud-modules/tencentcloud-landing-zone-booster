# terraform-tencentcloud-vpc-security-group

Terraform module which creates a **VPC Security Group** and its **rule set** on TencentCloud.

The following resources are included.

* [Security Group](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/security_group)
* [Security Group Rule Set](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/security_group_rule_set)

A single `tencentcloud_security_group` is created, and its ingress/egress rules are managed via `tencentcloud_security_group_rule_set`. Rules are ordered; the first rule in the list has the highest priority.

## Usage

```hcl
module "vpc_security_group" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-security-group.git"

  name        = "example-sg"
  description = "example security group"
  project_id  = 0
  tags = {
    "createdBy" = "Terraform"
  }

  ingress_rules = [
    {
      action      = "ACCEPT"
      cidr_block  = "10.0.0.0/24"
      protocol    = "TCP"
      port        = "80"
      description = "allow http from internal"
    }
  ]

  egress_rules = [
    {
      action      = "ACCEPT"
      cidr_block  = "0.0.0.0/0"
      protocol    = "ALL"
      port        = "all"
      description = "allow all outbound"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the security group. | string | n/a | yes |
| description | Description of the security group. | string | null | no |
| project_id | Project ID of the security group. | number | null | no |
| tags | Tags of the security group. | map(string) | null | no |
| ingress_rules | List of ingress rules (see [Rule Object](#rule-object)). The first rule has the highest priority. | list(object) | [] | no |
| egress_rules | List of egress rules (see [Rule Object](#rule-object)). The first rule has the highest priority. | list(object) | [] | no |

### Rule Object

Each rule in `ingress_rules` / `egress_rules` is an object with the following attributes:

| Attribute | Description |
|-----------|-------------|
| action | Rule policy. Valid values: `ACCEPT` and `DROP`. |
| cidr_block | (Optional) An IPv4 address network or CIDR segment. |
| ipv6_cidr_block | (Optional) An IPv6 address network or CIDR segment. |
| protocol | (Optional) IP protocol. Valid values: `TCP`, `UDP`, `ICMP`, `ICMPv6` and `ALL`. |
| port | (Optional) Port range: `all`, a single port (`80`), a range (`80-90`), or comma-separated (`80,90`). If `protocol` is `ALL`, `port` must be `all`. |
| source_security_id | (Optional) ID of a nested source security group. |
| address_template_id | (Optional) Address template ID, e.g. `ipm-xxxxxxxx`. |
| address_template_group | (Optional) Address template group ID, e.g. `ipmg-xxxxxxxx`. |
| service_template_id | (Optional) Protocol/service template ID, e.g. `ppm-xxxxxxxx`. |
| service_template_group | (Optional) Protocol template group ID, e.g. `ppmg-xxxxxxxx`. |
| description | (Optional) Description of the rule. |

**Constraints (enforced by variable validations):**

* Exactly **one** source type must be set: `cidr_block`, `ipv6_cidr_block`, `source_security_id`, `address_template_id`, or `address_template_group`.
* You must set either `protocol` + `port` **or** a `service_template_*` field.
* When `protocol = ALL`, `port` must be `all`.
* `cidr_block` / `ipv6_cidr_block` must be valid CIDR notation.

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-security-group)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
