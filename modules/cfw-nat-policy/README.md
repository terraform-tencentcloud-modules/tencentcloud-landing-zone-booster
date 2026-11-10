# tencentcloud_cfw_nat_policy module

This Terraform module manages CFW NAT policies on Tencent Cloud (`tencentcloud_cfw_nat_policy`). It wraps common policy fields and validation to simplify defining NAT-layer access control rules (inbound/outbound).

## Directory structure

Common files in this module and their purpose:

- `main.tf` — Module entry, declares the `tencentcloud_cfw_nat_policy` resource.
- `variables.tf` — Input variable definitions and validation rules.
- `outputs.tf` — Exported outputs (for example `id`, `uuid`).
- `versions.tf` — Provider and Terraform version constraints (if present).
- `examples/` — Example `.tfvars` files demonstrating common scenarios.
- `README.md` — Chinese README for the module.
- `README_EN.md` — This English README.

When modifying the module (adding variables, outputs, or examples), please update `variables.tf` / `outputs.tf` and these READMEs accordingly.

## Overview

This resource defines NAT-level access control policies for inbound (direction=1) and outbound (direction=0) traffic.

Key variables:

- `direction` (number) — 1 inbound, 0 outbound.
- `port` (string) — Port number or `-1` for all ports.
- `protocol` (string) — Protocol, e.g. `TCP`, `UDP`, `ANY` (outbound supports additional protocols).
- `rule_action` (string) — Action: `accept`, `drop`, `log`.
- `source_content` / `source_type` — Source selector (e.g. `net:192.0.2.0/24`).
- `target_content` / `target_type` — Target selector.

Optional fields: `description`, `enable` (string: `"true"`/`"false"`), `param_template_id`, and `scope` (e.g. `ALL`, region, or instance-based scope like `cfwnat-xxx`).

The module creates `tencentcloud_cfw_nat_policy` and exports `id`, `internal_uuid`, and `uuid`.

## Variables

See `variables.tf` for full details. Summary:

- `direction` must be 0 or 1.
- `name` is not required for the policy resource; provide `source_content`/`target_content` and corresponding types.
- `enable` is a string `"true"`/`"false"` (default `"true"`).

Example usage:

```hcl
module "nat_policy_allow_http" {
  source = "../../modules/tencentcloud-cfw-nat-policy"
  direction = 1
  port = "80"
  protocol = "TCP"
  rule_action = "accept"
  source_content = "net:192.0.2.0/24"
  source_type = "net"
  target_content = "net:10.0.0.0/16"
  target_type = "net"
}
```

## Outputs

- `id` — Resource ID.
- `internal_uuid` — Internal ID.
- `uuid` — Global unique rule identifier (returned after creation).

## Examples (in `examples/`)

The module includes several example `.tfvars` files under `examples/`:

1. `inbound_allow_http.tfvars` — Inbound allow for HTTP (port 80).
2. `inbound_drop_ip.tfvars` — Inbound drop a single source IP.
3. `outbound_allow_all.tfvars` — Outbound allow for all ports/protocols (use with caution).
4. `scoped_param_template.tfvars` — Example using `param_template_id` and `scope`.

Run an example:

```bash
terraform init
terraform plan -var-file=modules/tencentcloud-cfw-nat-policy/examples/inbound_allow_http.tfvars
terraform apply -var-file=modules/tencentcloud-cfw-nat-policy/examples/inbound_allow_http.tfvars
```

## Notes

- `source_type` and `target_type` allowed values differ for inbound/outbound; see `variables.tf` descriptions.
- `enable` is a string (`"true"` / `"false"`), not a boolean — ensure you pass a string.
- `scope` can limit a rule to region or instance-level effectiveness, e.g. `ap-guangzhou` or `cfwnat-xxx`.
