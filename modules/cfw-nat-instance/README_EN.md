# tencentcloud_cfw_nat_instance module

This Terraform module manages a Cloud Firewall (CFW) NAT instance on Tencent Cloud (`tencentcloud_cfw_nat_instance`). It provides a lightweight wrapper around the provider resource and validates common inputs to simplify reuse across environments.

## Directory structure

Common files in this module and their purpose:

- `main.tf` — Module entry, declares the `tencentcloud_cfw_nat_instance` resource and dynamic blocks.
- `variables.tf` — Input variable definitions and validation rules.
- `outputs.tf` — Exported outputs (for example the resource `id`).
- `versions.tf` — Provider and Terraform version constraints (if present).
- `examples/` — Example `.tfvars` files demonstrating common scenarios.
- `README.md` — Chinese README for the module.
- `README_EN.md` — This English README.

When you modify the module (add variables, outputs, or examples), please update `variables.tf` / `outputs.tf` and these READMEs accordingly.

## Overview

Key fields mapped by the module:

- `mode` (number) — 1 means access mode; 0 means new mode. Validated to be 0 or 1.
- `name` (string) — Instance name.
- `width` (number) — Bandwidth.
- `zone_set` (set(string)) — A set of zones.
- `cross_a_zone` (number, optional) — Cross-zone/disaster recovery toggle (0 or 1), default 0.
- `nat_gw_list` (set(string), optional) — For access mode: list of NAT gateways to attach.
- `new_mode_items` (list(object), optional) — For new mode: list of objects each containing `eips` (set of EIPs) and `vpc_list` (set of VPCs).

The module creates `tencentcloud_cfw_nat_instance` and exports `id`.

## Variables

See `variables.tf`. Summary:

- `mode` must be 0 or 1.
- `name`, `width`, `zone_set` are required.
- `cross_a_zone` defaults to 0.
- Provide at least one of `nat_gw_list` or `new_mode_items` according to the selected mode.

Example usage:

```hcl
module "cfw_nat" {
  source = "../../modules/tencentcloud-cfw-nat-instance"
  mode   = 0
  name   = "example-cfw-nat"
  width  = 100
  zone_set = ["ap-guangzhou-1"]
  new_mode_items = [
    {
      eips = ["1.2.3.4"]
      vpc_list = ["vpc-xxx"]
    }
  ]
}
```

## Outputs

- `id` — The resource ID from `tencentcloud_cfw_nat_instance`.

## Examples (in `examples/`)

This module includes several `.tfvars` example files under `examples/`:

1. `new_mode.tfvars` — New mode (mode=0), passing `new_mode_items` with EIPs and VPC lists.
2. `access_mode.tfvars` — Access mode (mode=1), using `nat_gw_list` to attach NAT gateways.
3. `cross_zone.tfvars` — Example enabling cross-zone (`cross_a_zone=1`).
4. `mixed.tfvars` — Mixed example with multiple zones and larger bandwidth.

Run the examples with:

```bash
terraform init
terraform plan -var-file=modules/tencentcloud-cfw-nat-instance/examples/new_mode.tfvars
terraform apply -var-file=modules/tencentcloud-cfw-nat-instance/examples/new_mode.tfvars
```

## Notes

- `mode` determines which connection parameters are applicable. For access mode, use `nat_gw_list`. For new mode, use `new_mode_items` with `eips` and `vpc_list`.
- Ensure `zone_set` is supported in your chosen region and account quota.
- If you want me to include `versions.tf` contents here or add a complete caller example (`examples/complete/` with `main.tf`), I can add that.
