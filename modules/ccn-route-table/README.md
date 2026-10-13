# terraform-tencentcloud-ccn-route-table

Terraform module which creates a **single** CCN route table and manages its policies on TencentCloud.

This module uses the following resources:

- `tencentcloud_ccn_route_table` — create a CCN route table.
- `tencentcloud_ccn_route_table_input_policies` — configure route table **input** policies (accept/drop inbound routes).
- `tencentcloud_ccn_route_table_associate_instance_config` — associate network instances with the route table.
- `tencentcloud_ccn_route_table_broadcast_policies` — configure route table **broadcast** policies (accept/drop outbound routes).

> Note: This module manages **one** route table per `module` block. To create multiple route tables, declare multiple `module` blocks (one per route table).

## Usage

```hcl
module "ccn_route_table" {
  source = "terraform-tencentcloud-modules/ccn-route-table/tencentcloud"

  ccn_id = "ccn-xxxxxxxx" # ID of the target CCN instance

  # Create one CCN route table and its policies
  ccn_route_table = {
    name = "rt-default"
    desc = "default route table"

    # (Optional) Configure input policies for the route table
    input_policies = [
      {
        action = "accept"
        desc   = "accept vpc routes"
        route_conditions = [
          {
            name          = "instance-type"
            values        = ["VPC"]
            match_pattern = 1 # 1 = precise matching, 0 = fuzzy matching
          }
        ]
      }
    ]

    # (Optional) Associate network instances with the route table
    associate_instances = [
      {
        instance_id   = "vpc-abc123"
        instance_type = "VPC"
      }
    ]

    # (Optional) Configure broadcast policies for the route table
    broadcast_policies = [
      {
        action = "accept"
        desc   = "broadcast to vpc"
        route_conditions = [
          {
            name          = "instance-type"
            values        = ["VPC"]
            match_pattern = 1
          }
        ]
        broadcast_conditions = [
          {
            name          = "instance-region"
            values        = ["ap-guangzhou"]
            match_pattern = 1
          }
        ]
      }
    ]
  }
}
```

## Examples

- [Complete](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-ccn-route-table/tree/master/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.136 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.136 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_ccn_route_table.route\_table](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_route_table) | resource |
| [tencentcloud_ccn_route_table_input_policies.input\_policies](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_route_table_input_policies) | resource |
| [tencentcloud_ccn_route_table_associate_instance_config.associate](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_route_table_associate_instance_config) | resource |
| [tencentcloud_ccn_route_table_broadcast_policies.broadcast\_policies](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_route_table_broadcast_policies) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ccn_id"></a> [ccn\_id](#input\_ccn\_id) | CCN instance ID. | `string` | n/a | yes |
| <a name="input_ccn_route_table"></a> [ccn\_route\_table](#input\_ccn\_route\_table) | CCN Route table config. | <a name="object_ccn_route_table"></a> object({<br>name = string,<br>desc = optional(string),<br>input_policies = optional(list(object({<br>action = string,<br>desc = optional(string),<br>route_conditions = list(object({<br>name = string,<br>values = list(string),<br>match_pattern = optional(number, 1)<br>}))<br>})), []),<br>associate_instances = optional(list(object({<br>instance_id = string,<br>instance_type = string<br>})), []),<br>broadcast_policies = optional(list(object({<br>action = string,<br>desc = optional(string),<br>route_conditions = list(object({<br>name = string,<br>values = list(string),<br>match_pattern = optional(number, 1)<br>})),<br>broadcast_conditions = list(object({<br>name = string,<br>values = list(string),<br>match_pattern = optional(number, 1)<br>}))<br>})), [])<br>}) | n/a | yes |

### Policy condition fields

For `route_conditions` and `broadcast_conditions` in `input_policies` / `broadcast_policies`:

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Condition type. Valid values: `instance-type`, `instance-region`, `instance-id`, `cidr-block`. |
| `values` | `list(string)` | List of conditional values (e.g. `instance-type`: `VPC`, `VPNGW`, `DIRECTCONNECT`; `instance-region`: `ap-guangzhou`; `instance-id`: `vpc-axrsmmrv`; `cidr-block`: `172.0.0.0/8`). |
| `match_pattern` | `number` | Matching mode, `1` = precise matching, `0` = fuzzy matching. Defaults to `1`. |

The policy `action` accepts `accept` or `drop`. The `instance_type` in `associate_instances` accepts `VPC`, `DIRECTCONNECT`, `BMVPC`, `EDGE`, `EDGE_TUNNEL`, `EDGE_VPNGW`, `VPNGW`.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | The ID of the CCN route table. |
<!-- END_TF_DOCS -->

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
