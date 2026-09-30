# TencentCloud Unified CLB Module for Terraform

Unified Terraform module under `modules/clb` that consolidates the previously
separate `clb-instance`, `clb-log`, `clb-listener`, `clb-target-group`,
`clb-redirection` and `clb-config` modules into a single self-contained module.

It is part of the `network` building block of the tencentcloud-landing-zone-booster framework.

## Features

- Provision a public (`OPEN`) or private (`INTERNAL`) CLB instance with VIP, IP version and internet billing options.
- Optional automatic creation of CLB log set / log topic and binding them to the instance via CLS log attachment.
- Optional SLA (LCU-supported) configuration.
- Optional SNAT and security group binding for backend targets.
- Create listeners (HTTP / HTTPS / TCP / UDP / TCP_SSL / QUIC) with optional Layer-7 rules and target bindings.
- Create target groups with instance attachments.
- Configure listener/rule redirections (including auto rewrite).
- Apply CLB customized configs to the instance.

## Usage

```hcl
module "clb" {
  source = "path/to/modules/clb"

  clb_instance = {
    clb_name = "example-clb"
    vpc_id   = "vpc-xxxxxxxx"
    # ... see variables.tf for the full object definition
  }

  # optional collections
  clb_listeners = [
    {
      listener_name = "http-80"
      port          = 80
      protocol      = "HTTP"
      listener_rules = [
        {
          domain = "example.com"
          url    = "/"
          target_instance = {
            enabled = true
            targets = [{ port = 8080, weight = 10 }]
          }
        }
      ]
    }
  ]

  clb_target_groups = []
  clb_redirections  = []
  clb_custom_configs = []
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | >= 1.81.136 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `clb_instance` | CLB instance configuration (single composite object). | `object(...)` | n/a | yes |
| `clb_listeners` | List of CLB listeners with optional rules and target bindings. | `list(object(...))` | `[]` | no |
| `clb_target_groups` | List of CLB target groups with optional instance attachments. | `list(object(...))` | `[]` | no |
| `clb_redirections` | List of CLB redirection configs. | `list(object(...))` | `[]` | no |
| `clb_custom_configs` | List of CLB customized configs applied to the instance. | `list(object(...))` | `[]` | no |

See `variables.tf` for the full type definitions.

## Outputs

| Name | Description |
|------|-------------|
| `clb_id` | The ID of the clb instance. |
| `clb_name` | The name of the clb instance. |
| `clb_vips` | The virtual service address table of the CLB. |
| `clb_domain` | Domain name of the CLB instance. |
| `clb_log_set_id` | The id of log set. |
| `clb_log_topic_id` | The id of log topic. |
| `listener_ids` | Map of listener index to listener id. |
| `rule_ids` | Map of listener_rule key (`listener_idx.rule_idx`) to rule id. |
| `target_group_ids` | Map of target group index to target group id. |
| `redirection_ids` | List of clb redirection ids. |
| `custom_config_ids` | Map of custom config index to config id. |

## Notes

- CLB log set/topic are created automatically only when `clb_instance.create_clb_log = true` and the corresponding `log_set_id` / `log_topic_id` are not provided; the created log set/topic are then bound to the instance via `tencentcloud_clb_cls_log_attachment`.
- Tags `owner`, `tke-clusterId`, `ccs-clusterId`, and `last-modified` are preserved and ignored on changes.
- For public (`OPEN`) CLB, `availability_zone`, `master_availability_zone`, and `slave_availability_zone` support cross-AZ DR.
- The legacy `modules/clb-*` (instance / log / listener / target-group / redirection / config) modules are retained for backward compatibility and are now superseded by this unified module.

## License

See [LICENSE](../../LICENSE) for full details.
