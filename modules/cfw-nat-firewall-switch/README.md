# tencentcloud_cfw_nat_firewall_switch module

This Terraform module manages the CFW NAT firewall subnet switch resource on Tencent Cloud (`tencentcloud_cfw_nat_firewall_switch`). It is a small wrapper around the provider resource to turn a subnet switch on or off under a given NAT firewall instance.

## Directory structure

Common files in this module and their purpose:

- `main.tf` — Module entry, declares the `tencentcloud_cfw_nat_firewall_switch` resource.
- `variables.tf` — Input variable definitions and validation (e.g. `enable` must be 0 or 1).
- `outputs.tf` — Exported outputs (e.g. resource `id`).
- `versions.tf` — Provider and Terraform version constraints (if present).
- `examples/` — Example `.tfvars` files demonstrating common scenarios.
- `README.md` — Chinese README for the module.
- `README_EN.md` — This English README.

When changing module inputs/outputs, please update `variables.tf` / `outputs.tf` and these READMEs.

## Overview

This module maps the following key inputs:

- `enable` (number) — Switch state: 0 = off, 1 = on. The module validates the value is 0 or 1.
- `nat_ins_id` (string) — NAT firewall instance ID (ForceNew).
- `subnet_id` (string) — Subnet ID (ForceNew).

The module creates `tencentcloud_cfw_nat_firewall_switch` and exports the resource `id`.

## Variables

See `variables.tf` for full definitions. Summary:

- `enable` must be 0 or 1.
- `nat_ins_id` and `subnet_id` are required and are marked ForceNew (changes replace the resource).

Example usage:

```hcl
module "cfw_nat_subnet_switch" {
  source     = "../../modules/tencentcloud-cfw-nat-firewall-switch"
  enable     = 1
  nat_ins_id = "cfwnat-EXAMPLE-1234"
  subnet_id  = "subnet-EXAMPLE-5678"
}
```

## Outputs

- `id` — The resource ID from `tencentcloud_cfw_nat_firewall_switch`.

## Examples (in `examples/`)

The module includes a few `.tfvars` example files under `examples/`:

1. `enable.tfvars` — Enable the subnet switch (`enable=1`).
2. `disable.tfvars` — Disable the subnet switch (`enable=0`).
3. `example_custom.tfvars` — Placeholder custom example for quick copy-edit-use.

Run an example:

```bash
terraform init
terraform plan -var-file=modules/tencentcloud-cfw-nat-firewall-switch/examples/enable.tfvars
terraform apply -var-file=modules/tencentcloud-cfw-nat-firewall-switch/examples/enable.tfvars
```

Notes:

- `nat_ins_id` and `subnet_id` are ForceNew — changing them will replace the resource. Confirm replacement effects before modifying.
- Ensure your Tencent Cloud credentials have permissions to manage the specified firewall instance and subnet.
- Replace placeholder IDs in examples with real IDs before running `apply`.
