# tencentcloud-private-dns-vpc-attachment

A Terraform module that associates VPCs with a TencentCloud Private DNS zone (`tencentcloud_private_dns_zone_vpc_attachment`). It supports both same-account VPC associations (`vpc_sets`) and cross-account VPC associations (`account_vpc_sets`).

> **NOTE:** To bind a VPC owned by account B while managing it from account A, you must first grant role authorization to account A.

## Usage

```hcl
module "private_dns_vpc_attachment" {
  source = "terraform-tencentcloud-modules/private-dns-vpc-attachment/tencentcloud"

  create               = true
  private_dns_zone_id = "zone-xxxxxxxx"

  # Same-account VPC association
  vpc_sets = {
    vpc1 = {
      region      = "ap-guangzhou"
      uniq_vpc_id = "vpc-xxxxxxxx"
    }
  }

  # Cross-account VPC association
  account_vpc_sets = {
    cross_vpc = {
      uniq_vpc_id = "vpc-yyyyyyyy"
      region      = "ap-guangzhou"
      uin         = "100000000001" # VPC owner UIN; grant role authorization to this account first
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create | Whether to create the VPC attachments or not. | bool | true | no |
| private_dns_zone_id | The ID of the Private DNS zone to associate VPCs with (used as `zone_id`). | string | "" | no |
| vpc_sets | Same-account VPC set for the Private DNS zone. Each entry has `region` (VPC region) and `uniq_vpc_id` (unique VPC ID). | map(object({ region = string, uniq_vpc_id = string })) | see `variables.tf` (an `example` entry) | no |
| account_vpc_sets | Cross-account VPC set for the Private DNS zone. Each entry has `uniq_vpc_id` (unique VPC ID), `region` (VPC region) and `uin` (VPC owner UIN; grant role authorization to this account first). | map(object({ uniq_vpc_id = string, region = string, uin = string })) | see `variables.tf` (an `example` entry) | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_sets | The map of same-account VPC sets that was provided as input. |
| account_vpc_sets | The map of cross-account VPC sets that was provided as input. |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| tencentcloud | >= 1.81.106 |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-private-dns-vpc-attachment)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
