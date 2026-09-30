# tencentcloud_cfw_vpc_policy

This module creates a Tencent Cloud CFW VPC policy using Terraform.

## Directory structure

- `main.tf` - resource definition
- `variables.tf` - module inputs
- `outputs.tf` - module outputs
- `examples/` - example `*.tfvars` files for `terraform plan -var-file=examples/*.tfvars`

## Overview
This module creates a VPC firewall policy (access control rule) under the specified firewall instance (or `ALL` by default). It is typically used to allow or block traffic from specific sources to destinations.

## Inputs

| Name | Type | Required | Default | Description |
|---|---:|:---:|---|---|
| `description` | string | yes | — | Rule description |
| `dest_content` | string | yes | — | Destination content, e.g. `net:192.168.0.0/24` or `domain:*.example.com` |
| `dest_type` | string | yes | — | Destination type: `net` or `template` |
| `port` | string | yes | — | Port, `-1` means all ports, or a specific port like `80` |
| `protocol` | string | yes | — | Protocol, see allowed values in `variables.tf` (e.g. `TCP`, `UDP`, `HTTP`) |
| `rule_action` | string | yes | — | Action: `accept` / `drop` / `log` |
| `source_content` | string | yes | — | Source content, e.g. `net:10.0.0.0/16` |
| `source_type` | string | yes | — | Source type: `net` or `template` |
| `enable` | string | no | `true` | Rule enabled: `true` or `false` |
| `fw_group_id` | string | no | `ALL` | Firewall instance ID, default is ALL |

Note: `enable` uses string values `"true"` / `"false"` to match module variable definition.

## Outputs

| Name | Description |
|---|---|
| `id` | Resource ID |
| `beta_list` | Beta information (may be null) |
| `fw_group_name` | Firewall group name |
| `internal_uuid` | Internal uuid |
| `param_template_id` | Parameter template id (may be null) |
| `param_template_name` | Parameter template name (may be null) |
| `uuid` | Unique uuid of the rule |

## Examples

Examples are in the `examples/` directory. Example usage:

```bash
terraform init
terraform plan -var-file=examples/basic_allow.tfvars
```

Provided examples:

- `basic_allow.tfvars`: Minimal allow rule (source net -> dest net, all ports).
- `drop_http.tfvars`: Drop HTTP access to a domain from a source net (port 80).
- `template_block.tfvars`: Example using `template` type for destination.
- `disabled_rule.tfvars`: Create a rule but keep it disabled (`enable = "false"`).

## Notes

- Do not commit real secrets into the repository.
- `fw_group_id = "ALL"` applies the rule to all firewall instances; pass a specific `fw_group_id` to scope to a single instance.
- `terraform apply` will create real resources in Tencent Cloud. Always validate with `plan` first.
