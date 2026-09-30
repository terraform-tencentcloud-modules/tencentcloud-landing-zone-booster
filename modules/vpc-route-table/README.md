# terraform-tencentcloud-vpc-route-table

Terraform module which creates a **VPC Route Table** and its **route entries** on TencentCloud.

The following resources are included.

* [Route Table](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/route_table)
* [Route Table Entry](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/route_table_entry)

A single `tencentcloud_route_table` is always created in the specified VPC. One `tencentcloud_route_table_entry` is created per element of `destination_cidrs` (zero route entries are created when the list is empty).

## Usage

```hcl
module "vpc_route_table" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-route-table.git"

  vpc_id          = "vpc-xxxxxxxx"
  route_table_name = "example-rt"
  tags = {
    "createdBy" = "Terraform"
  }

  destination_cidrs = [
    {
      destination_cidr = "10.0.1.0/24"
      next_type        = "NAT"
      next_hub         = "nat-xxxxxxxx"
    },
    {
      destination_cidr = "0.0.0.0/0"
      next_type        = "EIP"
      next_hub         = "0"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | The VPC ID in which to create the route table. | string | `""` | no |
| route_table_name | The name of the route table. | string | `""` | no |
| tags | Tags of the route table. | map(string) | `{}` | no |
| destination_cidrs | List of route entries to create. Each element is an object (see below). | list(object) | `[]` | no |

### `destination_cidrs` object attributes

| Attribute | Description |
|-----------|-------------|
| destination_cidr | Destination address block, e.g. `10.0.1.0/24`. |
| next_type | Type of next hop. Valid values: `CVM`, `VPN`, `DIRECTCONNECT`, `PEERCONNECTION`, `HAVIP`, `NAT`, `NORMAL_CVM`, `EIP`, `LOCAL_GATEWAY`, `INTRANAT`, `USER_CCN` and `GWLB_ENDPOINT`. |
| next_hub | ID of next-hop gateway. Note: when `next_type` is `EIP`, `next_hub` should be `0`. |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-route-table)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
