# tencentcloud_cfw_vpc_instance module

This Terraform module provisions a VPC firewall (firewall group / VPC instance) on Tencent Cloud using the `tencentcloud_cfw_vpc_instance` resource.

## Overview

The module encapsulates group-level firewall creation and deployment of multiple firewall instances. It supports private network mode and CCN (Cloud Connect Network) mode. The `vpc_fw_instances` nested object describes instances and their regional/zone deployment (`fw_deploy`).

Typical uses: centralized firewall group across VPCs or regions, CCN-based centralized firewall management, or custom firewall network CIDR.

## Directory structure

- `main.tf` — Module entry; declares `tencentcloud_cfw_vpc_instance` and handles dynamic `vpc_fw_instances` blocks.
- `variables.tf` — Input variable definitions (including object structure for `vpc_fw_instances`).
- `outputs.tf` — Module outputs (`id`).
- `examples/` — Example `*.tfvars` files illustrating common deployment cases.
- `README.md` — Chinese documentation.
- `README_EN.md` — English documentation (this file).

When changing the module interface, update variables and documentation accordingly.

## Inputs (Variables)

Required:

- `mode` (number) — 0 = private network mode; 1 = CCN mode. Must be 0 or 1.
- `name` (string) — Firewall (group) name.
- `switch_mode` (number) — Switch mode: 1 (single point), 2 (multi-point), 4 (custom routing).
- `vpc_fw_instances` (list(object)) — List of firewall instances. Each item:
  - `name` (string)
  - `vpc_ids` (optional set(string)) — associated VPC IDs
  - `fw_deploy` (list(object)) — deployment entries each with:
    - `deploy_region` (string)
    - `width` (number)
    - `zone_set` (set(string))
    - `cross_a_zone` (optional number)

Optional:

- `ccn_id` (string) — Cloud Connect Network ID (for CCN mode).
- `fw_vpc_cidr` (string, default `auto`) — Firewall VPC CIDR; use `auto` or specify a CIDR like `10.10.10.0/24`.

## Outputs

- `id` — Terraform resource ID.

## Examples

The `examples/` directory contains var files for common scenarios (replace placeholders with real values):

1) Basic private mode — `examples/basic_private.tfvars` (mode=0)
2) CCN mode — `examples/ccn_mode.tfvars` (mode=1, with ccn_id)
3) Multi-instance multi-region — `examples/multi_instances.tfvars`
4) Custom firewall CIDR — `examples/custom_cidr.tfvars`

## Usage

Call the module and pass variables or use `-var-file` pointing to an example:

```hcl
module "cfw_vpc" {
  source = "../../modules/tencentcloud-cfw-vpc-instance"

  mode = var.mode
  name = var.name
  switch_mode = var.switch_mode
  vpc_fw_instances = var.vpc_fw_instances
  # optional
  # ccn_id = var.ccn_id
  # fw_vpc_cidr = var.fw_vpc_cidr
}
```

Quick test:

```bash
terraform init
terraform plan -var-file=examples/basic_private.tfvars
terraform apply -var-file=examples/basic_private.tfvars
```

Be careful: apply will create real resources; test in non-production when possible.

## Notes & troubleshooting

- For `mode=1` (CCN), provide `ccn_id` and ensure network/policy are prepared.
- Updating `vpc_fw_instances` may cause resource changes; plan carefully.
- Ensure `fw_vpc_cidr` doesn't conflict with existing networks.
