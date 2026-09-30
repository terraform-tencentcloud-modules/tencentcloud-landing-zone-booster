# terraform-tencentcloud-ccn-route-table
Terraform module which manages CCN route tables and their policies on TencentCloud.

This module uses the following resources to manage CCN route tables:

- `tencentcloud_ccn_route_table` — create CCN route tables.
- `tencentcloud_ccn_route_table_input_policies` — configure route table **input** policies (accept/drop inbound routes).
- `tencentcloud_ccn_route_table_associate_instance_config` — associate network instances with a route table.
- `tencentcloud_ccn_route_table_broadcast_policies` — configure route table **broadcast** policies (accept/drop outbound routes).

## Usage

```hcl
module "ccn_route_table" {
  source = "terraform-tencentcloud-modules/ccn-route-table/tencentcloud"

  ccn_id = "ccn-xxxxxxxx" # ID of the target CCN instance

  # Create CCN route tables
  route_tables = [
    {
      name = "rt-default"
      desc = "default route table"
    }
  ]

  # (Optional) Configure input policies for a route table
  input_policies = [
    {
      route_table_name = "rt-default"
      policies = [
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
    }
  ]

  # (Optional) Associate network instances with a route table
  associate_instances = [
    {
      route_table_name = "rt-default"
      instances = [
        {
          instance_id   = "vpc-abc123"
          instance_type = "VPC"
        }
      ]
    }
  ]

  # (Optional) Configure broadcast policies for a route table
  broadcast_policies = [
    {
      route_table_name = "rt-default"
      policies = [
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
  ]
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
| [tencentcloud_ccn_route_table.route\_tables](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_route_table) | resource |
| [tencentcloud_ccn_route_table_input_policies.input\_policies](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_route_table_input_policies) | resource |
| [tencentcloud_ccn_route_table_associate_instance_config.associate](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_route_table_associate_instance_config) | resource |
| [tencentcloud_ccn_route_table_broadcast_policies.broadcast\_policies](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_route_table_broadcast_policies) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ccn_id"></a> [ccn\_id](#input\_ccn\_id) | CCN instance ID. | `string` | n/a | yes |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | CCN route tables. Each item has `name` and `desc`. | `list(object({ name = string, desc = string }))` | `[]` | no |
| <a name="input_input_policies"></a> [input\_policies](#input\_input\_policies) | CCN route table input policies. | `list(object({ route_table_name = string, policies = list(object({ action = string, desc = string, route_conditions = list(object({ name = string, values = set(string), match_pattern = number })) })) }))` | `[]` | no |
| <a name="input_associate_instances"></a> [associate\_instances](#input\_associate\_instances) | CCN route table associated instances. | `list(object({ route_table_name = string, instances = list(object({ instance_id = string, instance_type = string })) }))` | `[]` | no |
| <a name="input_broadcast_policies"></a> [broadcast\_policies](#input\_broadcast\_policies) | CCN route table broadcast policies. | `list(object({ route_table_name = string, policies = list(object({ action = string, desc = string, route_conditions = list(object({ name = string, values = set(string), match_pattern = number })), broadcast_conditions = list(object({ name = string, values = set(string), match_pattern = number })) })) }))` | `[]` | no |

### Policy condition fields

For `route_conditions` and `broadcast_conditions` in `input_policies` / `broadcast_policies`:

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Condition type. Valid values: `instance-type`, `instance-region`, `instance-id`, `cidr-block`. |
| `values` | `set(string)` | List of conditional values (e.g. `instance-type`: `VPC`, `VPNGW`, `DIRECTCONNECT`; `instance-region`: `ap-guangzhou`; `instance-id`: `vpc-axrsmmrv`; `cidr-block`: `172.0.0.0/8`). |
| `match_pattern` | `number` | Matching mode, `1` = precise matching, `0` = fuzzy matching. |

The policy `action` accepts `accept` or `drop`.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | The ID of the first created CCN route table. |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | A map of all created CCN route table IDs keyed by their index. |
<!-- END_TF_DOCS -->

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
