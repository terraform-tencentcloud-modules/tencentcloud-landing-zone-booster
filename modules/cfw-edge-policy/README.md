# tencentcloud_cfw_edge_policy module

This Terraform module manages CFW edge firewall access control policies on Tencent Cloud (`tencentcloud_cfw_edge_policy`). It wraps common policy fields and validation to simplify defining edge-layer inbound and outbound access control rules, and applies rule ordering via `tencentcloud_cfw_edge_policy_order_config`.

## Directory structure

Common files in this module and their purpose:

- `main.tf` — Module entry, declares the `tencentcloud_cfw_edge_policy` resources (inbound and outbound) and the `tencentcloud_cfw_edge_policy_order_config` for ordering.
- `variables.tf` — Input variable definitions (two policy lists: `inbound_policies` and `outbound_policies`).
- `outputs.tf` — Exported outputs (`inbound_uuids`, `outbound_uuids`).
- `versions.tf` — Provider and Terraform version constraints (if present).
- `examples/` — Example `.tfvars` files demonstrating common scenarios.
- `README.md` — Chinese README for the module.
- `README_EN.md` — This English README.

When modifying the module (adding variables, outputs, or examples), please update `variables.tf` / `outputs.tf` and these READMEs accordingly.

## Overview

This module manages edge-layer access control policies in two directions:

- **Inbound** — created from `var.inbound_policies` with `direction = 1`.
- **Outbound** — created from `var.outbound_policies` with `direction = 0`.

Each policy entry supports the following fields:

- `port` (string) — Port for the access control policy. `-1/-1` means all ports; `80` means port 80.
- `protocol` (string) — Protocol. For inbound (`direction=1`): `TCP`, `UDP`, `ANY`. For outbound (`direction=0`): `TCP`, `UDP`, `ICMP`, `ANY`, `HTTP`, `HTTPS`, `HTTP/HTTPS`, `SMTP`, `SMTPS`, `SMTP/SMTPS`, `FTP`, `DNS`.
- `rule_action` (string) — How traffic passes through the firewall: `accept`, `drop`, `log`.
- `source_content` (string) — Access source, e.g. `net:192.168.0.2` or `net:1.1.1.1/0`.
- `source_type` (string) — Access source type. Inbound: `net`, `location`, `vendor`, `template`. Outbound: `net`, `instance`, `tag`, `template`, `group`.
- `target_content` (string) — Access target, e.g. `net:192.168.0.2` or `domain:*.qq.com`. A tag target can be expressed as a JSON map, e.g. `{"Key":"test","Value":"dddd"}`.
- `target_type` (string) — Access target type. Inbound: `net`, `instance`, `tag`, `template`, `group`. Outbound: `net`, `location`, `vendor`, `template`.
- `enable` (optional string, default `"true"`) — Rule status; `"true"` enabled, `"false"` disabled.
- `scope` (optional string, default `"ALL"`) — Effective scope. `ALL` = global; a region like `ap-guangzhou` = regional; an instance id like `cfwnat-xxx` = instance-level.
- `description` (optional string, default `""`) — Description.
- `param_template_id` (optional string) — Parameter template id (may be null).

The module creates the inbound/outbound `tencentcloud_cfw_edge_policy` resources, configures their order via `tencentcloud_cfw_edge_policy_order_config`, and exports the rule UUID lists.

## Variables

See `variables.tf` for full details. Summary:

- `inbound_policies` (list(object)) — List of inbound (direction=1) edge policies. Each object has the fields described in Overview (with `enable`/`scope`/`description`/`param_template_id` optional).
- `outbound_policies` (list(object)) — List of outbound (direction=0) edge policies. Same object schema as `inbound_policies`.

Example usage:

```hcl
module "edge_policy" {
  source = "../../modules/tencentcloud-cfw-edge-policy"

  inbound_policies = [
    {
      port           = "-1/-1"
      protocol       = "TCP"
      rule_action    = "drop"
      source_content = "1.1.1.1/0"
      source_type    = "net"
      target_content = "0.0.0.0/0"
      target_type    = "net"
      enable         = "true"
      scope          = "ALL"
      description    = "drop all inbound tcp"
    }
  ]

  outbound_policies = [
    {
      port           = "-1/-1"
      protocol       = "TCP"
      rule_action    = "drop"
      source_content = "0.0.0.0/0"
      source_type    = "net"
      target_content = jsonencode({ "Key" = "test", "Value" = "dddd" })
      target_type    = "tag"
      enable         = "true"
      scope          = "ALL"
      description    = "drop outbound to tagged target"
    }
  ]
}
```

## Outputs

- `inbound_uuids` — List of inbound rule UUIDs (`tencentcloud_cfw_edge_policy.inbounds[*].uuid`).
- `outbound_uuids` — List of outbound rule UUIDs (`tencentcloud_cfw_edge_policy.outbounds[*].uuid`).

## Examples (in `examples/`)

The module includes example `.tfvars` files under `examples/`:

1. `net_target.tfvars` — Inbound drop policy whose target is a CIDR network (`target_type = "net"`).
2. `tag_target.tfvars` — Inbound drop policy whose target is a tag (`target_type = "tag"`, expressed as a JSON map).

Run an example:

```bash
terraform init
terraform plan -var-file=modules/tencentcloud-cfw-edge-policy/examples/net_target.tfvars
terraform apply -var-file=modules/tencentcloud-cfw-edge-policy/examples/net_target.tfvars
```

## Notes

- `source_type` and `target_type` allowed values differ between inbound and outbound rules; see `variables.tf` descriptions for the full lists.
- `enable` is a string (`"true"` / `"false"`), not a boolean — ensure you pass a string.
- `scope` can limit a rule to global, regional, or instance-level effectiveness, e.g. `ALL`, `ap-guangzhou`, or `cfwnat-xxx`.
- Policy ordering is applied automatically via `tencentcloud_cfw_edge_policy_order_config` based on the order of entries in `inbound_policies` / `outbound_policies`.
