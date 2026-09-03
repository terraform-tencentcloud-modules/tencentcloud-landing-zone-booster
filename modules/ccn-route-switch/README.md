# terraform-tencentcloud-ccn-route-switch
Terraform module which publishes/withdraws CCN routes to/from a Cloud Connect Network (CCN) on TencentCloud.

> **Note:** This module wraps `tencentcloud_ccn_routes`. Set `switch = "on"` to publish a route to the CCN and `switch = "off"` to withdraw it. Routes are keyed by list index.

## Resources created

| Resource | Count | Notes |
|----------|-------|-------|
| `tencentcloud_ccn_routes.switch` | 0..N | One per entry in `var.routes`, created via `for_each`. |

## Usage

```hcl
module "ccn_route_switch" {
  source = "../../../../tc-modules/modules/ccn-route-switch"

  ccn_id = "ccn-xxxxxxxx"
  routes = [
    {
      route_id = "rtb-route-xxxx1"
      switch   = "on"    # publish to CCN
    },
    {
      route_id = "rtb-route-xxxx2"
      switch   = "off"   # withdraw from CCN
    }
  ]
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
| `ccn_id` | (Required) CCN instance ID. | `string` | n/a |
| `routes` | (Optional) List of routes to publish/withdraw from CCN. `switch` defaults to `"on"`. | `list(object({ route_id = string, switch = optional(string, "on") }))` | `[]` |

### `routes` object

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `route_id` | Route ID to publish/withdraw. | `string` | n/a |
| `switch` | `on`: publish to CCN, `off`: withdraw from CCN. | `string` | `"on"` |

## Outputs

| Name | Description |
|------|-------------|
| `published_routes` | Map of CCN routes (keyed by list index) with their `route_id` and `switch` state. |

## Authors

Maintained by the Boost Life migration / Landing Zone team.

## License

Mozilla Public License Version 2.0.
