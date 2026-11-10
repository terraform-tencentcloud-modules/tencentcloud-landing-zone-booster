# terraform-tencentcloud-vpc-route-table-association

Terraform module which associates a **subnet** with a **route table** on TencentCloud.

The following resources are included.

* [Route Table Association](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/route_table_association)

This module binds a subnet to a route table so that the subnet's traffic is routed according to that route table.

## Usage

```hcl
module "vpc_route_table_association" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-route-table-association.git"

  route_table_id = "rtb-azd4dt1c"
  subnet_id      = "subnet-3x5lf5q0"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| route_table_id | The route table instance ID, such as `rtb-azd4dt1c`. | string | n/a | yes |
| subnet_id | The subnet instance ID, such as `subnet-3x5lf5q0`. This can be queried using the DescribeSubnets API. | string | n/a | yes |

> Only `route_table_id` and `subnet_id` are consumed by this module's resource.

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-route-table-association)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
