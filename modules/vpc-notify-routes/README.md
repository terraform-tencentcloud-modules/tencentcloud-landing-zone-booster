# terraform-tencentcloud-vpc-notify-routes
Terraform module which publishes VPC route table entries to a Cloud Connect Network (CCN / VBC) on TencentCloud.

> **Note:** This module wraps `tencentcloud_vpc_notify_routes` (NotifyRoutes API). It publishes the given route item IDs of a route table to CCN. The resource is only created when `route_item_ids` is non-empty.

## Resources created

| Resource | Count | Notes |
|----------|-------|-------|
| `tencentcloud_vpc_notify_routes.notify` | 0..1 | Created only when `length(var.route_item_ids) > 0`. |

## Usage

```hcl
module "vpc_notify_routes" {
  source = "../../../../tc-modules/modules/vpc-notify-routes"

  route_table_id  = "rtb-xxxxxxxx"
  route_item_ids  = ["rti-xxxxxxxx", "rti-yyyyyyyy"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| tencentcloud | >= 1.81.0 |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `route_table_id` | (Required) The ID of the route table (e.g. `rtb-xxxxxxxx`). | `string` | n/a |
| `route_item_ids` | (Optional) List of route item IDs to publish to CCN (e.g. `rti-xxxxxxxx` format). | `list(string)` | `[]` |

## Outputs

| Name | Description |
|------|-------------|
| `published_to_vbc` | Whether the routes have been published to VBC (CCN). |
| `id` | The ID of the notify routes resource. |

## Authors

Maintained by the Boost Life migration / Landing Zone team.

## License

Mozilla Public License Version 2.0.
