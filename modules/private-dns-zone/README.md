# tencentcloud-private-dns-zone

A Terraform module that creates a TencentCloud Private DNS zone (`tencentcloud_private_dns_zone`). A Private DNS zone resolves private domain names within associated VPCs.

> **NOTE:** VPC associations (same-account and cross-account) are managed by the separate `private-dns-vpc-attachment` module and are ignored by this module via `lifecycle.ignore_changes`. To unbind all VPCs from the zone, clearing the declaration will not take effect — you must set the `region` and `uniq_vpc_id` in `vpc_set` to an empty string.

## Usage

```hcl
module "private_dns_zone" {
  source = "terraform-tencentcloud-modules/private-dns-zone/tencentcloud"

  create             = true
  domain             = "example.com"
  remark             = "my private zone"
  dns_forward_status = "DISABLED" # ENABLED or DISABLED

  tags = {
    env = "nonprod"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create | Whether to create the Private DNS zone or not. | bool | true | no |
| domain | The private domain name of the zone (e.g. `example.com`). | string | "" | no |
| dns_forward_status | Whether to enable subdomain recursive DNS. Valid values: `ENABLED`, `DISABLED`. | string | "DISABLED" | no |
| remark | The remark of the domain. | string | "remark" | no |
| tags | Tags to assign to the resource. | map(string) | { env = "nonprod" } | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Private DNS zone. Empty string (`""`) when `create` is false. |
| domain | The private domain name of the zone. |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| tencentcloud | >= 1.81.106 |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-private-dns-zone)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
