# terraform-tencentcloud-vpc-subnet

Terraform module which creates a **VPC Subnet** on TencentCloud.

The following resources are included.

* [Subnet](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/subnet)

This module creates a single `tencentcloud_subnet` in the specified VPC and can optionally bind it to a route table. The `tags` and `subnet_tags` maps are merged onto the subnet.

## Usage

```hcl
module "vpc_subnet" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-subnet.git"

  vpc_id            = "vpc-xxxxxxxx"
  subnet_name       = "example-subnet"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "ap-guangzhou-3"
  subnet_is_multicast = true
  route_table_id    = "rtb-azd4dt1c"

  tags = {
    "createdBy" = "Terraform"
  }
  subnet_tags = {
    "env" = "prod"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | The VPC ID in which to create the subnet. | string | `"1"` | no |
| subnet_name | The name of the subnet. | string | `"subnet"` | no |
| subnet_cidr | The CIDR block of the subnet. | string | n/a | yes |
| subnet_is_multicast | Whether the subnet is multicast. | bool | `true` | no |
| availability_zone | The availability zone of the subnet. | string | `""` | no |
| route_table_id | The route table ID to associate with the subnet. | string | null | no |
| tags | A map of tags to add to the subnet. | map(string) | `{}` | no |
| subnet_tags | Additional tags for the subnet (merged with `tags`). | map(string) | `{}` | no |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-subnet)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
